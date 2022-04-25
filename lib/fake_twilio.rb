class FakeTwilio
  def initialize(_account_sid, _auth_token)
  end

  def verify
    @verify ||= Verify.new
  end

end

class Verify
  def initialize
  end

  def services(sid)
    @services = Services.new
  end

end

class Services
  def initialize
  end

  def verifications
    @verifications = Verifications.new
  end

  def verification_checks
    @verification_checks = VerificationChecks.new
  end
end

class Verifications
  def initialize
  end

  def create(to:, channel:)
    return { to: to, channel: channel }
  end
end

class VerificationChecks
  def initialize
  end

  def create(to:, code:)
    return OpenStruct.new(status:  'approved')
  end
end
