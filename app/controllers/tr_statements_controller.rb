class TrStatementsController < ApplicationController
  before_action :set_tr_statement, only: [:show, :edit, :update, :destroy]

  # GET /tr_statements
  # GET /tr_statements.json
  def index
    if session[:user_id].to_s == '' or session[:user_id].to_s == nil
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end

    $session_id = session[:user_id]

    respond_to do |format|
      format.html
      format.json { render json: TrStatementsDatatable.new(view_context) }
    end
  end

  # GET /tr_statements
  # GET /tr_statements.json
  def approvals
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end

    @statements_tr = NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
      filter{|wh| (wh['status'].eq('A')) & (wh['created_by'].ne(session[:user_id])) &
        ((wh['from'].eq(session[:user_id])) | (wh['to'].eq(session[:user_id])))}}

    @statements_tr = @statements_tr.to_a

    if @statements_tr.any?
      @statements_tr = @statements_tr.to_a
    else
      flash[:success] = "No transactions to approve..."
      redirect_to tr_statements_path
    end
  end

  # GET /tr_statements/1
  # GET /tr_statements/1.json
  def show
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end
  end

  # GET /tr_statements/new
  def new
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end

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
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end

    @action = 'EDIT'
    @usr = session[:user_id].to_s
    $mov_type = params[:type]
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
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end

    #data manipulation from form
    data_manipulation

    #Insert new category
    if params[:tr_statement][:"array_category"] != ''
      insert_New_Category
    end

    #Version Controll
    params[:tr_statement][:transaction_id] = params[:tr_statement][:"id"]

    # Check if the transaction goes to Approval mode or inserted
    @users = NoBrainer.run(:profile => false) { |r| r.table('users').
          filter{|wh| (wh['group'].eq('Member')) & (wh['id'].ne(session[:user_id])) &
            ((wh['id'].eq(params[:tr_statement][:from])) | (wh['id'].eq(params[:tr_statement][:to])))}}
    @users = @users.to_a

    if @users.any?
      params[:tr_statement][:status] = 'A'
    else
      params[:tr_statement][:status] = 'I'
    end
    #--#

    @tr_statement = TrStatement.new(tr_statement_params)

    respond_to do |format|
      if @tr_statement.save
        # change for here to update the table after form commit
        # If working on exchange operation, the app needs to create an aditional record in DB
        # Link to function to create it.

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
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end

    #data manipulation from form
    data_manipulation

    #Insert new category
    if params[:tr_statement][:"array_category"] != ''
      insert_New_Category
    end

    function_update

    # Check if the transaction goes to Approval mode or inserted
    @users = NoBrainer.run(:profile => false) { |r| r.table('users').
          filter{|wh| (wh['group'].eq('Member')) & (wh['id'].ne(session[:user_id])) &
            ((wh['id'].eq(params[:tr_statement][:from])) | (wh['id'].eq(params[:tr_statement][:to])))}}
    @users = @users.to_a

    if @users.any?
      params[:tr_statement][:status] = 'A'
    else
      params[:tr_statement][:status] = 'I'
    end
    #--#

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

  # PATCH/PUT /tr_statements/Approvals
  def approvals_run
    @TrId = params[:tr_statements][:"transaction_id"].split(',')
    @TrChecked = params[:tr_statements][:"transaction_checked"].split(',')

    i=0
    @TrId.each do |trid|
      if @TrChecked[i] == "true"

        NoBrainer.run(:profile => false) { |r| r.table('tr_statements').
          filter({id: "#{@TrId[i]}"}).
          update({status: 'I'})
        }
      end

      i += 1
    end

    flash[:success] = "Transactions approved!"
    redirect_to tr_statements_path
  end

  # DELETE /tr_statements/1
  # DELETE /tr_statements/1.json
  def destroy
    if session[:user_id].to_s == ''
      flash[:notice] = "You must login to access the app..."
      redirect_to login_path
    end

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

      params[:tr_statement][:amount] = ('0' + params[:tr_statement][:"amount"]).to_f

      if params[:tr_statement][:mov_type] == 'tr'
        params[:tr_statement][:amount_dest] = params[:tr_statement][:amount]
        params[:tr_statement][:currency_dest] = params[:tr_statement][:"currency"]
      else
        params[:tr_statement][:amount_dest] = ('0' + params[:tr_statement][:"amount_dest"]).to_f
      end

      params[:tr_statement][:fee] = ('0' + params[:tr_statement][:"fee"]).to_f
    end

    def load_tables

      #load user table
      @users_tmp = User.where(status: 'Inactive')
      @users = User.all
      @users = @users.order(:nickname)
      @users = @users - @users_tmp

      #load coinbags table
      @coinbag = Coinbag.all
      @coinbag = @coinbag.order(:coinbag)

      load_tables_currencies

      load_tables_classifications
    end

    def load_tables_classifications
      #load Currency table
      @classification = Classification.all
      @classification = @classification.order(:classification)

      #Load defaults from transaction process
      if params[:type] == 'tr'
        @tr_def = ClassificationDefault.where(user_id: session[:user_id], isdefault: 'true', operation: 'tr').map(&:classification_id)*","
      elsif params[:type] == 'exch'
        @tr_def = ClassificationDefault.where(user_id: session[:user_id], isdefault: 'true', operation: 'exch').map(&:classification_id)*","
      end
      #convert activerecord to array
      @tr_def = @tr_def.split(',')
      i=0
      # Add default elements to activerecord
      @tr_def.each do |defaults|
        if i==0
          @tr_def_end = Classification.where(id: @tr_def[i])
        else
          @tr_def_end = @tr_def_end + Classification.where(id: @tr_def[i])
        end
        #Remove activerecord element exist in user defaults
        @classification = @classification.reject {|id| id == Classification.find(@tr_def[i]) }
        # Mark as default in element control
        @tr_def_end[i]['classification'] = '**' + @tr_def_end[i]['classification']
        i=i+1
      end
      # Order the array elements by currency name
      if i > 0
        @tr_def_end = @tr_def_end.sort_by{|e| e[:classification]}
        @classification = @tr_def_end + @classification
      end

      i=0
      #Remove hidden classifications
      if params[:type] == 'tr'
        @tr_hide = ClassificationDefault.where(user_id: session[:user_id], ishide: 'true', operation: 'tr').map(&:classification_id)*","
      elsif params[:type] == 'exch'
        @tr_hide = ClassificationDefault.where(user_id: session[:user_id], ishide: 'true', operation: 'exch').map(&:classification_id)*","
      end
      #convert activerecord to array
      @tr_hide = @tr_hide.split(',')
      @tr_hide.each do |defaults|
        #Remove hidden element exist in activerecord
        @classification = @classification.reject {|id| id == Classification.find(@tr_hide[i]) }
        i=i+1
      end
    end

    def load_tables_currencies
      #load Currency table
      @currency = Currency.all
      @currency = @currency.order(:currency)
      @currency3 = CurrencyDefault.where(user_id: session[:user_id]).map(&:currency_id)*","
      #convert activerecord to array
      @currency3 = @currency3.split(',')
      i=0
      # Add default elements to activerecord
      @currency3.each do |defaults|
        if i==0
          @currency2 = Currency.where(id: @currency3[i])
        else
          @currency2 = @currency2 + Currency.where(id: @currency3[i])
        end
        #Remove activerecord element exist in user defaults
        @currency = @currency.reject {|id| id == Currency.find(@currency3[i]) }
        # Mark as default in element control
        @currency2[i]['currency'] = '**' + @currency2[i]['currency']
        i=i+1
      end
      # Order the array elements by currency name
      if i > 0
        @currency2 = @currency2.sort_by{|e| e[:currency]}
        @currency = @currency2 + @currency
      end
    end

    def function_update
        begin
          @Record = TrStatement.find(params[:id])

          #GET Rethinkdb access data
          rdbaccess = YAML.load_file("#{Rails.root.to_s}/config/rethinkdb.yml")

          r = RethinkDB::RQL.new
          conn = r.connect(:host => rdbaccess["access"]["host"],
            :user => rdbaccess["access"]["user"],
            :password => rdbaccess["access"]["pass"],
            :port => rdbaccess["access"]["port"])

          date_time = TrStatement.where(id: params[:id]).map(&:date_time)*","
          date_time = Time.new(date_time[0..3].to_i,date_time[5..6].to_i,date_time[8..9].to_i,1,45,45,"+00:00")
          amount = TrStatement.where(id: params[:id]).map(&:amount)*","
          amount = amount.to_f
          amount_dest = TrStatement.where(id: params[:id]).map(&:amount_dest)*","
          amount_dest = amount_dest.to_f
          fee = TrStatement.where(id: params[:id]).map(&:fee)*","
          fee = fee.to_f

          r.db(rdbaccess["access"]["db"]).table('tr_statements').insert({
            :id => ([*('A'..'Z'),*('0'..'9'),*('a'..'z')]-%w(Y)).sample(16).join,
            :detail => TrStatement.where(id: params[:id]).map(&:detail)*",",
            :celebrate => TrStatement.where(id: params[:id]).map(&:celebrate)*",",
            :date_time => date_time,
            :mov_type => TrStatement.where(id: params[:id]).map(&:mov_type)*",",
            :timezone => TrStatement.where(id: params[:id]).map(&:timezone)*",",
            :classification => TrStatement.where(id: params[:id]).map(&:classification)*",",
            :coinbag => TrStatement.where(id: params[:id]).map(&:coinbag)*",",
            :coinbag_dest => TrStatement.where(id: params[:id]).map(&:coinbag_dest)*",",
            :amount => amount,
            :currency => TrStatement.where(id: params[:id]).map(&:currency)*",",
            :currency_dest => TrStatement.where(id: params[:id]).map(&:currency_dest)*",",
            :amount_dest => amount_dest,
            :from => TrStatement.where(id: params[:id]).map(&:from)*",",
            :to => TrStatement.where(id: params[:id]).map(&:to)*",",
            :created_by => TrStatement.where(id: params[:id]).map(&:created_by)*",",
            :fee => fee,
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
    end

    def function_delete()
      begin
        rdbaccess = YAML.load_file("#{Rails.root.to_s}/config/rethinkdb.yml")

        r = RethinkDB::RQL.new
        conn = r.connect(:host => rdbaccess["access"]["host"],
          :user => rdbaccess["access"]["user"],
          :password => rdbaccess["access"]["pass"],
          :port => rdbaccess["access"]["port"])

        r.db(rdbaccess["access"]["db"]).table("tr_statements").filter({
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

    def insert_New_Category
      #Insert new category
      if params[:tr_statement][:"array_category"] != ''
        rdbaccess = YAML.load_file("#{Rails.root.to_s}/config/rethinkdb.yml")

        r = RethinkDB::RQL.new

        conn = r.connect(:host => rdbaccess["access"]["host"],
          :user => rdbaccess["access"]["user"],
          :password => rdbaccess["access"]["pass"],
          :port => rdbaccess["access"]["port"])

        @category = params[:tr_statement][:"array_category"].split(',')
        id = params[:tr_statement][:"array_id"].split(',')

        i=0

        @category.each do |categories|
          r.db(rdbaccess["access"]["db"]).table('classifications').insert({
            :id => id[i],
            :classification => @category[i],
            :created_at => Time.now
          }).run(conn)

          i=i+1
        end
        conn.close
      end
    end
end
