notification :growl

guard :minitest, :all_on_start => true do
    watch(%r{^test/test_helper\.rb}) { 'test' }
    watch(%r{^lib/skr/access/(.+)\.rb})     { |m| "test/#{m[1]}_test.rb"          }
    watch(%r{^test/.+_test\.rb})

end
