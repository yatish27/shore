# frozen_string_literal: true

InertiaRails.configure do |config|
  config.ssr_enabled = ENV.fetch("INERTIA_SSR_ENABLED", false)
  config.ssr_url = ENV.fetch("INERTIA_SSR_URL", "http://localhost:13714")
  config.version = ViteRuby.digest
end
