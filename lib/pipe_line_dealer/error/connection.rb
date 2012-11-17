module PipeLineDealer
  class Error
    class Connection < PipeLineDealer::Error
    end

    class Connection
      class Unprocessable < Error::Connection
        attr_reader :errors

        def initialize(errors)
          @errors = errors
          @message = "Couldn't save to the server: #{errors.inspect}"
        end
      end
    end
  end
end
