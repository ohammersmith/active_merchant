require File.dirname(__FILE__) + '/../../test_helper'

class AmazonPaynowModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def test_test_mode
    ActiveMerchant::Billing::Base.integration_mode = :test
    assert_equal 'https://authorize.payments-sandbox.amazon.com/pba/paypipeline', AmazonPaynow.service_url
  end

  def test_production_mode
    ActiveMerchant::Billing::Base.integration_mode = :production
    assert_equal 'https://authorize.payments.amazon.com/pba/paypipeline', AmazonPaynow.service_url
  end

  def test_invalid_mode
    ActiveMerchant::Billing::Base.integration_mode = :preprod
    assert_raise(StandardError){ AmazonPaynow.service_url }
  end

  def test_ui_return
    query_string = 'status=PS&referenceId=orderid85&transactionId=12ROQMTAFV1V348RVSJTQNPTN48TQ64K9HH&signature=oHK0/MU8coqRkygmMURTHp9Ekzc='
    	
    resp = ActiveMerchant::Billing::Integrations::AmazonPaynow::Return.new(query_string)
    
    assert_equal resp.reference_id, 'orderid85'
    assert_equal resp.transaction_id, '12ROQMTAFV1V348RVSJTQNPTN48TQ64K9HH'
    assert_equal resp.status, 'PS'
    assert_equal resp.acknowledge('dummykey'), true
  end

  def test_ui_merchant_error
    query_string = 'status=ME&errorMessage=Merchant+Input+Error%3A+The+following+input+parameters+are+either+invalid+or+absent%3A+%5Bamount%5D&referenceId=orderid904'

    resp = ActiveMerchant::Billing::Integrations::AmazonPaynow::Return.new(query_string)

    assert_equal resp.reference_id, 'orderid904'
    assert_equal resp.status, 'ME'
    assert_equal resp.error_message, 'Merchant Input Error: The following input parameters are either invalid or absent: [amount]'
  end


  def test_ui_return_ack_failure
    
    query_string = 'status=PS&referenceId=orderid85&transactionId=12ROQMTAFV1V348RVSJTQNPTN48TQ64K9HH&signature=oHK0/MU8coqRkygmMURTHp9zc='

    resp = ActiveMerchant::Billing::Integrations::AmazonPaynow::Return.new(query_string)
    
    assert_equal resp.acknowledge('dummy_key'), false
  end

end 
