class CreateApiTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :api_tokens do |t|
      t.integer :user_id
      t.text :token
      t.integer :expiry_time
      t.boolean :is_active

      t.timestamps
    end
  end
end
