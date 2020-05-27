class ApplicationController < ActionController::API
  before_action :check_user_current

  rescue_from StandardError,
              with: :render_standard_error

  def render_standard_error error
    puts error
    api_render errors: { server: [error] }, code: 500, status: false
  end

  def api_render(args = {})
    defaults = {
      status: true,
      code: 200,
      errors: {},
      result: {}
    }
    args = defaults.merge(args)
    render json: {
      status: args[:status] ? 'ok' : 'fail',
      code: args[:code],
      errors: args[:errors],
      result: args[:result]
    }, status: args[:code]
  end

  def check_user_current
    @user_current = nil
    @session_current = Session.find_by_key(request.headers["X-Authorization-Bearer"])
    unless @session_current
      return
    end

    @user_current = @session_current.user
  end

  def logged_in?
    !@user_current.nil?
  end

  def require_login
    unless logged_in?
      return api_render errors: { user: ['forbidden'] }, status: false, code: 403
    end
  end
end
