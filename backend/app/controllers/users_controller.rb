class UsersController < ApplicationController
  before_action :set_user, :correct_user, :signed_in_user, except: [:index, :new, :create]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /user/1/edit
  def edit; end

  # GET /users/1
  # GET /users/1.json
  def show; end

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'Welcome to automorph numbers!' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, alert: @user.errors }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:nickname, :email, :password, :password_confirmation)
  end

  # Before filters

  def signed_in_user
    redirect_to signin_url, notice: 'Please sign in.' unless signed_in?
  end

  def correct_user
    redirect_to root_url, alert: 'Permission denied.' unless current_user? @user
  end
end
