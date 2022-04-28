class Verification < ApplicationRecord

	def is_valid? otp
	 	otp_code == otp && (sent_time + 30.minutes) > Time.now
	end
end
