require 'spec_helper'

describe Translation::Client::InitOperation::CreateYamlPoFilesStep do

  it do
    yaml_root_path = 'tmp/config/locales'
    FileUtils.mkdir_p(yaml_root_path)

    File.open('tmp/config/locales/en.yml', 'wb') do |file|
      file.write <<EOS
---
en:
  home:
    show:
      title: "Awesome Title"
    abbr_month_names:
    -
    - jan
    - feb
  faker:
    blop: "blup"
EOS
    end

        File.open('tmp/config/locales/fr.yml', 'wb') do |file|
      file.write <<EOS
---
fr:
  home:
    show:
      title: "Titre génial"
    abbr_month_names:
    -
    - jan
    - fev
  faker:
    blop: "blup en français"
EOS
    end

    source_locale   = 'en'
    target_locales  = ['fr', 'nl']
    yaml_file_paths = Dir["#{yaml_root_path}/*.yml"]
    params          = {}

    operation_step = Translation::Client::InitOperation::CreateYamlPoFilesStep.new(source_locale, target_locales, yaml_file_paths)
    operation_step.run(params)

    params['yaml_po_data_fr'].should == <<EOS
msgctxt "home.show.title"
msgid "Awesome Title"
msgstr "Titre génial"

msgctxt "home.abbr_month_names[1]"
msgid "jan"
msgstr "jan"

msgctxt "home.abbr_month_names[2]"
msgid "feb"
msgstr "fev"
EOS

    params['yaml_po_data_nl'].should == <<EOS
msgctxt "home.show.title"
msgid "Awesome Title"
msgstr ""

msgctxt "home.abbr_month_names[1]"
msgid "jan"
msgstr ""

msgctxt "home.abbr_month_names[2]"
msgid "feb"
msgstr ""
EOS
  end

end
