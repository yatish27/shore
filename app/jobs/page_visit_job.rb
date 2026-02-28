class PageVisitJob < ApplicationJob
  queue_as :default

  def perform(params)
    log_data = {
      job_type: self.class.name,
      job_id: job_id,
      timestamp: Time.current,
      request: {
        ip: params["ip"],
        user_agent: params["user_agent"],
        url: params["url"],
        method: params["method"],
        referer: params["referer"]
      }
    }

    Rails.logger.info("[PageVisitJob] #{log_data.to_json}")
  end
end
