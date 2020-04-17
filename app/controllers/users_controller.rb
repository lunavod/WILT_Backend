class UsersController < ApplicationController
  before_action :require_login, except: [:create, :show, :index]
  def index
    @users = User.all
    api_render result: { users: @users }
  end

  def show
    return unless set_user

    user_object = @user.as_json

    if @user === @user_current
      user_object = user_object.merge({invites: @user.invites})
    end

    api_render result: { user: user_object }
  end

  def create
    @user = User.new(user_params.except(:invite_code))

    unless user_params['invite_code']
      return api_render errors: {invite: ['is invalid']}, code: 400, status: false
    end

    @invite = Invite.find_by(code: user_params['invite_code'])

    unless @invite
      return api_render errors: {invite: ['is invalid']}, code: 400, status: false
    end

    if @invite.user
      return api_render errors: {invite: ['is invalid']}, code: 400, status: false
    end

    @invite.user = @user
    @invite.save

    unless @user.save
      return api_render errors: @user.errors, status: false, code: 400
    end

    api_render result: { user: @user }, code: 201
  end

  def update
    return unless set_user

    unless @user == @user_current
      return api_render errors: { user: ['forbidden'] }, status: false, code: 403
    end

    if (user_params['avatar']) 
      @user.avatar.attach(user_params['avatar'])
    end
    unless @user.update( user_params )
        return api_render errors: @user.errors, code: 400, status: false
    end

    api_render result: {user: @user}
  end

  def destroy
    return unless set_user

    unless @user == @user_current
      return api_render errors: { user: ['forbidden'] }, status: false, code: 403
    end

    @user.destroy!
    api_render
  end

  private

  def user_params
    params[:user] ||= { username: nil, password: nil, email: nil, description: nil, original_description: nil, avatar: nil, invite_code: nil }

    params.require(:user).permit(:username, :password, :email, :description, :original_description, :avatar, :invite_code)
  end

  def set_user
    @user = User.find_by_id(params[:id])
    unless @user
      @user = User.find_by_username(params[:id])
    end

    unless @user
      api_render errors: { user: ['not found'] }, status: false, code: 404
      return false
    end

    true
  end
end
