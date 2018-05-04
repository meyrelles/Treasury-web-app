class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Goggle drive class
  require './app/models/google_synch2'

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    @users = @users.order(:username)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])
    #update global variable to send the google key to google API class
    $user_google_key = @user.spreadsheet_link
    #update global variable to send the google Sheet Name to google API class
    $user_google_sheet_name = @user.sheet_name

    #Call Google spreadsheet connection class
    @google_synch = Google_synch_a.new



    @kind = 'edit'

  end

  # GET /users/new
  def new
    @user = User.new
    @kind = 'new'
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @kind = 'edit'
  end

  # POST /users
  # POST /users.json
  def create
    data_manipulation
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "Welcome to the Veda Treasury App!"
      redirect_to @user
      #format.json { render :show, status: :created, location: @user }
    else
      render :new
      #format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    data_manipulation
    @user = User.find(params[:user][:"id"])

    if @user.update(user_params)
      flash[:success] = "User was successfully updated.!"
      redirect_to @user
      #format.json { render :show, status: :ok, location: @user }
    else
      render :edit
      #format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if @kind == 'edit'
        @user = User.find(params[:user][:"id"])
      elsif @kind == 'new' || @kind == 'show'
        @user = User.find(params[:id])
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:id, :username, :password_digest, :surname, :givenname, :nickname, :birthdate_time, :spreadsheet_link, :email, :sheet_name)
    end

    #function to manipulate form data
    def data_manipulation
      params[:user][:birthdate_time] = Time.new(params[:user][:"birthdate_time(1i)"].to_i,params[:user][:"birthdate_time(2i)"].to_i,params[:user][:"birthdate_time(3i)"].to_i,params[:user][:"birthdate_time(4i)"].to_i,params[:user][:"birthdate_time(5i)"].to_i,0,'+00:00')
      params[:user].delete(:"birthdate_time(1i)")
      params[:user].delete(:"birthdate_time(2i)")
      params[:user].delete(:"birthdate_time(3i)")
      params[:user].delete(:"birthdate_time(4i)")
      params[:user].delete(:"birthdate_time(5i)")

      encrypted_data = $crypt.encrypt_and_sign(params[:user][:"password_digest"])

      params[:user][:password_digest] = encrypted_data
    end
end
