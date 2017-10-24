class Fee

  Prices = { siag_member:          [400, 500],
             siam_member:          [410, 510],
             speaker_or_organizer: [480, 580],
             non_member:           [520, 620],
             single_day:           [250, 300],
             student:              [100, 120] }

  # single_day: true/false
  def initialize(user, single_day: nil)
    @user = user
    @single_day = single_day
    # 0, 1 in array
    @array_number = (Date.today <= Deadline.pre_registration_end) ? 0 : 1
  end

  # FIXME order inverse of payments
  def price_to_pay_and_reason
    res = if @user.student
      [Prices[:student][@array_number], "you are registered as a student"]
    elsif @single_day
      [Prices[:single_day][@array_number], "one day registration"]
    elsif @user.siag
      [Prices[:siag_member][@array_number], "you are registered as a siag member"]
    elsif @user.siam
      [Prices[:siam_member][@array_number], "you are registered as a siam member"]
    elsif @user.speaker_or_organizer?
      [Prices[:speaker_or_organizer][@array_number], "you are a non-member mini speaker or organizer"]
    else
      [Prices[:non_member][@array_number], "you are a non-member and with no presentations accepted"]
    end
    if (tickets = @user.banquet_tickets.to_i) > 0
      res = [res[0].to_i + tickets * 65, res[1].html_safe + ".<br/>#{tickets} extra banquet tickets included".html_safe ]
    end
    res
  end

  def price_to_pay
    price_to_pay_and_reason[0]
  end

  def self.prices
    Prices
  end
end

