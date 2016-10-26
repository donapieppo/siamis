class ScheduleHourInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    vals = (8..20).map do |h| 
      ['00', '15', '30', '45'].map do |m|
         "#{"%02d" % h}:#{m}"
      end
    end.flatten
    @builder.select(attribute_name, vals, { }, { class: 'form-control select' } )
  end
end

