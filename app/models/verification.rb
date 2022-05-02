class Verification < ApplicationRecord

	def is_valid? otp
	 	otp_code == otp && (sent_time + 10.minutes) > Time.now
	end
end
