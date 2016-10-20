class Unicredit
  class WrongTid       < RuntimeError; end
  class WrongShopid    < RuntimeError; end
  class WrongSignature < RuntimeError; end
  class ErrorResponse  < RuntimeError; end

  WSDL   = ENV['SIAMIS_UNICREDIT_WSDL']
  KSIG   = ENV['SIAMIS_UNICREDIT_KSIG']
  TID    = ENV['SIAMIS_UNICREDIT_TID']
  SHOPID = 'Siam-is18'

  def initialize
    # log: true, pretty_print_xml: true
    @client = Savon.client(wsdl: WSDL, logger: Rails.logger, log_level: :debug) 
  end

  # check for errors and returns payment_id, redirect_url
  def parse_response(response)
    res = response.hash[:envelope][:body][:init_response][:response]
    # {:tid=>"****", :rc=>"****", :error=>false, :error_desc=>nil, :signature=>"****", :shop_id=>"****", :payment_id=>"****", :redirect_url=>"****"}
    res[:tid]     == TID    or raise WrongTid
    res[:shop_id] == SHOPID or raise WrongShopid
    if res[:rc] != 'IGFS_000' or res[:error] != false 
      raise ErrorResponse, res[:error_desc]
    end
    res[:signature] == get_signature(res, [:tid, :shop_id, :rc, :error_desc, :payment_id, :redirect_url]) or raise WrongSignature

    return [res[:payment_id], res[:redirect_url]]
  end

  def ask(amount, description)
    request = { tid: TID,
                shopID: SHOPID,
                ShopUserRef: 'pietro.donatini@unibo.it',
                ShopUserName: 'Pietro Donatini', 
                TrType: 'AUTH',
                Amount: amount,
                CurrencyCode: 'EUR', 
                LangID: 'EN',
                NotifyURL: Rails.application.routes.url_helpers.verify_payments_url,
                ErrorURL:  Rails.application.routes.url_helpers.verify_payments_url
    }

    signature = get_signature(request, request.keys)

    response = @client.call(:init) do 
      message(request: request.merge(signature:   signature, 
                                     description: description))
    end
    parse_response(response)
  end

  private 

  def get_signature(hash, keys) 
    data = keys.map {|k| hash[k]}.join('')
    Base64.encode64(OpenSSL::HMAC.digest('sha256', KSIG, data)).chomp
  end
 
end

