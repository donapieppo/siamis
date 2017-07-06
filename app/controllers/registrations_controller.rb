class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, :check_privacy_policy, only: [:create] 

  private

  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      respond_with_navigational(resource) { render :new }
    end 
  end

  def check_privacy_policy
    unless params[:user][:privacy_policy] == 'true'
      self.resource = resource_class.new sign_up_params
      self.resource.errors[:privacy_policy] << 'Please check to agree to our Privacy Policy'
      respond_with_navigational(resource) { render :new }
    end
  end
end
