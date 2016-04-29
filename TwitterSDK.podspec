#
# Be sure to run `pod lib lint TwitterSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TwitterSDK"
  s.version          = "1.0.0"
  s.summary          = "TwitterSDK."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = "TwitterSDK is open source to use apis of twitter."

  s.homepage         = "https://github.com/pisces/TwitterSDK"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "pisces" => "hh963103@gmail.com" }
  s.source           = { :git => "https://github.com/pisces/TwitterSDK.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.source_files = 'TwitterSDK/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
  s.dependency 'OAuthConsumer'
  
  s.resource_bundles = {
   'TwitterSDK' => ['TwitterSDK/Assets/*']
  }

  s.pod_target_xcconfig = {

  }
end
