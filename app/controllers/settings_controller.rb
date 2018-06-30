class SettingsController < ApplicationController

  #GET
  def index

  end

  #POST /reset_pass
  def save
    #RESET PASSWORD

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



#    $reset_pass='76872645826uytutfaskgdfjashdg'

#    flash[:success] = "Password was successfully updated.!"
#    redirect_to login_path
  end
end
