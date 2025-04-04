class PurchasesController < ApplicationController
  before_action :authenticate_user!

def index
  @purchases = current_user.purchases
  # raise
end
end
