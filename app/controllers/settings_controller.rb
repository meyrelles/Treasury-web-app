class SettingsController < ApplicationController

  #GET
  def index
    @currencies = Currency.all
    @currencies_default = CurrencyDefault.where(user_id: session[:user_id])
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

        r.db('treasury_development').table("users").filter({
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
  end

  private
    def cur_defaults_params
      params.require(:settings).permit(:id, :currency, :user_id, :created_at, :created_by, :currency_id_link)
    end

    def updateCurrenciesDefaults
      @Defaults_cur = params[:settings][:"currencies_name"].split(',')
      @checked_cur = params[:settings][:"currencies_checked"].split(',')

      i=0


      @Defaults_cur.each do |defaults|
        if @checked_cur[i] == "true"

          params[:settings][:id] = SecureRandom.base64
          params[:settings][:currency] = @Defaults_cur[i]
          params[:settings][:currency_id_link] = Currency.where(currency: @Defaults_cur[i]).map(&:id)*","
          params[:settings][:created_at] = Time.now
          params[:settings][:user_id] = session[:user_id]

          @currencydefault = CurrencyDefault.new(cur_defaults_params)

          if @currencydefault.save
            flash[:success] = "Default currencies updated"
          end
        end

        if @checked_cur[i] == "false"
          @currencydefault = CurrencyDefault.where(user_id: session[:user_id], currency: @Defaults_cur[i])
          #.map(&:id)*","
          @currencydefault.destroy_all
        end
        i=i + 1
      end
    end

end
