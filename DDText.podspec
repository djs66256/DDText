#
#  Be sure to run `pod spec lint DDText.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "DDText"
  spec.version      = "1.0.0"
  spec.summary      = "DDText."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  TextKit
                   DESC

  spec.homepage     = "https://github.com/djs66256/DDText"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "Daniel" => "djs66256@163.com" }
  spec.source       = { :git => "https://github.com/djs66256/DDText", :tag => "#{spec.version}" }

#  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
#  spec.exclude_files = "Classes/Exclude"
  
  spec.platform     = :ios, "8.0"
  # spec.public_header_files = "Classes/**/*.h"

  spec.default_subspecs = 'All'
  
  spec.subspec 'Label' do |s|
    s.source_files  = "Classes", "Classes/Label/**/*.{h,m}"
  end
  
  spec.subspec 'BuilderObjc' do |s|
    s.source_files  = "Classes", "Classes/TextBuilder/Objc/**/*.{h,m}"
    
    s.dependency 'DDText/Label'
  end
  
  spec.subspec 'BuilderSwift' do |s|
    s.source_files  = "Classes", "Classes/TextBuilder/Swift/**/*.{swift}"
    
    s.dependency 'DDText/Label'
  end
  
  spec.subspec 'Parser' do |s|
    s.source_files  = "Classes", "Classes/TextParser/**/*.{swift}"
    s.dependency 'DDText/Label'
  end
  
  spec.subspec 'All' do |s|
    s.source_files  = "Classes", "Classes/*.{h,m}"
  
    s.dependency 'DDText/Label'
    s.dependency 'DDText/BuilderObjc'
    s.dependency 'DDText/BuilderSwift'
    s.dependency 'DDText/Parser'
  end
  
  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
