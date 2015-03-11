require 'fission-command-control'

module Fission
  module CommandControl
    module Formatter

      # Enable command control on allowed github release event
      class GithubRelease < Fission::Formatter

        # Source of payload
        SOURCE = :github
        # Destination of payload
        DESTINATION = :command_control

        # Update payload to include command control configuration for
        # handling new release
        #
        # @param payload [Smash]
        def format(payload)
          if(payload.get(:data, :github, :event) == 'release')
            valid = config.fetch(:github, :releases, :allowed, []).include?(
              payload.get(:data, :github, :repository, :full_name)
            )
            if(valid)
              payload.set(:data, :command_control,
                Smash.new(
                  :destination => config.fetch(:github, :releases, :destination, 'commander'),
                  :action => Smash.new(
                    :action => 'github_release',
                    :arguments => payload.get(:data, :github, :release, :assets).first
                  )
                )
              )
            end
          end
        end

      end

    end
  end
end
