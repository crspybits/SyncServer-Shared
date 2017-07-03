Pod::Spec.new do |s|
  s.name         = "SyncServer-Shared"
  s.version      = "0.0.1"
  s.summary      = "Swift code shared between the SyncServerII server and iOS client"
  s.description  = <<-DESC
  	Swift code shared between the SyncServerII server and iOS client
                   DESC
                   
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Christopher Prince" => "chris@SpasticMuffin.biz" }
  s.platform     = :ios, "9.0"

  s.homepage     = "https://github.com/crspybits/SyncServer-Shared"
  s.source       = { :git => "https://github.com/crspybits/SyncServer-Shared.git", :tag => "#{s.version}" }

  s.source_files  = "Code/**/*.{swift}"

  s.requires_arc = true

  s.dependency "Gloss"
end
