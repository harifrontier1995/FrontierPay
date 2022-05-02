class CreateVerifications < ActiveRecord::Migration[7.0]
  def change
    create_table :verifications do |t|
      t.bigint :phone_number
      t.string :otp_code
      t.datetime :sent_time

      t.timestamps
    end
  end
end
