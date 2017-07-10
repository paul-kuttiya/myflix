class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string, default: nil
  end
end
