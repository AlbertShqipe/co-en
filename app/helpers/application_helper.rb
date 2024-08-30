module ApplicationHelper
  def calculate_age(birthdate)
    birthdate = birthdate.is_a?(String) ? Date.parse(birthdate) : birthdate
    today = Date.today
    age = today.year - birthdate.year
    age -= 1 if today < birthdate + age.years
    age
  end
end
