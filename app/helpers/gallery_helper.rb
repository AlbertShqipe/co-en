module GalleryHelper
  # Maps 2023 -> "concours23.jpeg", 2024 -> "concours24.jpeg", etc.
  def cover_image_for(year)
    # Take the last 2 digits of the year and build the filename
    suffix = year.to_s[-2, 2] # "23", "24", "25"
    "concours#{suffix}.jpeg"
  end
end
