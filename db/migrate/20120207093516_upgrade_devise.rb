class UpgradeDevise < ActiveRecord::Migration
  def up
    remove_column :users, :remember_token
    add_column :users, :reset_password_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string
  end

  def down
    add_column :users, :remember_token, :string
    remove_column :users, :reset_password_sent_at
    remove_column :users, :unconfirmed_email
  end
end
