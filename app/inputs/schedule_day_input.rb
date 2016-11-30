class ScheduleDayInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    days = (0..Rails.configuration.number_of_days).map do |i|
      [I18n.l(Rails.configuration.conference_start_date + i.days, format: :schedule ), i]
    end
    # @builder.input attribute_name, :as => :radio_buttons, :item_wrapper_class => 'inline', :collection => [ 10, 20, 30 ]
    @builder.select(attribute_name, days, { }, { class: 'form-control select' } )
  end
end

