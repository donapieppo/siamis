# encoding: utf-8

require 'humanize'

class PrintableRecipe < Prawn::Document

  def initialize(conference_registration)
    @conference_registration = conference_registration
    @user = @conference_registration.user
    @payment = @conference_registration.payment

    super(page_size: 'A4', left_margin: 100, right_margin: 100)

    font_families.update("LiberationSans" => {
      bold:   "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
      normal: "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
      italic: "/usr/share/fonts/truetype/liberation/LiberationMono-Italic.ttf"
    })
    font "LiberationSans"
    font_size 12
    default_leading 5

    # A4 595.28 x 841.89
    image Rails.root.join('app/assets/images/siam_recipe_header.jpg'), at: [40,720], width: 300

    move_down(200)

    text "TO WHOM IT MAY CONCERN", size: 16, style: :bold, align: :center

    move_down(50)

    text "This is to certify that Prof./Dr. #{@user.cn} from #{@user.affiliation} paid on #{I18n.l(@payment.created_at.to_date)} the amount of € #{@payment.amount} (#{@payment.amount.humanize} euros) as registration fee for the participation to the SIAM Conference on Imaging Science organized at the University of Bologna (june 5-8, 2018).", align: :justify

    move_down(60)

    text "The  SIAM IS18
          Organization Committee", align: :right

    move_down(40)

    text "Bologna, "

    move_cursor_to 40

    text "Bologna Committee for IS Conference 2018 (BCIS18)
          Piazza di Porta San Donato 5,  40126 Bologna, Italy", size: 10, align: :center
  end
end

