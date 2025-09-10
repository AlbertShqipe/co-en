class GalleryController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  BASE_PREFIX = "production/dance_images".freeze
  VIDEOS_BY_YEAR = {
    2023 => %w[U4OS7-JBLYw],
    2024 => %w[LxrUJcbGgBY],
    2025 => %w[jcJAjR27ysI],
    # 2026 => %w[...],
  }.freeze

  def index
    # Hardcode the list of years for now, or fetch from Cloudinary subfolders if you prefer
    @years = [2026, 2025, 2024, 2023]
  end

  def show
    @year = params[:year].to_i

    # Build the prefix dynamically instead of writing one line per year
    @images = Cloudinary::Api.resources(
      type: "upload",
      prefix: "#{BASE_PREFIX}/#{@year}",
      max_results: 500
    )["resources"]

    # Optional: also provide the list of available years for a year switcher
    @years = [2026, 2025, 2024, 2023]
    @videos = VIDEOS_BY_YEAR[@year] || []
  end
end
