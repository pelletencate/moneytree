require 'test_helper'

module Moneytree
  class AccountTest < ActiveSupport::TestCase
    setup do
      @account = Merchant.create name: 'Mr Boomtown'
      Moneytree::PaymentGateway.create(account: @account, psp: :stripe)
    end

    test 'has one PaymentGateway' do
      assert_equal @account.payment_gateway.class, Moneytree::PaymentGateway
    end
  end
end
