class InvitesController < ApplicationController
  before_action :require_login

  def create
    @invite = Invite.create(invite_params.merge({creator: @user_current}))

    api_render errors: @invite.errors, result: {invite: @invite}, code: 201
  end

  private

  def invite_params
    params.require(:invite).permit(:description)
  end
end
