class TrStatementsController < ApplicationController
  before_action :set_tr_statement, only: [:show, :edit, :update, :destroy]

  # GET /tr_statements
  # GET /tr_statements.json
  def index
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end
    @tr_statements = TrStatement.all
    @tr_statements = @tr_statements.order(date_time: :desc)
  end

  # GET /tr_statements/1
  # GET /tr_statements/1.json
  def show
  end

  # GET /tr_statements/new
  def new
    load_tables
    @action = 'NEW'
    @usr = session[:user_id].to_s
    @mov_type = params[:type]
    @tr_statement = TrStatement.new
  end

  # GET /tr_statements/1/edit
  def edit
    @action = 'EDIT'
    @usr = session[:user_id].to_s
    @mov_type = params[:type]
    load_tables
  end

  # POST /tr_statements
  # POST /tr_statements.json
  def create
    #data manipulation from form
    data_manipulation

    #Version Controll
    params[:tr_statement][:transaction_id] = params[:tr_statement][:"id"]
    params[:tr_statement][:status] = 'I'
    #--#

    @tr_statement = TrStatement.new(tr_statement_params)

    respond_to do |format|
      if @tr_statement.save
        # change for here to update the table after form commit
        # If working on exchange operation, the app needs to create an aditional record in DB
        # Link to function to create it.
        if params[:tr_statement][:mov_type] == 'exch'
          exchange_function_insert
        end

        format.html { redirect_to @tr_statement, notice: 'Transaction was successfully created.' }
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

        # If working on exchange operation, the app needs to update an aditional record in DB
        # Link to function to update it.
        if params[:tr_statement][:mov_type] == 'exch'
          exchange_function_update
        end

        format.html { redirect_to @tr_statement, notice: 'Transaction was successfully updated.' }
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
    if @tr_statement.mov_type.to_s == 'exch'
      exchange_function_delete @tr_statement.transaction_link
    end
    @tr_statement.destroy
    respond_to do |format|
      format.html { redirect_to tr_statements_url, notice: 'Transaction was successfully destroyed.' }
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
      params.require(:tr_statement).permit(:status, :transaction_id, :created_by, :coinbag_dest, :coinbag, :fee, :hash, :version, :exch_destin, :transaction_link, :mov_type, :date_time, :timezone, :classification, :reason, :from, :to, :currency, :amount, :celebrate)
    end

    #function to manipulate form data
    def data_manipulation

      @tempo = Time.now

      params[:tr_statement][:date_time] = Time.new(params[:tr_statement][:"date_time(1i)"].to_i,params[:tr_statement][:"date_time(2i)"].to_i,params[:tr_statement][:"date_time(3i)"].to_i,params[:tr_statement][:"date_time(4i)"].to_i,params[:tr_statement][:"date_time(5i)"].to_i,50,'+01:00')
      params[:tr_statement].delete(:"date_time(1i)")
      params[:tr_statement].delete(:"date_time(2i)")
      params[:tr_statement].delete(:"date_time(3i)")
      params[:tr_statement].delete(:"date_time(4i)")
      params[:tr_statement].delete(:"date_time(5i)")
      params[:tr_statement][:created_by] = session[:user_id]


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

      #load classification table
      @classification = Classification.all
      @classification = @classification.order(:classification)
    end

    def exchange_function_insert
      r = RethinkDB::RQL.new
      conn = r.connect(:host => "localhost", :port => 28015)

      r.db('treasury_development').table('tr_statements').insert({
        :reason => params[:tr_statement][:reason],
        :celebrate => params[:tr_statement][:celebrate],
        :date_time => params[:tr_statement][:date_time],
        :transaction_link => params[:tr_statement][:transaction_link],
        :mov_type => params[:tr_statement][:mov_type],
        :timezone => params[:tr_statement][:timezone],
        :classification => params[:tr_statement][:classification],
        :coinbag => params[:tr_statement][:coinbag_dest],
        :amount => params[:tr_statement][:amount_dest],
        :currency => params[:tr_statement][:currency_dest],
        :from => params[:tr_statement][:from],
        :to => params[:tr_statement][:to],
        :exch_destin => "Received",
        :created_by => session[:user_id],
        :transaction_id => params[:tr_statement][:id],
        :status => 'I'
      }).run(conn)

      conn.close
    end

    def exchange_function_update
      r = RethinkDB::RQL.new
      conn = r.connect(:host => "localhost", :port => 28015)

      r.db('treasury_development').table("tr_statements").filter({
        :transaction_link => params[:tr_statement][:transaction_link],
        :exch_destin => "Received"}).update({
          :timezone => params[:tr_statement][:timezone],
          :classification => params[:tr_statement][:classification],
          :coinbag => params[:tr_statement][:coinbag_dest],
          :amount => params[:tr_statement][:amount_dest],
          :currency => params[:tr_statement][:currency_dest],
          :reason => params[:tr_statement][:reason],
          :celebrate => params[:tr_statement][:celebrate],
          :date_time => params[:tr_statement][:date_time],
          :created_by => session[:user_id]
      }).run(conn)

      conn.close
    end

    def exchange_function_delete(tr_id)
      r = RethinkDB::RQL.new
      conn = r.connect(:host => "localhost", :port => 28015)

      r.db('treasury_development').table("tr_statements").filter({"transaction_link": tr_id}).delete().run(conn)

      conn.close
    end
end
