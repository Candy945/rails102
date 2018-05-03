class WelcomeController < ApplicationController
  def index
    flash[:notice] = "早安！你好！"
    flash[:alert] = "erro"
    flash[:warning] = "Sorry"
  end
end
