class Unicredit
  class WrongTid       < RuntimeError; end
  class WrongShopid    < RuntimeError; end
  class WrongSignature < RuntimeError; end

  WSDL   = ENV['SIAMIS_UNICREDIT_WSDL']
  KSIG   = ENV['SIAMIS_UNICREDIT_KSIG']
  TID    = ENV['SIAMIS_UNICREDIT_TID']

  attr_reader :remote_id,    # ientificativo della richiesta di pagamento (proprietà paymentID), generato da
                             # Pagonline,che dovrà essere utilizzato nelle successive operazioni.
              :redirect_url, # URL per l’instradamento (proprietà redirectURL) verso la pagina per
                             # l’inserimento dei dati dello strumento di pagamento.
              :error_code,
              :error_desc


  # payment = current_user.payments.new(amount: 100)
  # u = Unicredit.new(payment)
  def initialize(payment)
    # log: true, pretty_print_xml: true
    @client  = Savon.client(wsdl: WSDL, logger: Rails.logger, log_level: :debug) 
    @payment = payment
  end

  # TODO using Fee
  def check_amount_range(x)
    true
  end

  # amount in euro but unicredit asks cents
  # check for errors and returns [payment_id, redirect_url] or false in case of errors
  def ask(amount, description)
    check_amount_range(amount)

    request = { tid: TID,
                shopID: @payment.shop_id,
                ShopUserRef: 'pietro.donatini@unibo.it',
                ShopUserName: 'SIAM IS', # non numbers.... no siam-is2018@unibo.it,
                TrType: 'AUTH',
                Amount: amount.to_i * 100,
                CurrencyCode: 'EUR', 
                LangID: 'EN',
                NotifyURL: Rails.application.routes.url_helpers.verify_payment_url(@payment),
                ErrorURL:  Rails.application.routes.url_helpers.error_payment_url(@payment)
    }

    signature    = get_signature(request, request.keys)
    soap_message = request.merge(signature: signature, description: description)

    Rails.logger.info("Unicredit: ask: #{soap_message.inspect}")

    response = @client.call(:init) do 
      message(request: soap_message)
    end

    Rails.logger.info("Unicredit: ask_response: #{response}.hash")
    parse_ask_response(response)
  end

  # return response or false
  # raise with WrongSignature
  def verify
    request = {
      tid: TID,
      shopID:    @payment.shop_id,
      paymentID: @payment.payment_id
    }
    signature    = get_signature(request, request.keys)
    soap_message = request.merge(signature: signature)

    Rails.logger.info("Unicredit: verify: #{soap_message.inspect}")

    response = @client.call(:verify) do 
      message(request: soap_message)
    end

    Rails.logger.info("Unicredit: verify_response: #{response.hash}")
    parse_verify_response(response)
  end

  private 

  def get_signature(hash, keys) 
    data = keys.map {|k| hash[k]}.join('')
    Base64.encode64(OpenSSL::HMAC.digest('sha256', KSIG, data)).chomp
  end
  
  def raise_if_uncorrect(res)
    res[:tid]     == TID    or raise WrongTid
    res[:shop_id] == @payment.shop_id or raise WrongShopid
  end

  def check_return_status(res)
    if res[:rc] != 'IGFS_000' or res[:error] != false 
      Rails.logger.info("Unicredit error in :rc with res=#{res.inspect}")
      @error_code = res[:rc]
      @error_desc = res[:error_desc]
      return false
    end
    true
  end

  # check for errors and fills remote_id, redirect_url when ok
  def parse_ask_response(response)
    res = response.hash[:envelope][:body][:init_response][:response]
    # {:tid=>"****", :rc=>"****", :error=>false, :error_desc=>nil, :signature=>"****", :shop_id=>"****", :payment_id=>"****", :redirect_url=>"****"}

    raise_if_uncorrect(res)

    res[:signature] == get_signature(res, [:tid, :shop_id, :rc, :error_desc, :payment_id, :redirect_url]) or raise WrongSignature

    if check_return_status(res) 
      @remote_id    = res[:payment_id]
      @redirect_url = res[:redirect_url]
      true
    else
      false
    end
  end

  # check for errors and returns response or false
  # raise with WrongSignature
  # see php getResponseSignature
  def parse_verify_response(response)
    res = response.hash[:envelope][:body][:verify_response][:response]
    # {:tid=>"****", :pay_instr=>"CC", :rc=>"IGFS_000", :error=>false, :error_desc=>"TRANSAZIONE OK", :signature=>"****", :shop_id=>"****", :payment_id=>"****", :tran_id=>"****", :auth_code=>"****", :enr_status=>"N", :auth_status=>"U", :brand=>"MASTERCARD", :masked_pan=>"****", :pay_instr_token=>"****", :expire_month=>"****", :expire_year=>"****", :status=>"C"}

    raise_if_uncorrect(res)

    res[:signature] == get_signature(res, [:tid, :shop_id, :rc, :error_desc, :payment_id, :tran_id, :auth_code, :enr_status, :auth_status]) or raise WrongSignature

    check_return_status(res)
  end
end

