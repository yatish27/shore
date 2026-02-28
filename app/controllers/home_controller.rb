class HomeController < InertiaController
  def index
    PageVisitJob.perform_later(visit_params)

    render inertia: {
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

  private

  def visit_params
    {
      "ip" => request.remote_ip,
      "user_agent" => request.user_agent,
      "url" => request.url,
      "method" => request.method,
      "referer" => request.referer
    }
  end
end
