require 'set'

require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'
require ENV['TM_SUPPORT_PATH'] + '/lib/ui'


def complete_import(line)
  if line =~ /^import\s+(.*)$/
    partial_import = $1
    
    matches = project_classes.delete_if { |cls| cls.index(partial_import).nil? }
    
    if matches.empty?
      TextMate.exit_show_tool_tip("Could not complete import")
    elsif matches.size > 1
      i = TextMate::UI.menu(matches)
		
		  TextMate.exit_discard() if i == nil
      TextMate.exit_insert_snippet "import #{matches[i]};"
    else
      TextMate.exit_insert_snippet "import #{matches.first};"
    end
  else
    TextMate.exit_show_tool_tip("Could not complete import")
  end
end

def project_classes
  project_directory = ENV['TM_PROJECT_DIRECTORY']
  jar_glob = "#{project_directory}/**/*.jar"
  source_glob = "#{project_directory}/**/*.java"
  
  classes = Set.new
  
  Dir[jar_glob].each do |jar_file|
    classes += jar_classes(jar_file)
  end
  
  Dir[source_glob].each do |source_file|
    #File.read(source_file) =~ (/^\s*package\s*(.*)\s*;\s*$/)
    #package = $1;
    
    File.open(source_file) do |f|
      while ln = f.gets
        break if ln =~ /package\s+(.+)\s*;/
      end
      
      if $1
        package = $1
        
        class_name = File.basename(source_file).sub('.java', '')

        classes << "#{package}.#{class_name}"
      end
    end    
  end
  
  classes.to_a
end

def jar_classes(jar_file)
  `unzip -l #{jar_file}`.scan(/\b[\w\d\/]+\.class\b/).map do |c|
    c.sub('.class', '').gsub('/', '.')
  end
end