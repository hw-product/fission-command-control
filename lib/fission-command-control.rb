require 'fission'

module Fission
  module CommandControl
    autoload :Collector, 'fission-command-control/collector'
    autoload :Executor, 'fission-command-control/executor'
    autoload :Formatter, 'fission-command-control/formatter'
  end
end

require 'fission-command-control/version'
