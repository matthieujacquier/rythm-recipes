class UsersController < ApplicationController
  def about
    @user = current_user
  end
end
