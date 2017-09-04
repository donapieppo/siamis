# payment = current_user.payments.new(amount: 10000, single_day: nil)
# payment.save -> start_payment -> ask unicredit 
# if ok    -> settato redirect_url and remote_id
# if ERROR -> settato error_code, error_desc
# 
# solo dopo si puo' fare verify per vedere se l'utente ha fatto 
# correttamente il pagamento
class Payment < ApplicationRecord
  belongs_to :user
  has_one :conference_registration

  validates :user_id, presence: true

  attr_accessor :redirect_url, # from unicredit
                :error_code,   # from unicredit
                :error_desc    # from unicredit

  after_create :copy_user_data,
               :set_seed_and_shop_id,
               :start_payment

  scope :verified, -> { where(verified: true) }

  def description
    "SIAM-IS18 registration: #{user.surname}, #{user.name[0]}. <#{user.email}>"[0..98]
  end

  def start_payment
    Rails.logger.info("In Payment#start_payment: #{self.inspect}")
    @unicredit = Unicredit.new(self)
    if @unicredit.ask(self.amount, description)
      self.payment_id = @unicredit.remote_id
      @redirect_url   = @unicredit.redirect_url
      @error_code = @error_desc = nil
    else
      @error_code = @unicredit.error_code
      @error_desc = @unicredit.error_desc
    end
    self.save
  end

  def verify
    @unicredit = Unicredit.new(self)
    if res = @unicredit.verify
      Rails.logger.info("verify RES: #{res.inspect}")
      self.update_attribute(:verified, true)
      # FIXME 
      self.user.conference_registration = ConferenceRegistration.new(payment: self, single_day: self.single_day)
    else
      @error_code = @unicredit.error_code
      @error_desc = @unicredit.error_desc
    end
    res
  end

  def user_abbr
    ("u#{self.user.id}" + self.user.name[0] + self.user.surname[0]).downcase
  end

  private

  # in case we let change user change data that changes fee
  def copy_user_data
    self.siam    = self.user.siam
    self.siag    = self.user.siag
    self.student = self.user.student
  end

  # Shop_id Chiave esterna identificante l’operazione
  def set_seed_and_shop_id
    self.seed = SecureRandom.hex(4)
    self.shop_id = "SIAM-#{self.id}-#{self.user_abbr}-#{self.seed}"
  end
end

