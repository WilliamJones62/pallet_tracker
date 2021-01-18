module ApplicationHelper

  def display_date(date)
    if date
      formatted = date.strftime("%Y %m %d")
    else
      formatted = ' '
    end
  end

  def human_boolean(boolean)
      boolean ? 'Yes' : 'No'
  end

end
