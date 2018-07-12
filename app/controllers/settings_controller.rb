class SettingsController < ApplicationController

  #GET
  def index
    @currencies = Currency.all
    @currencies_default = CurrencyDefault.where(user_id: session[:user_id])

    @classifications = Classification.all
    @classifications_default = ClassificationDefault.where(user_id: session[:user_id])
  end

  #POST /reset_pass
  def save
    #RESET PASSWORD
    if params[:change_pass].present?
      #Verify old password:
      pass = User.where(id: session[:user_id].to_s).map(&:password_digest)*",".to_s
      cryptopass = pass
      if params[:settings][:"old_password"].to_s != ''
        salt  = 'CCEKvUgNbXByO6eAp2pgb56Nur/E16tHA1cYY2Ofai8='
        key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        pass = crypt.decrypt_and_verify(pass, purpose: :login)
      end

      if params[:settings][:"old_password"].to_s == pass

        #Change Password
        salt  = 'CCEKvUgNbXByO6eAp2pgb56Nur/E16tHA1cYY2Ofai8='
        key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
        crypt = ActiveSupport::MessageEncryptor.new(key)
        encrypted_data = crypt.encrypt_and_sign(params[:psw].to_s, purpose: :login)



        rdbaccess = YAML.load_file("#{Rails.root.to_s}/config/rethinkdb.yml")

        r = RethinkDB::RQL.new
        conn = r.connect(:host => rdbaccess["access"]["host"],
          :user => rdbaccess["access"]["user"],
          :password => rdbaccess["access"]["pass"],
          :port => rdbaccess["access"]["port"])

        r.db(rdbaccess["access"]["db"]).table("users").filter({
          :id => session[:user_id]}).update({
            :password_digest => encrypted_data
        }).run(conn)

        conn.close
        flash[:success] = "Password has been changed with sucsess."
        redirect_to settings_path
      else
        flash[:danger] = "Old password inserted is not correct, please try again!!!"
        redirect_to settings_path
      end
    end
    #END CHANGE PASSWORD SCRIPT

    #DEFINE DEFAULT currencies
    if params[:cur_def].present?
      updateCurrenciesDefaults
      redirect_to settings_path
    end

    #DEFINE DEFAULT DETAILS
    if params[:details_def].present?
      updateDetailsDefaults
      redirect_to settings_path
    end
  end

  private
    def cur_defaults_params
      params.require(:settings).permit(:id, :currency, :user_id, :created_at, :created_by, :currency_id, :classification_id, :classification, :isdefault, :ishide, :operation)
    end

    def updateCurrenciesDefaults
      @Defaults_cur = params[:settings][:"currencies_name"].split(',')
      @checked_cur = params[:settings][:"currencies_checked"].split(',')

      i=0


      @Defaults_cur.each do |defaults|
        if @checked_cur[i] == "true"
          params[:settings][:id] = SecureRandom.base64
          params[:settings][:currency] = @Defaults_cur[i]
          params[:settings][:currency_id] = Currency.where(currency: @Defaults_cur[i]).map(&:id)*","
          params[:settings][:created_at] = Time.now
          params[:settings][:user_id] = session[:user_id]

          @currencydefault = CurrencyDefault.new(cur_defaults_params)

          if @currencydefault.save
            flash[:success] = "Currencies updated"
          end
        end

        if @checked_cur[i] == "false"
          @currencydefault = CurrencyDefault.where(user_id: session[:user_id], currency: @Defaults_cur[i])
          #.map(&:id)*","
          @currencydefault.destroy_all
          flash[:success] = "Currencies updated"
        end
        i=i + 1
      end
    end

    def updateDetailsDefaults
      #Defaults for transactions
      @Defaults_tr_def_name = params[:settings][:"classifications_tr_def_name"].split(',')
      @checked_tr_def_checked = params[:settings][:"classifications_tr_def_checked"].split(',')
      #Hide for transactions
      @Defaults_tr_hide_name = params[:settings][:"classifications_tr_hide_name"].split(',')
      @checked_tr_hide_checked = params[:settings][:"classifications_tr_hide_checked"].split(',')

      #Defaults for exchange
      @Defaults_exch_def_name = params[:settings][:"classifications_exch_def_name"].split(',')
      @checked_exch_def_checked = params[:settings][:"classifications_exch_def_checked"].split(',')
      #Hide for Exchange
      @Defaults_exch_hide_name = params[:settings][:"classifications_exch_hide_name"].split(',')
      @checked_exch_hide_checked = params[:settings][:"classifications_exch_hide_checked"].split(',')

      #Defaults for transactions PROCESS
      i=0
      @Defaults_tr_def_name.each do |defaults1|
        if @checked_tr_def_checked[i] == "true"

          params[:settings][:id] = SecureRandom.base64
          params[:settings][:classification] = @Defaults_tr_def_name[i]
          params[:settings][:classification_id] = Classification.where(classification: @Defaults_tr_def_name[i]).map(&:id)*","
          params[:settings][:created_at] = Time.now
          params[:settings][:isdefault] = 'true'
          params[:settings][:ishide] = 'false'
          params[:settings][:operation] = 'tr'
          params[:settings][:user_id] = session[:user_id]

          @classifcationdefault = ClassificationDefault.new(cur_defaults_params)

          if @classifcationdefault.save
            flash[:success] = "Details updated"
          end
        end

        if @checked_tr_def_checked[i] == "false"
          @classifcationdefault = ClassificationDefault.where(user_id: session[:user_id], classification: @Defaults_tr_def_name[i], isdefault: 'true', operation: 'tr')
          #.map(&:id)*","
          @classifcationdefault.destroy_all
          flash[:success] = "Details updated"
        end
        i=i + 1
      end

      #Hidden for transactions PROCESS
      i=0
      @Defaults_tr_hide_name.each do |defaults2|
        flash[:success] = "HIDDEN"
        if @checked_tr_hide_checked[i] == "true"

          params[:settings][:id] = SecureRandom.base64
          params[:settings][:classification] = @Defaults_tr_hide_name[i]
          params[:settings][:classification_id] = Classification.where(classification: @Defaults_tr_hide_name[i]).map(&:id)*","
          params[:settings][:created_at] = Time.now
          params[:settings][:isdefault] = 'false'
          params[:settings][:ishide] = 'true'
          params[:settings][:operation] = 'tr'
          params[:settings][:user_id] = session[:user_id]

          @dbrecord = ClassificationDefault.new(cur_defaults_params)

          if @dbrecord.save
            flash[:success] = "Details updated"
          end
        end

        if @checked_tr_hide_checked[i] == "false"
          @dbrecord = ClassificationDefault.where(user_id: session[:user_id], classification: @Defaults_tr_hide_name[i], ishide: 'true', operation: 'tr')
          #.map(&:id)*","
          @dbrecord.destroy_all
          flash[:success] = "Details updated"
        end
        i=i + 1
      end

      #Defaults for exchange PROCESS
      i=0
      @Defaults_exch_def_name.each do |defaults3|
        if @checked_exch_def_checked[i] == "true"

          params[:settings][:id] = SecureRandom.base64
          params[:settings][:classification] = @Defaults_exch_def_name[i]
          params[:settings][:classification_id] = Classification.where(classification: @Defaults_exch_def_name[i]).map(&:id)*","
          params[:settings][:created_at] = Time.now
          params[:settings][:isdefault] = 'true'
          params[:settings][:ishide] = 'false'
          params[:settings][:operation] = 'exch'
          params[:settings][:user_id] = session[:user_id]

          @classifcationdefault = ClassificationDefault.new(cur_defaults_params)

          if @classifcationdefault.save
            flash[:success] = "Details updated"
          end
        end

        if @checked_exch_def_checked[i] == "false"
          @classifcationdefault = ClassificationDefault.where(user_id: session[:user_id], classification: @Defaults_exch_def_name[i], isdefault: 'true', operation: 'exch')
          #.map(&:id)*","
          @classifcationdefault.destroy_all
          flash[:success] = "Details updated"
        end
        i=i + 1
      end

      #Hidden for exchange PROCESS
      i=0
      @Defaults_exch_hide_name.each do |defaults4|
        if @checked_exch_hide_checked[i] == "true"

          params[:settings][:id] = SecureRandom.base64
          params[:settings][:classification] = @Defaults_exch_hide_name[i]
          params[:settings][:classification_id] = Classification.where(classification: @Defaults_exch_hide_name[i]).map(&:id)*","
          params[:settings][:created_at] = Time.now
          params[:settings][:isdefault] = 'false'
          params[:settings][:ishide] = 'true'
          params[:settings][:operation] = 'exch'
          params[:settings][:user_id] = session[:user_id]

          @dbrecord = ClassificationDefault.new(cur_defaults_params)

          if @dbrecord.save
            flash[:success] = "Details updated"
          end
        end

        if @checked_exch_hide_checked[i] == "false"
          @dbrecord = ClassificationDefault.where(user_id: session[:user_id], classification: @Defaults_exch_hide_name[i], ishide: 'true', operation: 'exch')
          #.map(&:id)*","
          @dbrecord.destroy_all
          flash[:success] = "Details updated"
        end
        i=i + 1
      end
    end

end
