require 'net/http'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module AmazonPaynow                
        class Return < ActiveMerchant::Billing::Integrations::Return

#          def initialize(response_string)
#            super
#            @params.each_key do |key|
#                @params[key] = CGI::unescape(@params[key])
#            end              
#          end
          
          def params
            @params
          end

          def reference_id
            params['referenceId']
          end

          def transaction_id
            params['transactionId']
          end
    
          def error_message
            params['errorMessage']
          end  
         
          def signature
            params['signature']
          end
          
          #Status of transaction. List of possible values:
          #<tt>PS</tt>::Indicates that the payment transaction was successful.
          #<tt>PF</tt>::Indicates that the payment transaction has failed and the money was not transferred.
          #             You can redirect your customer to the Amazon Payments Payment Authorization page 
          #             to select a different payment method.
          #<tt>PI</tt>::Indicates the payment has been initiated. It will take between five seconds 
          #             and 48 hours to complete, based on the availability of external payment networks and 
          #             the riskiness of the transaction.
          #<tt>A</tt>::Indicates that your customer abandoned the transaction by clicking on the Cancel 
          #            link during the payment pipeline.
          #<tt>ME</tt>::Indicates that the HTML form received was not constructed properly. Please refer to
          #             the Implementation Guide for instructions on constructing Amazon Payments buttons.
          #<tt>SE</tt>::Indicates a temporary system unavailable error and that the payment was not processed.                      
          def status
            params['status']
          end

          def success
		raise NotImplementedError.new("Use the method status instead")
          end  

          # Validate that the response is in fact from Amazon Pay now pipeline
          # by verifying the signature
          def acknowledge(aws_secret_access_key)
            return_info = params.clone
            return_info.delete("signature")            
            string_to_sign = Helper.get_string_to_sign(return_info)
            calculated_signature = Helper.calculate_signature(string_to_sign, 
                                                aws_secret_access_key)
            signature == calculated_signature            
          end
        end
      end
    end
  end
end
