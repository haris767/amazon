module Owner
  class PurchasesController < ApplicationController
    before_action :authenticate_user!
    # TODO: Order- show latest first, same for other apis
    def index
      @purchases = current_user.products.map(&:purchases).flatten
    end
  end
end
