#
#  Be sure to run `pod spec lint ZYJGestureUnlock.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "IZGestureLock"
  s.version      = "0.0.1"
  s.summary      = "Gesture Lock"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
  九宫格手势解锁 
  Draw a pattern lock through nine points 
                   DESC

  s.homepage     = "https://github.com/smlkts/IZGestureLock"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  # s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Ian Zhang" => "yanj1988@icloud.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/smlkts/IZGestureLock.git", :tag => s.version }

  s.source_files  = "IZGestureLock/IZGestureLock.{h,m}"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
