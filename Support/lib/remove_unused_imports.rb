require 'set'

require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui'


def remove_unused_imports(input)
  imported_classes = Set.new
  
  input.scan(/import\s+.*;/) do |import|
    imported_classes << import.gsub(/^import(?:\s+static)?\s+[\w\d.]+\.([\w\d]+)\s*;$/, '\1')
  end
  
  unused_classes = imported_classes.to_a.reject do |imported_class|
    input.scan(/^.*#{imported_class}.*$/).reject { |line| line.index("import") != nil }.size > 0
  end
  
  unless unused_classes.empty?
    output = input.dup
    
    output.gsub!(/\n.*import\s*.*(?:#{unused_classes.join('|')}).*/, '')
    
    TextMate.exit_replace_text(output)
  end
end