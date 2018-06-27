class TrStatementsController < ApplicationController
  before_action :set_tr_statement, only: [:show, :edit, :update, :destroy]
  require 'will_paginate'
  require 'will_paginate/array'
  require 'will_paginate/active_record'

  # GET /tr_statements
  # GET /tr_statements.json
  def index
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end
    @statements_tr = TrStatement.where(status: 'I').order(date_time: :desc)
    @statements_tr = @statements_tr.paginate(:page => params[:page], :per_page => 10)
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
    if params[:type] == 'tr'
      @tittle = 'New Transaction'
    elsif params[:type] == 'exch'
      @tittle = 'New Exchange'
    end
    @tr_statement = TrStatement.new
  end

  # GET /tr_statements/1/edit
  def edit
    @action = 'EDIT'
    @usr = session[:user_id].to_s
    @mov_type = params[:type]
    if params[:type] == 'tr'
      @tittle = 'Edit Transaction'
    elsif params[:type] == 'exch'
      @tittle = 'Edit Exchange'
    end
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

    function_update

    respond_to do |format|
      if @tr_statement.update(tr_statement_params)
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
    function_delete

    #@tr_statement.destroy
    #respond_to do |format|
    #format.html { redirect_to tr_statements_url, notice: 'Transaction was successfully destroyed.' }
    #format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tr_statement
      @tr_statement = TrStatement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tr_statement_params
      params.require(:tr_statement).permit(:currency_dest, :amount_dest, :status, :created_by, :coinbag_dest, :coinbag, :fee, :hash, :version, :mov_type, :date_time, :timezone, :classification, :detail, :from, :to, :currency, :amount, :celebrate)
    end

    #function to manipulate form data
    def data_manipulation

      @tempo = Time.now

      params[:tr_statement][:date_time] = Time.new(params[:tr_statement][:"date_time"][0..3].to_i,params[:tr_statement][:"date_time"][5..6].to_i,params[:tr_statement][:"date_time"][8..9].to_i,1,45,45,"+00:00")
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
#      r = RethinkDB::RQL.new
#      conn = r.connect(:host => "localhost", :port => 28015)

#      r.db('treasury_development').table('tr_statements').insert({
#        :reason => params[:tr_statement][:reason],
#        :celebrate => params[:tr_statement][:celebrate],
#        :date_time => params[:tr_statement][:date_time],
#        :transaction_link => params[:tr_statement][:transaction_link],
#        :mov_type => params[:tr_statement][:mov_type],
#        :timezone => params[:tr_statement][:timezone],
#        :classification => params[:tr_statement][:classification],
#        :coinbag => params[:tr_statement][:coinbag_dest],
#        :amount => params[:tr_statement][:amount_dest],
#        :currency => params[:tr_statement][:currency_dest],
#        :from => params[:tr_statement][:from],
#        :to => params[:tr_statement][:to],
#        :exch_destin => "Received",
#        :created_by => session[:user_id],
#        :transaction_id => params[:tr_statement][:id],
#        :status => 'I'
#      }).run(conn)

#      conn.close
    end

    def function_update

  #    respond_to do |format|
        begin
          @Record = TrStatement.find(params[:id])

          r = RethinkDB::RQL.new
          conn = r.connect(:host => "localhost", :port => 28015)

          r.db('treasury_development').table('tr_statements').insert({
            :id => ([*('A'..'Z'),*('0'..'9'),*('a'..'z')]-%w(Y)).sample(16).join,
            :detail => TrStatement.where(id: params[:id]).map(&:detail)*",",
            :celebrate => TrStatement.where(id: params[:id]).map(&:celebrate)*",",
            :date_time => TrStatement.where(id: params[:id]).map(&:date_time)*",",
            :mov_type => TrStatement.where(id: params[:id]).map(&:mov_type)*",",
            :timezone => TrStatement.where(id: params[:id]).map(&:timezone)*",",
            :classification => TrStatement.where(id: params[:id]).map(&:classification)*",",
            :coinbag => TrStatement.where(id: params[:id]).map(&:coinbag)*",",
            :coinbag_dest => TrStatement.where(id: params[:id]).map(&:coinbag_dest)*",",
            :amount => TrStatement.where(id: params[:id]).map(&:amount)*",",
            :currency => TrStatement.where(id: params[:id]).map(&:currency)*",",
            :currency_dest => TrStatement.where(id: params[:id]).map(&:currency_dest)*",",
            :amount_dest => TrStatement.where(id: params[:id]).map(&:amount_dest)*",",
            :from => TrStatement.where(id: params[:id]).map(&:from)*",",
            :to => TrStatement.where(id: params[:id]).map(&:to)*",",
            :created_by => TrStatement.where(id: params[:id]).map(&:created_by)*",",
            :fee => TrStatement.where(id: params[:id]).map(&:fee)*",",
            :hash => TrStatement.where(id: params[:id]).map(&:hash)*",",
            :version => TrStatement.where(id: params[:id]).map(&:version)*",",
            :link_id => params[:id],
            :status => 'U'
          }).run(conn)

          conn.close

        rescue
          flash[:alert] = 'Transaction was unsuccessfully updated!!!, try again...'
          render :edit
        end

#      end

    end

    def function_delete()
      begin
        r = RethinkDB::RQL.new
        conn = r.connect(:host => "localhost", :port => 28015)

        r.db('treasury_development').table("tr_statements").filter({
          :id => params[:id]}).update({
            :status => 'D'
        }).run(conn)

        conn.close

        flash[:success] = 'Transaction was successfully destroyed.'
        redirect_to tr_statements_url
      rescue
        flash[:alert] = 'Transaction was unsuccessfully destroyed!!!'
        redirect_to tr_statements_url
      end
    end
end
