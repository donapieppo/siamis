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


    Schedule.conference_days_array.each do |day|
      Schedule.startings_cest(day).each do |hour|
        slot(day, hour)
        start_new_page
      end
    end
  end

  def slot(day, hour)
    schedule = Schedule.day_program(day, start: hour).to_a
    schedule.any? or return 

    res    = []
    colors = []

    colors << "ffffff"
    res << schedule.map{|s| s.room.name }
    colors << "ffffff"
    res << schedule.map{|s| s.room.capacity }
    colors << "f18f01"
    res << schedule.map{|s| "<b>#{s.conference_session_with_part}</b>"}

    # 0 = ----
    # 1 = --
    # 2 = ---
    organizers = []
    max = 0
    schedule.each do |s| 
      session_organizers = s.conference_session.organizers.includes(:user).map(&:to_s)
      max = session_organizers.size if max < session_organizers.size
      organizers << session_organizers
    end

    (0 ... max).each do |i|
      res2 = []
      organizers.each do |line|
        res2 << line[i]
      end
      colors << "99c24d"
      res << res2
    end 

    speakers = []
    max = 0 
    schedule.each do |s| 
      session_speakers = s.conference_session.speakers(s.part).map(&:to_s)
      max = session_speakers.size if max < session_speakers.size
      speakers << session_speakers
    end

    (0 ... max).each do |i|
      res2 = []
      speakers.each do |line|
        res2 << line[i]
      end
      colors << "e4e6c3"
      res << res2
    end 

    text "#{I18n.l day} #{hour.split(':')[0].to_i + 2}:#{hour.split(':')[1]}", style: :bold, size: 18

    table(res, cell_style: { inline_format: true, width: 65 }, 
               row_colors: colors)
  end
end



