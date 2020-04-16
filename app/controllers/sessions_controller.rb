class SessionsController < ApplicationController
  before_action :require_username, except: [:create]

  def show
    return unless set_user
    return unless set_session

    unless @user_current == @user
      return api_render errors: { user: ['forbidden'] }, status: false, code: 403
    end

    api_render result: { session: @session }
  end

  def index
    return unless set_user

    unless @user_current == @user
      return api_render errors: { user: ['forbidden'] }, status: false, code: 403
    end

    api_render result: { sessions: @user.sessions }
  end

  def create
    return unless set_user_by_mail_or_username

    unless @user.check_password(user_params[:password])
      return api_render errors: { password: ['is wrong'] }, status: false, code: 400
    end

    @session = @user.sessions.create(description: params[:description])
    api_render result: { key: @session.key, session: @session }
  end

  def destroy
    return unless set_user
    return unless set_session

    if @session_current == @session
      @session.destroy!
      return api_render
    end

    unless @user_current.check_password(params[:password])
      return api_render errors: { user: ['forbidden'] }, status: false, code: 403
    end

    @session.destroy!

    api_render code: 200
  end

  private

  def user_params
    params[:user] ||= { username: nil, password: nil, email: nil }

    params.require(:user).permit(:username, :password, :email)
  end

  def set_user_by_mail_or_username
    @user = User.find_by username: user_params[:username]
    @user ||= User.find_by email: user_params[:email]
    unless @user
      api_render errors: { user: ['not found'] }, status: false, code: 404
      return false
    end

    true
  end

  private
  def set_user
    unless (@user = User.find_by id: params[:user_id])
      api_render errors: { user: ['not found'] }, status: false, code: 404
      return false
    end

    true
  end

  def set_session
    unless (@session = @user.sessions.find_by id: params[:session_id])
      api_render errors: { session: ['not found'] }, status: false, code: 404
      return false
    end

    true
  end
end
