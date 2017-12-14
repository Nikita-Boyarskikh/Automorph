class AutomorphController < ApplicationController
  before_action :parse_params, only: :result

  def index; end

  def result
    data = Cache.find_by_id(@n)

    unless data
      calculate
      save
      data = {
        error: @error,
        result: @numbers
      }
    end

    respond_to do |format|
      format.html
      format.json { render json: data }
      format.xml { render xml: data }
      format.rss { render xml: data }
    end
  end

  protected

  def save
    Cache.create(id: @n, result: @numbers, error: @error)
  end

  def calculate
    if @n.nil?
      @error = 'Number parameter is not an integer'
    elsif @n > 100
      @error = 'Number is too large'
    elsif @n <= 0
      @error = 'Number is too small'
    else
      pow10 = 10
      @numbers = []
      (1..@n).each do |i|
        pow10 *= 10 if i >= 10 && pow10 == 10
        @numbers.push i if i * i % pow10 == i
      end
    end
  end

  def parse_params
    @n = begin
      Integer(params[:number])
    rescue ArgumentError, TypeError
      nil
    end
  end
end
