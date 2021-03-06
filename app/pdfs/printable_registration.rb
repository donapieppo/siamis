# encoding: utf-8
class PrintableRegistration < Prawn::Document

  attr_accessor :headers
  attr_accessor :filename
  attr_accessor :title
  attr_accessor :data

  def initialize(conference_registration)
    @conference_registration = conference_registration
    @user = @conference_registration.user

    super(page_size: 'A4')

    font_families.update("LiberationSans" => {
      bold:   "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
      normal: "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
      italic: "/usr/share/fonts/truetype/liberation/LiberationMono-Italic.ttf"
    })
    font "LiberationSans"
    font_size 12

    move_down(25)

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
      text "Ha pagato #{@payment.amount} €"
      move_down(5)
      text "il giorno #{I18n.l @payment.created_at} (codice #{@payment.shop_id}).", size: 10
      if @conference_registration.single_day 
        text "Registered for the day #{I18n.l @conference_registration.single_day}."
      end
    end 

    move_down(25)

    if @user.in_scientific_committee?  
      text "Member of Scientific Committee", size: 10
    elsif @user.in_local_committee?
      text "Member of Local Committee", size: 10
    end

    move_down(15)

    @user.conference_sessions.each do |conference_session|
      text "Organizzatore di " + conference_session.name, size: 10
    end

    move_down(15)

    @user.speaks_in.each do |presentation|
      text "Relatore in " + presentation.name, size: 10
    end

  end
end

