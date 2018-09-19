class UsergroupsController < ApplicationController
  before_action :set_usergroup, only: [:show, :edit, :update, :destroy]

  # GET /coinbags
  # GET /coinbags.json
  def index
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end
    if session[:admin].to_s == "[true]" and session[:user_id] != ''
      @usergroup = Usergroup.all
      @usergroup = @usergroup.order('group_name')
    end
  end

  # GET /coinbags/1
  # GET /coinbags/1.json
  def show
  end

  # GET /coinbags/new
  def new
    @type = 'NEW'
    @usergroup = Usergroup.new
  end

  # GET /coinbags/1/edit
  def edit
    @type = 'EDIT'
  end

  # POST /coinbags
  # POST /coinbags.json
  def create
    @usergroup = Usergroup.new(usergroup_params)

    respond_to do |format|
      if @usergroup.save
        format.html { redirect_to @usergroup, notice: 'User group was successfully created.' }
        format.json { render :show, status: :created, location: @usergroup }
      else
        format.html { render :new }
        format.json { render json: @usergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coinbags/1
  # PATCH/PUT /coinbags/1.json
  def update
    respond_to do |format|
      if @usergroup.update(usergroup_params)
        format.html { redirect_to @usergroup, notice: 'User group was successfully updated.' }
        format.json { render :show, status: :ok, location: @usergroup }
      else
        format.html { render :edit }
        format.json { render json: @usergroup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coinbags/1
  # DELETE /coinbags/1.json
  def destroy
    @usergroup.destroy
    respond_to do |format|
      format.html { redirect_to usergroups_url, notice: 'User group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_usergroup
      @usergroup = Usergroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def usergroup_params
      params.require(:usergroup).permit(:id, :group_name, :created_at, :created_by)
    end
end
