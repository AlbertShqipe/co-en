Rails.application.config.to_prepare do
  module SkipActiveStorageJobs
    def perform(*)
      Rails.logger.warn("[ActiveStorage] Blocked job: #{self.class.name}")
    end
  end

  ActiveStorage::PreviewImageJob.prepend(SkipActiveStorageJobs)
  ActiveStorage::AnalyzeJob.prepend(SkipActiveStorageJobs)
end
