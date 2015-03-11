require 'fission-command-control'

module Fission
  module CommandControl

    # Command response collector
    class Collector < Callback
      super do |payload|
        payload[:name] == 'command_control' &&
          payload.get(:data, :command_control, :origin_id)
      end
    end

    # Collect and process commander response
    #
    # @param message [Carnivore::Message]
    def execute(message)
      failure_wrap(message) do |payload|
        restored_payload = asset_store.get(
          payload.get(:data, :command_control, :origin_id)
        )
        received_success = restored_payload.fetch(
          :data, :command_control, :received_success, 0
        )
        min_success = restored_payload.get(:data, :command_control, :minimum_success)
        results = payload.get(:data, :commander, :results)
        if(results)
          if(results.all?{|r| r[:exit_code] == 0})
            received_success += 1
            restored_payload.set(:data, :command_control, :received_success, received_success)
            if(received_success >= min_success)
              info "Reached minimum number of success response! (min: #{min_success} - rec: #{received_success})"
              info 'Restoring payloading into pipeline!'
              job_completed(:command_control, restored_payload, message)
            else
              info "Minimum number of success responses not yet received! (min: #{min_success} - rec: #{received_success})"
              asset_store.put(
                payload.get(:data, :command_control, :origin_id),
                restored_payload
              )
              message.confirm!
            end
          end
        else
          warn 'Received payload provided no commander results!'
          message.confirm!
        end
      end
    end

  end
end
