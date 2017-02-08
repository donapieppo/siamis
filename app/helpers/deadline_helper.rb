module DeadlineHelper

  def deadline_range(what)
    "from #{I18n.l(Deadline.deadlines[what][:start], format: :deadline)} to #{I18n.l(Deadline.deadlines[what][:end], format: :deadline)}"
  end
end

