require File.dirname(__FILE__) + '/../../../test_helper'

class AmazonPaynowHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations
  
  def setup
    @helper = AmazonPaynow::Helper.new('order-500',nil, :aws_access_key_id => 'JDAKJHKASKDJAHSKDJHA', :aws_secret_access_key => 'askdjhdueHAKSUENajskshdyYWJANSKDJ')
  end
 

  def test_form_fields
    @helper.description 'Product 500'
    @helper.amount 'USD 10.11'
    @helper.immediate_return false
    @helper.return_url 'http://localhost:3000/amazon_paynow/done'
    @helper.cancel_return_url 'http://localhost:3000/amazon_paynow/cancel'

    # calling this function as only then signature gets computed
    form_fields = @helper.form_fields

    assert_field 'description', 'Product 500'
    assert_field 'amount', 'USD 10.11'    
    assert_field 'referenceId', 'order-500'
    assert_field 'accessKey', 'JDAKJHKASKDJAHSKDJHA'
    assert_field 'immediateReturn', '0'
    assert_field 'accessKey', 'JDAKJHKASKDJAHSKDJHA'
    assert_field 'returnUrl', 'http://localhost:3000/amazon_paynow/done'
    assert_field 'abandonUrl', 'http://localhost:3000/amazon_paynow/cancel'    
    assert_field 'signature', 'GQAXF+ww53KnTBOGTapsY+hP12Y='
  end 
end
