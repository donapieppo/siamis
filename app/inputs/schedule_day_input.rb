class ScheduleDayInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    # @builder.input attribute_name, :as => :radio_buttons, :item_wrapper_class => 'inline', :collection => [ 10, 20, 30 ]
    @builder.select(attribute_name, Schedule.days_array_for_select, { }, { class: 'form-control select' } )
  end
end

