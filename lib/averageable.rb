module Averageable

  def average(array)
    (array.sum / array.count.to_f).round(2)
  end

  def standard_deviation(average, count, array)
    standard = array.map do |number|
      (number - average) ** 2
    end.sum
    Math.sqrt(standard / (count - 1)).round(2)
  end
end
