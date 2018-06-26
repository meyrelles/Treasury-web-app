class CoinbagsController < ApplicationController
  before_action :set_coinbag, only: [:show, :edit, :update, :destroy]

  # GET /coinbags
  # GET /coinbags.json
  def index
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end
    if session[:admin].to_s == "[true]" and session[:user_id] != ''
      @coinbags = Coinbag.all
      @coinbags = @coinbags.order('user_id', 'coinbag')
    else
      @coinbags = Coinbag.where(user_id: session[:user_id])
      @coinbags = @coinbags.order('coinbag')
    end
  end

  # GET /coinbags/1
  # GET /coinbags/1.json
  def show
  end

  # GET /coinbags/new
  def new
    @type = 'NEW'
    @coinbag = Coinbag.new
  end

  # GET /coinbags/1/edit
  def edit
    @type = 'EDIT'
  end

  # POST /coinbags
  # POST /coinbags.json
  def create
    @coinbag = Coinbag.new(coinbag_params)

    respond_to do |format|
      if @coinbag.save
        format.html { redirect_to @coinbag, notice: 'Coinbag was successfully created.' }
        format.json { render :show, status: :created, location: @coinbag }
      else
        format.html { render :new }
        format.json { render json: @coinbag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /coinbags/1
  # PATCH/PUT /coinbags/1.json
  def update
    respond_to do |format|
      if @coinbag.update(coinbag_params)
        format.html { redirect_to @coinbag, notice: 'Coinbag was successfully updated.' }
        format.json { render :show, status: :ok, location: @coinbag }
      else
        format.html { render :edit }
        format.json { render json: @coinbag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /coinbags/1
  # DELETE /coinbags/1.json
  def destroy
    @coinbag.destroy
    respond_to do |format|
      format.html { redirect_to coinbags_url, notice: 'Coinbag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # Select coinbags from user in transaction form when select user combobox
  def user_coinbags
    coinbag_id = params[:id].to_i
    coinbags = Coinbag.where(:id => coinbag_id)
    cbag = []
    coinbags.each do |coinbag|
      cbag << {:id => coinbag.id, :n => coinbag.coinbag}
    end
    cbag << {id => "qiyetuqtye8", :n => "TESTE"}
    render :json => {:cbag => cbag.compact}.as_json
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coinbag
      @coinbag = Coinbag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coinbag_params
      params.require(:coinbag).permit(:coinbag, :user_id)
    end
end
