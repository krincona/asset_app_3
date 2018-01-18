module ModelHelper

  def until_date
    if self.at_date.day < 25
      return self.at_date.end_of_month
    else
      return self.at_date.end_of_month + 1.month
    end
  end

end