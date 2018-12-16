class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @user_stocks = current_user.stocks
  end

  def my_friends
    @friendships = current_user.friends
  end

  def search
    if params[:search_param].blank?
      flash.now[:danger] = 'You have entered an empty search string'
    else
      # Calling the self.method from model stock.rb file.
      @users = User.search(params[:search_param])
      # Calling the execpt_current_user from the modal, in order
      # to remove the current_user from the search results.
      @users = current_user.execpt_current_user(@users)
      flash.now[:danger] = 'No users match this search criteria' if @users.blank?
    end
    render partial: 'friends/result'
  end

  def add_friend
    @friend = User.find(params[:friend])
    current_user.friendships.build(friend_id: @friend.id)

    if current_user.save
      flash[:success] = 'Friend was successfuly added'
    else
      flash[:danger] = 'There was something wrong with the friendship request'
    end
    redirect_to my_friends_path
  end
end
