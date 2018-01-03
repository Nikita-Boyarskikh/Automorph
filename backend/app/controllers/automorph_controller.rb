class AutomorphController < ApplicationController
  before_action :parse_params, only: :result
  before_action :signed_in_user

  def index; end

  def result
    if @n.nil?
      @error = 'Number parameter is not an integer'
    elsif @n > 100
      @error = 'Number is too large'
    elsif @n <= 0
      @error = 'Number is too small'
    else
      data = Cache.find_by(n: @n)

      if data
        data = data.serializable_hash
      else
        calculate
        save

        data = {
          error: @error,
          result: @numbers
        }
      end
    end

    data = { error: @error } if data.nil?

    respond_to do |format|
      format.html
      format.json { render json: data }
      format.xml { render xml: data }
      format.rss { render xml: data }
    end
  end

  protected

  def save
    Cache.create(n: @n.to_s, result: @numbers, error: @error)
  end

  def calculate
    pow10 = 10
    @numbers = []
    (1..@n).each do |i|
      pow10 *= 10 if i >= 10 && pow10 == 10
      @numbers.push i if i * i % pow10 == i
    end
  end

  # Before filters

  def parse_params
    @n = begin
      Integer(params[:number])
    rescue ArgumentError, TypeError
      nil
    end
  end

  def signed_in_user
    redirect_to signin_url, notice: 'Please sign in.' unless signed_in?
  end
end
