class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :set_locale
  before_action :authenticate
  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale

  end
  def authenticate
    #request.headers['token'].to_json
    if !request.headers['token'].nil?
      token = Token.find_by(token:request.headers["token"])
      if token.nil? or not token.is_valid?
        render json: {message: "Tu token es inválido"}, status: :unauthorized
      else
        @current_user = token.user
      end
    else
      render json: {message: "No se obtuvo el token"}, status: :unauthorized
    end
  end
end
