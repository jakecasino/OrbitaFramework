Pod::Spec.new do |s|
  s.name             = 'OrbitaFramework'
  s.version          = '0.1.0'
  s.summary          = 'Orbita AI chat app framework.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Orbita AI chat app framework that includes all of the fundamental visual elements that supplement the chat.
                       DESC

  s.homepage         = 'https://github.com/jakecasino/OrbitaFramework'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jakecasino' => 'jake@jakecasino.com' }
  s.source           = { :git => 'https://github.com/jakecasino/OrbitaFramework.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'OrbitaFramework/Classes/**/*'
  s.swift_version = '4.0'

  s.resources = 'OrbitaFramework/Assets/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Efficio'
  # s.dependency 'Efficio', '~> 0.2.0'
  # s.dependency 'AFNetworking', '~> 2.3'
end
