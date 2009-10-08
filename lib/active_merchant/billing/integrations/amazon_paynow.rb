require File.dirname(__FILE__) + '/amazon_paynow/helper.rb'
require File.dirname(__FILE__) + '/amazon_paynow/return.rb'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    module Integrations #:nodoc:

      # To start with Amazon Pay now, follow the instructions for installing 
      # ActiveMerchant as a plugin, as described on 
      # http://www.activemerchant.org/.
      # 
      # The AmazonPaynow helper facilitates creating the Amazon FPS Pay now  
      # button/link dymanically for any product discription/price price/dercription
      #
      # Here is the relevent documentation about Amazon Pay now
      # http://docs.amazonwebservices.com/AmazonFPS/2007-01-08/PayNowWidgetImplementationGuide/
      # 
      # The following code renders a html form that redirect to Amazon FPS
      # Pay Now pipeline
      # 
      # The syntax of the helper is as follows:
      # 
      # <% payment_service_for 'order11', nil,
      #                         :aws_access_key_id => 'KJAJJJAKSUEKAHCNEKRU',
      #                         :aws_secret_access_key => 'saskjdhfLKJlkjasdfasfasdksjdfhdksjfha',
      #                         :service => :amazon_paynow  
      #   do |service| %>
      #
      # <%    service.description "Purchase at Foo bar store"
      # <%    service.amount "USD 400" %> 
      # <%    service.immediate_return false %>
      # <%    service.return_url url_for(:only_path => false, :action => 'done') %>
      # <%    service.cancel_return_url  url_for(:only_path => false, :action => 'cancel') %>
      #        <p>Proceed to make payment<p>
      # <%=image_submit_tag 'https://authorize.payments.amazon.com/pba/images/payNowButton.png' %>
      # <% end %>
      #
      #   
      # The following code is a quick example (not complete) of how the the response from Amazon FPS 
      # Pay Now pipeline is handled using the AmazonPaynow::Return class
      # 
      # <% resp = ActiveMerchant::Billing::Integrations::AmazonPaynow::Return.new(request.query_string)
      #
      #  status = resp.status
      #
      #  if (status == 'PS' || status == 'PI' || status == 'PF') && !resp.acknowledge(@aws_secret_access_key)
      #    msg = 'There was a problem while returning back to our web site. There could be a malware in your browser changing the data returned to our website'
      #  elsif status == 'PS'
      #    msg = 'Thank You for your payment'
      #  elsif resp.status == 'PI'
      #    msg = 'Your payment is initiated. We will process the order once the payment is complete.'
      #  elsif status == 'PF'
      #    msg = 'Your payment has failed. Please try again using a different payment method'
      #  elsif status == 'SE'
      #    msg = 'There is a temporary problem with the payment system. Please try again after some time'
      #  elsif status == 'ME'
      #    msg = 'There is a problem processing the payment.'
      #    error_message = resp.error_message
      #  elsif status == 'A'
      #    msg = 'You have aborted the payment'
      #  end
      # %>
      # <h2><%=msg%></h2>
      # 

      module AmazonPaynow 
       
        mattr_accessor :test_url
        self.test_url = 'https://authorize.payments-sandbox.amazon.com/pba/paypipeline'
        
        mattr_accessor :production_url 
        self.production_url = 'https://authorize.payments.amazon.com/pba/paypipeline'
        
        def self.service_url
          mode = ActiveMerchant::Billing::Base.integration_mode
          case mode
          when :production
            self.production_url    
          when :test
            self.test_url
          else
            raise StandardError, "Integration mode set to an invalid value: #{mode}"
          end
        end        
      end
    end
  end
end
