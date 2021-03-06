# encoding: utf-8
class PrintableProgram < Prawn::Document
  def initialize
    super(page_size: 'A3', page_layout: :landscape)
    font_families.update("LiberationSans" => {
      :bold   => "/usr/share/fonts/truetype/liberation/LiberationSans-Bold.ttf",
      :normal => "/usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf",
      :italic => "/usr/share/fonts/truetype/liberation/LiberationMono-Italic.ttf"
    })
    font "LiberationSans"
    font_size 6

    old_hour_morning = nil

    first_page

    Schedule.conference_days_array.each do |day|
      Schedule.startings_cest(day).each do |hour|
        if (old_hour_morning != (old_hour_morning = (hour_array(hour)[0] < 11) ? true : false))
          start_new_page
        else
          move_down 20
        end
        slot(day, hour)
      end
    end
  end

  def print_hour(a, plus = 0)
    ("%02d" % (a[0] + 2 + plus)) + ":" + ("%02d" % a[1])
  end

  def hour_array(h)
    h.split(':').map(&:to_i)
  end

  def first_page
    move_down 80
    text " SIAM Conference on IMAGING SCIENCE", size: 32, align: :center
    move_down 20
    text "June 5-8, 2018", size: 28, align: :center
    move_down 20
    text "Bologna - Italy", size: 28, align: :center
    move_down 60
    text "parallel sessions", style: :bold, size: 26, align: :center
  end

  def conference_session_color(cs)
    case cs
    when Minisymposium
      '034f84'
    when ContributedSession
      'c94c4c'
    when Minitutorial
      '405d27'
    else
      '000000'
    end
  end

  def slot(day, hour)
    schedule = Schedule.day_program(day, start: hour).to_a
    schedule.any? or return 

    # IP are alone
    schedule.count < 2 and return ""

    res    = []
    colors = []

    colors << "ffffff"
    res << [""] + schedule.map{|s| "#{s.room.building.name}" }
    colors << "ffffff"
    res << [""] + schedule.map{|s| "#{s.room.name} (#{s.room.capacity})" }
    colors << "ffffff"
    # colors << "f18f01"
    res << [""] + schedule.map{|s| cs = s.conference_session; "<color rgb='#{conference_session_color(cs)}'><b>#{cs.code_with_part(s.part)}\n#{cs.name}</b></color>"}

    # 0 = ----
    # 1 = --
    # 2 = ---
    organizers = []
    max = 0
    schedule.each do |s| 
      session_organizers = s.conference_session.organizers.includes(:user).map(&:cn).join("\n\n")
      # max = session_organizers.size if max < session_organizers.size
      organizers << [session_organizers]
    end

    (0 ... 1).each do |i|
      res2 = [{content: "Organizers", :background_color => "ffffff"}]
      organizers.each do |line|
        res2 << line[i]
      end
      colors << "99c24d"
      res << res2
    end 

    speakers = []
    max = 0 
    schedule.each do |s| 
      session_speakers = s.conference_session.speakers(s.part).map(&:cn)
      max = session_speakers.size if max < session_speakers.size
      speakers << session_speakers
    end

    first_row = true 
    (0 ... max).each do |i|
      res2 = first_row ? [{content: "Speakers", rowspan: max, :background_color => "ffffff"}] : []
      speakers.each do |line|
        res2 << line[i]
      end
      colors << "e4e6c3"
      res << res2
      first_row = false
    end 

    ha = hour_array(hour)
    text "#{I18n.l day, format: :schedule} #{print_hour(ha)} - #{print_hour(ha, 2)}", style: :bold, size: 18
    move_down 20

    table(res, cell_style: { inline_format: true, width: 65 }, row_colors: colors) do
      #column(0).rotate = 90
      column(0).width  = 50
      column(0).align = :right
      column(0).border_width = 0
      column(0).font_style = :bold
    end
  end
end



