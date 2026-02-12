class HomeController < ApplicationController
  layout "inertia"

  def index
    render inertia: "Home", props: {
      versions: {
        ruby: RUBY_VERSION,
        rails: Rails.version,
        puma: Puma::Const::PUMA_VERSION,
        postgresql: ActiveRecord::Base.connection.select_value("SHOW server_version"),
        solid_queue: SolidQueue::VERSION,
        solid_cache: SolidCache::VERSION,
        solid_cable: SolidCable::VERSION
      }
    }
  end
end
