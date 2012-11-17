module ConnectionHelper
  extend ActiveSupport::Concern

  included do
    let(:connection) { double("Connection") }
    let(:client) { double("Client") }
    before { client.stub(:connection).and_return(connection) }
  end
end
