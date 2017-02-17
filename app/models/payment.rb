class Payment < ApplicationRecord
  belongs_to :user
  has_one :conference_registration

  validates :user_id, presence: true

  attr_accessor :redirect_url

  after_create :create_seed_and_shop_id,
               :start_pay

  scope :verified, -> { where(verified: true) }

  def description
    "Siam-IS18 registration: #{user.surname}, #{user.name[0]}. <#{user.email}>"[0..98]
  end

  # AFTER_CREATE???
  def start_pay
    self.new_record? and return nil
    @unicredit = Unicredit.new(self)
    payment_id, redirect_url = @unicredit.ask(self.amount, description)
    self.payment_id = payment_id
    self.save!
    @redirect_url = redirect_url
  end

  def verify
    if res = Unicredit.new(self).verify
      logger.info("verify RES: #{res.inspect}")
      self.update_attribute(:verified, true)
      # FIXME 
      self.user.conference_registration = ConferenceRegistration.new(payment: self)
    end
    res
  end

  def user_abbr
    ("u#{self.user.id}" + self.user.name[0] + self.user.surname[0]).downcase
  end

  private

  def create_seed_and_shop_id
    self.seed = SecureRandom.hex(4)
    self.shop_id = "Siam-#{self.id}-#{self.user_abbr}-#{self.seed}"
    self.save
  end
end

