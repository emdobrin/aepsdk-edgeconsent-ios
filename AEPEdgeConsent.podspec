Pod::Spec.new do |s|
  s.name             = "AEPEdgeConsent"
  s.version          = "4.0.1"
  s.summary          = "Experience Platform Consent Collection extension for Adobe Experience Platform Mobile SDK. Written and maintained by Adobe."

  s.description      = <<-DESC
                       The Experience Platform Consent Collection extension enables consent preferences collection from a mobile app when using the Adobe Experience Platform Mobile SDK and the Edge Network extension.
                       DESC

  s.homepage         = "https://github.com/adobe/aepsdk-edgeconsent-ios.git"
  s.license          = { :type => "Apache License, Version 2.0", :file => "LICENSE" }
  s.author           = "Adobe Experience Platform SDK Team"
  s.source           = { :git => "https://github.com/adobe/aepsdk-edgeconsent-ios.git", :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'

  s.swift_version = '5.1'

  s.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }
  s.dependency 'AEPCore', '>= 4.0.0', '< 5.0.0'
  s.dependency 'AEPEdge', '>= 4.0.0', '< 5.0.0'

  s.source_files = 'Sources/**/*.swift'
end
