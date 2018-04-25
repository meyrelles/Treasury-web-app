class CoinbagsController < ApplicationController
  before_action :set_coinbag, only: [:show, :edit, :update, :destroy]

  # GET /coinbags
  # GET /coinbags.json
  def index
    @coinbags = Coinbag.all
  end

  # GET /coinbags/1
  # GET /coinbags/1.json
  def show
  end

  # GET /coinbags/new
  def new
    @coinbag = Coinbag.new
  end

  # GET /coinbags/1/edit
  def edit
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_coinbag
      @coinbag = Coinbag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def coinbag_params
      params.require(:coinbag).permit(:coinbag)
    end
end
