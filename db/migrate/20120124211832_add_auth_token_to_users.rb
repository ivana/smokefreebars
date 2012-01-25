class AddAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :auth_token, :string

  end
end

# User.all.each { |u| u.auth_token = SecureRandom.urlsafe_base64; u.save }