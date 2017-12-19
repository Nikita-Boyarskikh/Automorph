class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(nickname: (params[:session][:nickname]||'').downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid nickname/password combination'
      redirect_to signin_path
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
