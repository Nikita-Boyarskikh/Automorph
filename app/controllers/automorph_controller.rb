class AutomorphController < ApplicationController
  def index; end

  def result
    n = params[:number].to_i
    if n > 100 or n <= 0 then @error = 'Enter number between 1 and 100'
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
