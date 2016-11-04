class DevelopmentMailInterceptor  
  def self.delivering_email(message)  
    if Rails.env.development?
      Rails.logger.info("modify recipient mail")
      message.subject = "[to :#{message.to} cc:#{message.cc} bcc:#{message.bcc}] #{message.subject}"
      message.to  = 'donatini@dm.unibo.it'
      message.cc  = nil
      message.bcc = nil
    else
      if ! message.bcc.kind_of?(Array)
        message.bcc = message.bcc ? [message.bcc] : []
      end
    end
    if Rails.configuration.message_footer
      message.body = message.body.to_s + "\n ------------------- \n" + Rails.configuration.message_footer
    end
  end  
end  

ActionMailer::Base.smtp_settings = { address: 'localhost', domain:  'dm.unibo.it', enable_starttls_auto: false }
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) 

