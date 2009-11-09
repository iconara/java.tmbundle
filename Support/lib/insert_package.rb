require ENV['TM_SUPPORT_PATH'] + '/lib/textmate'


COMMON_SOURCE_DIRS = %w(src/java src/main src/test src source/java source/main source test/java test/unit test/integration test)


def insert_package(line)
  file_path = ENV['TM_FILEPATH'].dup
  file_path.sub!(ENV['TM_PROJECT_DIRECTORY'], '')
  file_path.sub!(/\//, '')
  
  COMMON_SOURCE_DIRS.each do |source_dir|
    file_path.sub!(/^#{source_dir}\//, '')
  end
  
  file_path.sub!(/\/[^\/]+\.java$/, '')
  file_path.gsub!('/', '.')
  
  TextMate.exit_insert_snippet "package #{file_path};"
end