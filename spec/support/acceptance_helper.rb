module AcceptanceHelper extend ActiveSupport::Concern

  class << self
    KEY_FILE = File.expand_path("../../api.key", __FILE__)

    def check_api_key!
      if not find_api_key
        puts
        $stderr.puts "No API key found to run the acceptance tests!"
        puts "To specify a API key, either:"
        puts " 1) use the API_KEY environmental variable!"
        puts " 2) create a 'spec/api.key' file which contains the API key."
        puts
        exit(1)
      end
    end

    def find_api_key
      ENV["API_KEY"] || File.exists?(KEY_FILE) && File.read(KEY_FILE).chomp.strip
    end
  end

  included do
    let(:api_key) { AcceptanceHelper.find_api_key }
    let(:client) { PLD::Client.new(AcceptanceHelper.find_api_key) }

    around do |example|
      if example.metadata.has_key? :acceptance
        WebMock.allow_net_connect!

        PLDCleaner.clean!(client)
      end

      example.run

      WebMock.disable_net_connect! if example.metadata.has_key? :acceptance
    end
  end
end
