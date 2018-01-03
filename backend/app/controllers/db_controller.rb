class DbController < ApplicationController
  def cache
    serialize Cache.all.map { |c| c.serializable_hash }
  end

  def users
    serialize User.all.map { |c| c.serializable_hash }
  end

  protected

  def serialize(data)
    respond_to do |format|
      format.xml { render xml: data }
      format.json { render json: data }
    end
  end
end
