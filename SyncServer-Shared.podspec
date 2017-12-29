Pod::Spec.new do |s|
  s.name         = "SyncServer-Shared"
  s.version      = "3.3.1"
  s.summary      = "Swift code shared between the SyncServerII server and iOS client"
  s.description  = <<-DESC
  	Swift code shared between the SyncServerII server and iOS client
                   DESC
                   
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Christopher Prince" => "chris@SpasticMuffin.biz" }
  s.platform     = :ios, "9.0"

  s.homepage     = "https://github.com/crspybits/SyncServer-Shared"
  s.source       = { :git => "https://github.com/crspybits/SyncServer-Shared.git", :tag => "#{s.version}" }
  
  s.pod_target_xcconfig = {
    'OTHER_SWIFT_FLAGS[config=Debug]' => '-DDEBUG'
  }

  s.source_files  = "Sources/**/*.{swift}"

  s.requires_arc = true

  s.dependency "Gloss", "~> 1.2"
end
