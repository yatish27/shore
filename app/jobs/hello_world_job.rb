class HelloWorldJob < ApplicationJob
  queue_as :default

  def perform(*args)
    log_data = {
      job_type: self.class.name,
      job_id: job_id,
      queue_name: queue_name,
      provider_job_id: provider_job_id,
      arguments: args,
      priority: priority,
      timestamp: Time.current
    }

    Rails.logger.info(log_data.to_json)
  end
end
