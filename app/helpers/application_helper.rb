module ApplicationHelper
  def percent_to_integer(num)
    (num * 100).to_i
  end

  def currency(num)
    number_to_currency(num, unit: "$", separator: ".")
  end
end
