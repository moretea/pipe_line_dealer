module PipeLineDealer
  class Error < Exception
    attr_reader :message

    def to_s
      @message
    end
  end
end
