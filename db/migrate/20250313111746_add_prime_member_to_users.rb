class AddPrimeMemberToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :prime_member, :boolean
  end
end
