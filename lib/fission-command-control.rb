require 'fission'

module Fission
  module CommandControl
    autoload :Collector, 'fission-command-control/collector'
    autoload :Executor, 'fission-command-control/executor'
  end
end

require 'fission-command-control/version'
