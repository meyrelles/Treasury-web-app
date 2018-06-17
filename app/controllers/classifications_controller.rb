class ClassificationsController < ApplicationController
  before_action :set_classification, only: [:show, :edit, :update, :destroy]

  # GET /reasons
  # GET /reasons.json
  def index
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end    
    @classifications = Classification.all
  end

  # GET /reasons/1
  # GET /reasons/1.json
  def show
  end

  # GET /reasons/new
  def new
    @classification = Classification.new
  end

  # GET /reasons/1/edit
  def edit
  end

  # POST /reasons
  # POST /reasons.json
  def create
    @classification = Classification.new(classification_params)

    respond_to do |format|
      if @classification.save
        format.html { redirect_to @classification, notice: 'Classification was successfully created.' }
        format.json { render :show, status: :created, location: @classification }
      else
        format.html { render :new }
        format.json { render json: @classification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reasons/1
  # PATCH/PUT /reasons/1.json
  def update
    respond_to do |format|
      if @classification.update(classification_params)
        format.html { redirect_to @classification, notice: 'Classification was successfully updated.' }
        format.json { render :show, status: :ok, location: @classification }
      else
        format.html { render :edit }
        format.json { render json: @classification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reasons/1
  # DELETE /reasons/1.json
  def destroy
    @classification.destroy
    respond_to do |format|
      format.html { redirect_to classifications_url, notice: 'Classification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_classification
      @classification = Classification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def classification_params
      params.require(:classification).permit(:classification)
    end
end
