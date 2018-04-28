class TrStatementsController < ApplicationController
  before_action :set_tr_statement, only: [:show, :edit, :update, :destroy]

  # GET /tr_statements
  # GET /tr_statements.json
  def index
    @tr_statements = TrStatement.all
  end

  # GET /tr_statements/1
  # GET /tr_statements/1.json
  def show
  end

  # GET /tr_statements/new
  def new
    load_tables
    @tr_statement = TrStatement.new
  end

  # GET /tr_statements/1/edit
  def edit
    load_tables
  end

  # POST /tr_statements
  # POST /tr_statements.json
  def create
    #data manipulation from form
    data_manipulation

    @tr_statement = TrStatement.new(tr_statement_params)

    respond_to do |format|
      if @tr_statement.save

        format.html { redirect_to @tr_statement, notice: 'Tr statement was successfully created.' }
        format.json { render :show, status: :created, location: @tr_statement }
      else
        format.html { render :new }
        format.json { render json: @tr_statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tr_statements/1
  # PATCH/PUT /tr_statements/1.json
  def update
    #data manipulation from form
    data_manipulation

    respond_to do |format|
      if @tr_statement.update(tr_statement_params)
        format.html { redirect_to @tr_statement, notice: 'Tr statement was successfully updated.' }
        format.json { render :show, status: :ok, location: @tr_statement }
      else
        format.html { render :edit }
        format.json { render json: @tr_statement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tr_statements/1
  # DELETE /tr_statements/1.json
  def destroy
    @tr_statement.destroy
    respond_to do |format|
      format.html { redirect_to tr_statements_url, notice: 'Tr statement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tr_statement
      @tr_statement = TrStatement.find(params[:id])

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tr_statement_params
      params.require(:tr_statement).permit(:mov_type, :date_time, :timezone, :description, :reason, :coinbag, :from, :to, :currency, :amount, :celebrate)
    end

    #function to manipulate form data
    def data_manipulation

      @tempo = Time.now

      params[:tr_statement][:date_time] = Time.new(params[:tr_statement][:"date_time(1i)"].to_i,params[:tr_statement][:"date_time(2i)"].to_i,params[:tr_statement][:"date_time(3i)"].to_i,params[:tr_statement][:"date_time(4i)"].to_i,params[:tr_statement][:"date_time(5i)"].to_i,0,'+00:00')
      params[:tr_statement].delete(:"date_time(1i)")
      params[:tr_statement].delete(:"date_time(2i)")
      params[:tr_statement].delete(:"date_time(3i)")
      params[:tr_statement].delete(:"date_time(4i)")
      params[:tr_statement].delete(:"date_time(5i)")

    end

    def load_tables

      #load user table
      @users = User.all
      @users = @users.order(:nickname)

      #load coinbags table
      @coinbag = Coinbag.all
      @coinbag = @coinbag.order(:coinbag)

      #load currency table
      @currency = Currency.all
      @currency = @currency.order(:currency)

      @type = params[:type].to_s
    end

end
