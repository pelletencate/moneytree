module Moneytree
  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception

    # def current_account
    #   send(Moneytree.current_account)
    # end
  end
end
