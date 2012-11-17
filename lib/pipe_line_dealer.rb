require "active_support/concern"
require "faraday"
require "multi_json"

module PipeLineDealer
  %W{
    limits
    version

    error
    error/no_such_custom_field
    error/invalid_attribute
    error/connection

    collection/concerns
    collection/concerns/fetching
    collection/concerns/results_fetcher
    collection/concerns/create_and_update
    collection

    model/base/concern/persistance
    model/base
    model/custom_field

    custom_fields
    custom_field/collection

    model/company
    model/company/custom_field

    model/person
    model/person/custom_field

    model/note

    client/connection
    client
  }.each { |file| require(File.join("pipe_line_dealer", file))}
end

# Shortcut :)
if not defined?(PLD)
  PLD = PipeLineDealer
end
