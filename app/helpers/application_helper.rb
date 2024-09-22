module ApplicationHelper
  def calculate_age(birthdate)
    birthdate = birthdate.is_a?(String) ? Date.parse(birthdate) : birthdate
    today = Date.today

    years = today.year - birthdate.year
    months = today.month - birthdate.month
    days = today.day - birthdate.day

    if days < 0
      months -= 1
      previous_month = today.prev_month
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
