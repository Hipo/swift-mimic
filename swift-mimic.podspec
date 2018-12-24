#
# Be sure to run `pod lib lint swift-mimic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'swift-mimic'
  s.version          = '0.1.0'
  s.summary          = 'UI testing framework for iOS projects that allows easy API mocking for localized and quick tests.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/hipo/swift-mimic'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'goktugberkulu' => 'goktugberkulu@gmail.com' }
  s.source           = { :git => 'https://github.com/hipo/swift-mimic.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/hipolabs'

  s.ios.deployment_target = '8.0'

  s.source_files = 'swift-mimic/Classes/**/*'
  
  # s.resource_bundles = {
  #   'swift-mimic' => ['swift-mimic/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Alamofire'
end
