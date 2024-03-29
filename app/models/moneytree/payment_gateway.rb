module Moneytree
  class PaymentGateway < ApplicationRecord
    include Moneytree::Account

    belongs_to :account, polymorphic: true

    enum psp: Moneytree::PSPS
    serialize :psp_credentials
    # encrypts :psp_credentials
    # FIXME: enable https://github.com/ankane/lockbox
    delegate :oauth_link, :scope_correct?, to: :payment_provider

    # has_many :orders
    # has_many :transactions
    # has_many :customers
    # has_many :cards

    def oauth_callback(params)
      update! psp_credentials: payment_provider.get_access_token(params)
    end

    def psp_connected?
      psp.present? && psp_credentials.present?
    end

    def needs_oauth?
      !psp_connected? || !scope_correct?
    end

    def scope_correct?
      psp_credentials[:scope] == payment_provider.scope
    end

    def charge; end

    def refund; end

    private

    def payment_provider
      @payment_provider ||=
        case psp
        when 'stripe'
          Moneytree::PaymentProvider::Stripe.new(self)
        # when 'square'
        #   Moneytree::PaymentProvider::Square.new(self)
        else
          raise 'BOOM'
        end
    end
  end
end
