Pod::Spec.new do |spec|
  spec.name         = "AIScrollBar"
  spec.version      = "0.0.1"
  spec.summary      = "Horizontal scrollable bar with grouped buttons"
  
  spec.description  = <<-DESC
  Horizontal scrollable bar with grouped buttons, suitable for `inputAccessoryView` or toolbars with more content
                   DESC

  spec.homepage     = "https://github.com/alexifrim/AIScrollBar"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "alex ifrim" => "alex@maplicatii.eu" }

  spec.platform     = :ios, "9.0"
  spec.swift_version = "5.0"

  spec.source       = { :git => "https://github.com/alexifrim/AIScrollBar.git", :tag => spec.version.to_s }

  spec.source_files  = "AIScrollBar/**/*.{h,m,swift}"
end
