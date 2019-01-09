#
# Be sure to run `pod lib lint swift-mimic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'swift-mimic'
  s.version          = '0.2.0'
  s.summary          = 'UI testing framework for iOS projects that allows easy API mocking for localized and quick tests.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                       DESC

  s.homepage         = 'https://github.com/hipo/swift-mimic'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'goktugberkulu' => 'goktugberkulu@gmail.com' }
  s.source           = { :git => 'https://github.com/hipo/swift-mimic.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hipolabs'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Mimic/Classes/**/*'
end
