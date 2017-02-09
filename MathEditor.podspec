Pod::Spec.new do |s|
  s.name             = "MathEditor"
  s.version          = "0.2.0"
  s.summary          = "An editor for editing math equations."
  s.description      = <<-DESC
MathEditor provides a WYSIWYG editor for math equations. It comes with a
math keyboard that is included with the library, however you can provide
your own keyboard. It uses iosMath to render the formulae using latex
typesetting rules.
                       DESC
  s.homepage         = "https://github.com/kostub/MathEditor"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Kostub Deshmukh" => "kostub@gmail.com" }
  s.source           = { :git => "https://github.com/kostub/MathEditor.git", :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'mathEditor/**/*'
  s.private_header_files = 'mathEditor/internal/**/*.h'
  s.resource_bundles = {
     'MTKeyboardResources' => 'MathKeyboardResources/**/*'
  }
  s.frameworks = 'UIKit'
  s.dependency 'iosMath', '~> 0.9.3'
end
