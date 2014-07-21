require "bundler/gem_tasks"

require 'rake/testtask'

Dir.glob('tasks/*.rake').each { |r| load r}

Rake::TestTask.new do |t|
    t.libs << 'test'
    t.pattern = "test/*_test.rb"
end

task :guard => [ 'db:migrate', 'db:test:clone_structure' ] do
    # NAS: I've never figured out how to run Guard from a rake task
    # Guard.setup
    # Guard.run_all
    # ^ this will work but only runs the task once
    # and doesn't listen for changes.  Which kinda defeats the purpose
    # For now just shell out until I can figure it out
    sh "bundle exec guard"
end
