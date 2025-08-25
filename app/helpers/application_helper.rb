module ApplicationHelper

  / This helper function is used to calculate the age of a participant the day of the competition /
  def calculate_age(birthdate)
    birthdate = birthdate.is_a?(String) ? Date.parse(birthdate) : birthdate

    # Calculate the age based on the day of the competition
    reference_date = Date.new(2025, 4, 19)

    # Calculate the age based on today's date
    # today = Date.today
    # You change the reference_date to today to calculate the age based on today's date


    years = reference_date.year - birthdate.year
    months = reference_date.month - birthdate.month
    days = reference_date.day - birthdate.day

    if days < 0
      months -= 1
      previous_month = reference_date.prev_month
      days += (Date.new(previous_month.year, previous_month.month, -1).day)
    end

    if months < 0
      years -= 1
      months += 12
    end

    age_string = "#{years} #{t("helper.age_function_years")}"
    age_string += ", #{months} #{t("helper.age_function_months")}" if months > 0
    age_string += ", #{days} #{t("helper.age_function_days")}" if days > 0
    age_string += " #{t("helper.old")}"

    age_string
  end

  / This helper function is used to see if the key exists in cloudinary /
  def resource_exists?(key, results_prod, results_prod_1, results_dev)
    results_prod.any? { |hash| hash["public_id"] == "production/#{key}" } ||
    results_prod_1.any? { |hash| hash["public_id"] == "production/#{key}" } ||
    results_dev.any? { |hash| hash["public_id"] == "development/#{key}" }
  end

  / This helper function is used to see if all the participants assets exist in cloudinary /
  def all_participants_valid?(participants, results_prod, results_prod_1, results_dev)
    participants.all? do |participant|
      # photo_key = participant.photo.key
      file_key = participant.file.key
      id_card_key = participant.id_card.key

      # resource_exists?(photo_key, results_prod, results_prod_1, results_dev) &&
      resource_exists?(file_key, results_prod, results_prod_1, results_dev) &&
      resource_exists?(id_card_key, results_prod, results_prod_1, results_dev)
    end
  end

  / This helper function is used to find the matching file URL in cloudinary /
  def matching_file_url(key, results_prod, results_prod_1, results_dev)
    matching_file = results_prod.find { |hash| hash["public_id"] == "production/#{key}" } ||
                    results_prod_1.find { |hash| hash["public_id"] == "production/#{key}" } ||
                    results_dev.find { |hash| hash["public_id"] == "development/#{key}" }
    matching_file&.dig("url")
  end

  / This helper function is used to render the file cell in the index page as a clickable link/
  def render_file_cell(form, attachment, results_prod, results_prod_1, results_dev)
    return content_tag(:td, t('show.no_file')) unless form.public_send(attachment).attached?

    key = form.public_send(attachment).key
    url = matching_file_url(key, results_prod, results_prod_1, results_dev)

    if url
      updated_url = url.sub(/\.pdf\z/, '.png')
      content_tag(:td, style: "text-align:center") do
        link_to(updated_url, target: "_blank") do
          image_tag(updated_url, alt: "", width: "50px")
        end
      end
    else
      content_tag(:td, t('show.no_file'))
    end
  end

  / This helper function is used to render the file cell in the index page as an image/
  def render_file_image(form, attachment, results_prod, results_prod_1, results_dev)
    return content_tag(:td, t('show.no_file')) unless form.public_send(attachment).attached?

    key = form.public_send(attachment).key
    url = matching_file_url(key, results_prod, results_prod_1, results_dev)

    if url
      updated_url = url.sub(/\.pdf\z/, '.png')

      content_tag(:td, style: "text-align:center") do
        image_tag(updated_url, alt: "", width: "300px")
      end
    else
      content_tag(:td, t('show.no_file'))
    end
  end

  / This helper function is used to render the attachment row in the individual_form show page /
  def render_attachment_row(label, individual_form, attachment, results_prod, results_prod_1, results_dev)
    content_tag(:tr) do
      concat(content_tag(:td, t(label)))

      if individual_form.public_send(attachment).attached?
        key = individual_form.public_send(attachment).key
        matching_file = results_prod.find { |hash| hash["public_id"] == "production/#{key}" } ||
                        results_prod_1.find { |hash| hash["public_id"] == "production/#{key}" } ||
                        results_dev.find { |hash| hash["public_id"] == "development/#{key}" }

        if matching_file
          url = matching_file["url"]
          updated_url = url.sub(/\.pdf\z/, '.png')
          concat(content_tag(:td, style: "text-align:center") do
            link_to(updated_url, target: "_blank") do
              image_tag(updated_url, alt: "", width: "50px")
            end
          end)
        else
          concat(content_tag(:td, t('show.no_file')))
        end
      else
        concat(content_tag(:td, t('show.no_file')))
      end
    end
  end

  / This helper function is used to see if all the attachments exist in cloudinary for individual forms/
  def all_attachments_valid?(individual_form, results_prod, results_prod_1, results_dev)
    # %i[photo file id_card].all? do |attachment|
    %i[file id_card].all? do |attachment|
      next unless individual_form.send(attachment).attached?

      key = individual_form.send(attachment).key
      resources = [results_prod, results_prod_1, results_dev].flatten
      resources.any? { |resource| resource["public_id"] == "production/#{key}" || resource["public_id"] == "development/#{key}" }
    end
  end
end
