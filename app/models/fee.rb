class Fee

  Prices = { siag_member:          [435, 535],
             siam_member:          [445, 545],
             speaker_or_organizer: [510, 610],
             non_member:           [575, 675],
             one_day:              [290, 340],
             student:              [115, 130 ] }

  def initialize(user)
    @user = user
    # 0, 1 in array
    @array_number = (Date.today <= Deadline.pre_registration) ? 0 : 1
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

