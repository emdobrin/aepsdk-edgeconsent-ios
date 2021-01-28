/*
 Copyright 2021 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

@testable import AEPConsent
import AEPCore
import XCTest

class ConsentFunctionalTests: XCTestCase {
    var mockRuntime: TestableExtensionRuntime!
    var consent: Consent!

    override func setUp() {
        mockRuntime = TestableExtensionRuntime()
        consent = Consent(runtime: mockRuntime)
        consent.onRegistered()
        mockRuntime.resetDispatchedEventAndCreatedSharedStates()
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }

    // MARK: Consent update event processing

    /// No event should be dispatched and no shared state should be created
    func testConsentUpdateNilData() {
        // setup
        let consentUpdateEvent = Event(name: "Consent Update", type: "com.adobe.eventType.consent", source: EventSource.requestContent, data: nil)

        // test
        mockRuntime.simulateComingEvents(consentUpdateEvent)

        // verify
        XCTAssertTrue(mockRuntime.dispatchedEvents.isEmpty)
        XCTAssertTrue(mockRuntime.createdSharedStates.isEmpty)
    }

    /// No event should be dispatched and no shared state should be created
    func testConsentUpdateEmptyData() {
        // setup
        let consentUpdateEvent = Event(name: "Consent Update", type: "com.adobe.eventType.consent", source: EventSource.requestContent, data: [:])

        // test
        mockRuntime.simulateComingEvents(consentUpdateEvent)

        // verify
        XCTAssertTrue(mockRuntime.dispatchedEvents.isEmpty)
        XCTAssertTrue(mockRuntime.createdSharedStates.isEmpty)
    }

    /// No event should be dispatched and no shared state should be created
    func testConsentUpdateWrongData() {
        // setup
        let consentUpdateEvent = Event(name: "Consent Update", type: "com.adobe.eventType.consent", source: EventSource.requestContent, data: ["wrong": "format"])

        // test
        mockRuntime.simulateComingEvents(consentUpdateEvent)

        // verify
        XCTAssertTrue(mockRuntime.dispatchedEvents.isEmpty)
        XCTAssertTrue(mockRuntime.createdSharedStates.isEmpty)
    }

    func testConsentUpdateHappy() {
        // test
        let event = buildFirstConsentUpdateEvent()
        mockRuntime.simulateComingEvents(event)

        // verify
        XCTAssertEqual(1, mockRuntime.createdXdmSharedStates.count)

        // verify shared state data
        let sharedState = mockRuntime.createdXdmSharedStates.first!
        let sharedStatePreferencesData = try! JSONSerialization.data(withJSONObject: sharedState!, options: [])
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let sharedStatePreferences = try! decoder.decode(ConsentPreferences.self, from: sharedStatePreferencesData)

        var expectedConsents = Consents(metadata: ConsentMetadata(time: event.timestamp))
        expectedConsents.adId = ConsentValue(val: .no)
        expectedConsents.collect = ConsentValue(val: .yes)
        let expectedPreferences = ConsentPreferences(consents: expectedConsents)

        XCTAssertEqual(expectedPreferences.consents.adId, sharedStatePreferences.consents.adId)
        XCTAssertEqual(expectedPreferences.consents.collect, sharedStatePreferences.consents.collect)
        XCTAssertEqual(expectedPreferences.consents.metadata!.time.iso8601String, sharedStatePreferences.consents.metadata!.time.iso8601String)
    }

    func testConsentUpdateMergeHappy() {
        // test
        let firstEvent = buildFirstConsentUpdateEvent()
        let secondEvent = buildSecondConsentUpdateEvent()
        mockRuntime.simulateComingEvents(firstEvent, secondEvent)

        // verify
        XCTAssertEqual(2, mockRuntime.createdXdmSharedStates.count)

        // verify first shared state data
        let sharedState = mockRuntime.createdXdmSharedStates.first!
        let sharedStatePreferencesData = try! JSONSerialization.data(withJSONObject: sharedState!, options: [])
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let sharedStatePreferences = try! decoder.decode(ConsentPreferences.self, from: sharedStatePreferencesData)

        var expectedConsents = Consents(metadata: ConsentMetadata(time: firstEvent.timestamp))
        expectedConsents.adId = ConsentValue(val: .no)
        expectedConsents.collect = ConsentValue(val: .yes)
        let expectedPreferences = ConsentPreferences(consents: expectedConsents)

        XCTAssertEqual(expectedPreferences.consents.adId, sharedStatePreferences.consents.adId)
        XCTAssertEqual(expectedPreferences.consents.collect, sharedStatePreferences.consents.collect)
        XCTAssertEqual(expectedPreferences.consents.metadata!.time.iso8601String, sharedStatePreferences.consents.metadata!.time.iso8601String)

        // verify second shared state data
        let sharedState2 = mockRuntime.createdXdmSharedStates.last!
        let sharedStatePreferencesData2 = try! JSONSerialization.data(withJSONObject: sharedState2!, options: [])
        let sharedStatePreferences2 = try! decoder.decode(ConsentPreferences.self, from: sharedStatePreferencesData2)

        var expectedConsents2 = Consents(metadata: ConsentMetadata(time: secondEvent.timestamp))
        expectedConsents2.adId = ConsentValue(val: .no)
        expectedConsents2.collect = ConsentValue(val: .no)
        let expectedPreferences2 = ConsentPreferences(consents: expectedConsents2)

        XCTAssertEqual(expectedPreferences2.consents.adId, sharedStatePreferences2.consents.adId)
        XCTAssertEqual(expectedPreferences2.consents.collect, sharedStatePreferences2.consents.collect)
        XCTAssertEqual(expectedPreferences2.consents.metadata!.time.iso8601String, sharedStatePreferences2.consents.metadata!.time.iso8601String)
    }

    private func buildFirstConsentUpdateEvent() -> Event {
        let date = Date()
        let rawEventData = """
                    {
                      "consents" : {
                        "adId" : {
                          "val" : "n"
                        },
                        "collect" : {
                          "val" : "y"
                        },
                        "metadata" : {
                          "time" : "\(date.iso8601String)"
                        }
                      }
                    }
                   """.data(using: .utf8)!

        let eventData = try! JSONSerialization.jsonObject(with: rawEventData, options: []) as? [String: Any]
        return Event(name: "Consent Update", type: EventType.consent, source: EventSource.requestContent, data: eventData)
    }

    private func buildSecondConsentUpdateEvent() -> Event {
        let date = Date()
        let rawEventData = """
                    {
                      "consents" : {
                        "collect" : {
                          "val" : "n"
                        },
                        "metadata" : {
                          "time" : "\(date.iso8601String)"
                        }
                      }
                    }
                   """.data(using: .utf8)!
        let eventData = try! JSONSerialization.jsonObject(with: rawEventData, options: []) as? [String: Any]
        return Event(name: "Consent Update", type: EventType.consent, source: EventSource.requestContent, data: eventData)
    }
}
