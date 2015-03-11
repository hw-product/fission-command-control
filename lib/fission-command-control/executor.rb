require 'fission-command-control'

module Fission
  module CommandControl

    # Command executor
    class Executor < Callback

      # Determine validity of message
      #
      # @param message [Carnivore::Message]
      # @return [Truthy, Falsey]
      def valid?(message)
        super do |payload|
          (payload.get(:data, :command_control, :action) ||
            payload.get(:data, :command_control, :actions)) &&
            payload.get(:data, :command_control, :destination)
        end
      end

      # Send commands to be executed
      #
      # @param message [Carnivore::Message]
      def execute(message)
        failure_wrap(message) do |payload|
          dest = payload.get(:data, :command_control, :destination)
          info "Sending command requests to #{dest}"
          min = payload.get(:data, :command_control, :minimum_success)
          commands = Smash.new
          if(act = payload.get(:data, :command_control, :action))
            commands[:action] = act
          end
          if(acts = payload.get(:data, :command_control, :actions))
            commands[:actions] = acts
          end
          command_payload = new_payload(
            min ? dest : :command_control,
            :commander => acts,
            :command_control => Smash.new(
              :origin_id => origin_key
            )
          )
          transmit(dest, command_payload)
          if(min)
            origin_key = store_original_payload(payload)
            info "Minimum of #{min} success responses must be received"
            transmit(dest,
              new_payload(:command_control,
                :commander => acts,
                :command_control => Smash.new(
                  :origin_id => origin_key
                )
              )
            )
            message.confirm!
          else
            transmit(dest,
              new_payload(dest,
                :commander => acts
              )
            )
            job_completed(:command_control, payload, message)
          end
        end
      end

      # Store original payload in asset store
      #
      # @param payload [Smash]
      # @return [String] remote asset key
      def store_original_payload(payload)
        key = File.join('command-control', payload[:message_id])
        asset_store.put(key, MultiJson.dump(payload))
        key
      end

    end

  end
end
