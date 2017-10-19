# encoding: utf-8
class PrintableRegistration < Prawn::Document

  attr_accessor :headers
  attr_accessor :filename
  attr_accessor :title
  attr_accessor :data

  def initialize(conference_registration)
    @conference_registration = conference_registration
    @user = @conference_registration.user
    super()
    move_down(25)
    font "Times-Roman", size: 10

    text @user.cn, size: 18, style: :bold, align: :center
    text @user.email, size: 14, align: :center

    move_down(25)
    data = []
    User.all_fields.each do |field|
      val = @user.send(field)
      next if (val =~ /^\s*$/ || val == false || val == nil) 
      val == true  and val = 'V'
      data << [I18n.t("activerecord.attributes.user.#{field}"), val]
    end
    unless @user.web_page.blank?
      data << ['Home page', @user.web_page]
    end

    table(data, column_widths: [180, 320])
    move_down(25)

    if @payment = @conference_registration.payment
      font "Times-Roman", size: 16
      text "Payment: #{@payment.amount} €"
      move_down(5)
      text "created on #{I18n.l @payment.created_at} with code #{@payment.shop_id}.", size: 10
      if @conference_registration.single_day 
        text "Registered for the day #{I18n.l @conference_registration.single_day}."
      end
    end 
  end
end

