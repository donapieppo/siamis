# Action Mailer provides hooks into the Mail observer and interceptor methods. These allow you to register objects that are called during the mail delivery life cycle.
# An observer object must implement the :delivered_email(message) method which will be called once for every email sent after the email has been sent.
# An interceptor object must implement the :delivering_email(message) method which will be called before the email is sent, allowing you to make modifications to the email before it hits the delivery agents. Your object should make and needed modifications directly to the passed in Mail::Message instance.

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
    # if Rails.configuration.message_footer
    #   message.body = message.body.to_s + "\n ------------------- \n" + Rails.configuration.message_footer
    # end
  end  
end  
