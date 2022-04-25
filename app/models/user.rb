class User < ApplicationRecord
	has_one :api_token
end
