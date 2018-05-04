class MainController < ApplicationController
  def home
  end

  def help
  end

  def about
    len   = ActiveSupport::MessageEncryptor.key_len
    salt  = SecureRandom.random_bytes(len)
    key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, len)
    $crypt = ActiveSupport::MessageEncryptor.new(key)
  end
end
