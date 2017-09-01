class AutomorphController < ApplicationController
  def index; end

  def result
    n = begin
          Integer(params[:number])
        rescue ArgumentError
          nil
        end
    if n.nil? then @error = 'Number parameter is not an integer'
    elsif n > 100 then @error = 'Number is too large'
    elsif n <= 0 then @error = 'Number is too small'
    else
      pow10 = 10
      @numbers = []
      (1..n).each do |i|
        pow10 *= 10 if i >= 10 && pow10 == 10
        @numbers.push i if i * i % pow10 == i
      end
    end
  end
end
