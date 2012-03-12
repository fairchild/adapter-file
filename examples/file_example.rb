require 'rubygems'
$:.unshift(File.dirname(__FILE__)+"/../lib")

require 'adapter/file'

adapter = Adapter[:file].new(File.dirname(__FILE__)+"/files")

adapter.clear

adapter.write('foo', 'bar')
puts 'Should be bar: ' + adapter.read('foo').inspect
p [:files,  Dir.entries(File.dirname(__FILE__)+"/files") ]

adapter.delete('foo')
puts 'Should be nil: ' + adapter.read('foo').inspect

adapter.write('foo', 'bar')
adapter.clear
puts 'Should be nil: ' + adapter.read('foo').inspect

# puts 'Should be bar: ' + adapter.fetch('foo', 'bar').inspect
# puts 'Should be bar: ' + adapter.read('foo').inspect

p [:files,  Dir.entries(File.dirname(__FILE__)+"/files") ]

