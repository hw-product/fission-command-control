$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'fission-command-control/version'
Gem::Specification.new do |s|
  s.name = 'fission-command-control'
  s.version = Fission::CommandControl::VERSION.version
  s.summary = 'Fission Command Control'
  s.author = 'Heavywater'
  s.email = 'fission@hw-ops.com'
  s.homepage = 'http://github.com/heavywater/fission-command-control'
  s.description = 'Fission command control'
  s.require_path = 'lib'
  s.add_runtime_dependency 'fission'
  s.files = Dir['{lib}/**/**/*'] + %w(fission-command-control.gemspec README.md CHANGELOG.md)
end
