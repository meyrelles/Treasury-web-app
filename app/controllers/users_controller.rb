class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Goggle drive class
  require './app/models/google_sych'

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @users = @users.order(:username)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #connect to google driver
    @google_synch = Google_synch.new
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    data_manipulation
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    data_manipulation
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

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :password, :surname, :givenname, :nickname, :birthdate_time, :spreadsheet_link, :email)
    end

  #function to manipulate form data
  def data_manipulation
    params[:user][:birthdate_time] = Time.new(params[:user][:"birthdate_time(1i)"].to_i,params[:user][:"birthdate_time(2i)"].to_i,params[:user][:"birthdate_time(3i)"].to_i,params[:user][:"birthdate_time(4i)"].to_i,params[:user][:"birthdate_time(5i)"].to_i,0,'+00:00')
    params[:user].delete(:"birthdate_time(1i)")
    params[:user].delete(:"birthdate_time(2i)")
    params[:user].delete(:"birthdate_time(3i)")
    params[:user].delete(:"birthdate_time(4i)")
    params[:user].delete(:"birthdate_time(5i)")

  end
end
