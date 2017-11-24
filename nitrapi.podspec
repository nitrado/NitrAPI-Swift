#
# Be sure to run `pod lib lint nitrapi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "nitrapi"
  s.version          = "1.1.0"
  s.summary          = "Swift based SDK for the Nitrapi"

  s.description      = "Nitrapi Swift SDK"

  s.homepage         = "https://github.com/nitrado/Nitrapi-Swift"
  s.license          = 'MIT'
  s.author           = { "Stefan Hanßen" => "stefan.hanssen@marbis.net", "Alexander Birkner" => "alexander.birkner@marbis.net" }
  s.source           = { :git => "https://github.com/nitrado/Nitrapi-Swift.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/nitrado'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.dependency 'ObjectMapper', '~>3.0'
  s.dependency 'Just'
end
