module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:
      module AmazonPaynow
        class Helper < ActiveMerchant::Billing::Integrations::Helper
 
          mapping :amount, 'amount'
          mapping :reference_id, "referenceId"
          mapping :immediate_return, "immediateReturn"
          mapping :aws_access_key_id, "accessKey"
          mapping :return_url, "returnUrl"
          mapping :cancel_return_url, "abandonUrl"
          mapping :description, "description"          
                      
          def initialize(order, account, options = {})            
            @aws_access_key_id = options.delete(:aws_access_key_id)  
            @aws_secret_access_key =  options.delete(:aws_secret_access_key)
            super
            self.aws_access_key_id = @aws_access_key_id  
            self.reference_id = order                                               
          end
            
          # This method accepts a boolean
          def immediate_return(immediate_return_flag)                       
            if immediate_return_flag 
              value = 1
            else 
              value = 0             
            end
            add_field mappings[:immediate_return], value
          end
                   
          def immediate_return=(immediate_return_flag)
            immediate_return(immediate_return_flag)
          end
          
          # Format amount in format "#{currency} #{amount}"                   
          def amount(amt)
            unless amt.nil?                
              if amt.is_a?(String) 
                value = amt
              elsif amt.is_a?(Money)
                value = sprintf("%s %.2f", amt.currency, amt.cents.to_f/100)
              else
                raise ArgumentError, 'money amount must be either a Money object 
                    or a string like "USD 50"'
              end
              add_field mappings[:amount], value
            end
          end
          
          def amount=(amt)            
            amount(amt)
          end     
                   
          def form_fields            
            add_field("signature", Helper::calculate_signature(
                  Helper::get_string_to_sign(super),
                    @aws_secret_access_key))                                                        
            return super            
          end
                         
          # Computes RFC 2104-compliant HMAC signature given
          # given data to sign   
          def self.calculate_signature(data, secret_key)
            digest = OpenSSL::Digest::Digest.new('sha1')
            hmac = OpenSSL::HMAC.digest(digest, secret_key, data)
            Base64.encode64(hmac).chomp
          end
                                
          # Computes the string to sign from the form parameters                   
          def self.get_string_to_sign(field_values)
            sorted_fields = field_values.sort_by { |field, value| field.downcase }  
            sorted_fields.collect {|field, value| field+value}.join
          end                    
          
        end
      end
    end
  end
end
