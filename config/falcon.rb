#!/usr/bin/env -S falcon host
# frozen_string_literal: true

require "falcon/environment/rack"

hostname = File.basename(__dir__)
port = ENV["PORT"] || 3000

service hostname do
  include Falcon::Environment::Rack
  endpoint Async::HTTP::Endpoint.parse("http://0.0.0.0:#{port}")
end
