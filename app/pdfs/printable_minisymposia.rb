# encoding: utf-8
class PrintableMinisymposia < Prawn::Document
  def initialize(minisymposia)
    super()
    font_families.update("LiberationSans" => {
      :bold   => "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
      :normal => "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
      :italic => "/usr/share/fonts/truetype/liberation/LiberationMono-Italic.ttf"
    })
    font "LiberationSans"
    font_size 8

    num = 0
    minisymposia.each do |minisymposium|
      part = 0

      minisymposium.presentations.includes(:authors).order(:part, :number).each do |presentation|
        if (part != (part = presentation.part))
          # new page
          if (num += 1) == 5
            start_new_page
            num = 1
          elsif num != 1 # skip the fir
            move_down(12)
            text "_" * 100, align: :center
            move_down(12)
          end

          text "#{minisymposium.name} [part #{part}]", style: :bold, align: :center, size: 10

          minisymposium.organizers.includes(:user).each do |organizer|
            text organizer.user.to_s, align: :center
          end
          move_down(6)
        end

        move_down(6)
        text "\xC2\xA0 #{presentation.name}", style: :italic
        text "\xC2\xA0 \xC2\xA0   #{presentation.speaker.user.to_s}", size: 6
      end
    end
  end
end


