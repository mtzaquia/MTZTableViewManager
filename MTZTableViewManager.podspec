Pod::Spec.new do |s|

  s.name         = "MTZTableViewManager"
  s.version      = "1.2.0"
  s.summary      = "A powerful framework for creating table views in a descriptive way, as well generating and handling table view forms."

  s.description  = <<-DESC
  MTZTableViewManager is a powerful framework that allows you to create table views in a descriptive way, by specifying rows and sections 
  without having to bother with indexes. It also provides a set of tools for creating forms and handling their input, applying masks, 
  performing validations and converting to and from complex objects.
  DESC

  s.homepage     = "https://github.com/mtzaquia/MTZTableViewManager"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "Mauricio Tremea Zaquia" => "mauriciotzaquia@gmail.com" }

  s.platform     = :ios, "9.0"

  s.source       = { :git => "https://github.com/mtzaquia/MTZTableViewManager.git", :tag => "#{s.version}" }

  s.source_files  = "MTZTableViewManager/**/*.{h,m}"

  s.public_header_files = [
                           "MTZTableViewManager/MTZTable{Manager,Data,Section,Row}.h", 
                           "MTZTableViewManager/Protocols/MTZModel*.h",
                           "MTZTableViewManager/Protocols/MTZReloadable.h",
                           "MTZTableViewManager/Forms/MTZTableForm{Row,DateRow,OptionRow}.h",
                           "MTZTableViewManager/Forms/Protocols/MTZForm{Object,Editing,Field,Option}.h",
                           "MTZTableViewManager/Forms/MTZForm{Validator,Converter}.h",
                           "MTZTableViewManager/Forms/MTZTextFieldMasker.h",
                           "MTZTableViewManager/Resources/MTZFormUtils.h",
                           "MTZTableViewManager/Resources/MTZTableViewManager.h",
                           "MTZTableViewManager/Command/MTZCommandExecutor.h",
                           "MTZTableViewManager/Command/Protocols/MTZCommand*.h"
                          ]

   s.requires_arc = true

   s.dependency "MTZExpirationDatePicker", "~> 1.0.1"

 end
