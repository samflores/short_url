# frozen-string-literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push '.'
  t.libs.push 'spec'
  t.pattern = 'spec/**/*_spec.rb'
  t.warning = false
  t.verbose = true
end

task default: :test
