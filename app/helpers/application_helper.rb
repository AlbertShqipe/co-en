module ApplicationHelper
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
end
