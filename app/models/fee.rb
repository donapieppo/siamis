class Fee

  Prices = { siag_member:          [400, 500],
             siam_member:          [410, 510],
             speaker_or_organizer: [480, 580],
             non_member:           [520, 620],
             one_day:              [250, 300],
             student:              [100, 120] }

  def initialize(user)
    @user = user
    # 0, 1 in array
    @array_number = (Date.today <= Deadline.pre_registration_end) ? 0 : 1
  end

  def price_to_pay_and_reason
    if @user.siag
      [Prices[:siag_member][@array_number], "you are registered as a siag member"]
    elsif @user.siam
      [Prices[:siam_member][@array_number], "you are registered as a siam member"]
    elsif @user.student
      [Prices[:student][@array_number], "you are registered as a student"]
    elsif @user.speaker_or_organizer?
      [Prices[:speaker_or_organizer][@array_number], "you are a non-member mini speaker or organizer"]
    else
      [Prices[:non_member][@array_number], "since you are a non-member and with no presentations"]
    end
  end

  def price_to_pay
    price_to_pay_and_reason[0]
  end

  def self.prices
    Prices
  end
end

