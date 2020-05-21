class Api::V1::UsersController < ApplicationController
  include UserHelper
  before_action :validate_user
  before_action :set_user, only: [:update]
  before_action :authenticate, except: [:create, :login]
  def index
    @users = User.all
    # @model = { name: "santiago", hobby: "programar" }
    # @job = { name: "programador", language: "ruby" }

    #render json: @test
    #render "api/home/index"
    # @test1 = t('hello')
  end
  def login
    @user = User.from_login(user_params)
    if @user.valid_password?(params[:user][:password])
      @token = Token.new(user_id: @user.id)
      if @token.save
        render "api/v1/users/show"
      else
        render json: {response: t("credentials.invalid")}, status: :bad_request
      end
    else
      render json: {response: t("credentials.user_invalid")}, status: :bad_request
    end
  end
  def create
    @user = User.new(user_params)
    if @user.save
      @token = Token.new(user_id: @user.id)
      if @token.save
        render "api/v1/users/show"
      else
        render json: {response: t("credentials.error"), status: :bad_request}, status: :bad_request
      end
    else
      render json: @user.errors, status: :unprocessable_entity
    end
    # validation = validate_create_user(params[:user])
    # if validation[:validate]
    #   user = User.new(validation[:model])
    #   if user.save
    #     render json: {user: user, status: :created}, status: :created
    #   else
    #     render json: {response: t("credentials.not_params"), status: :bad_request}, status: :bad_request
    #   end
    # else
    #   render json: {response: t("credentials.not_params"), status: :bad_request}, status: :bad_request
    # end
  end
  def update
    if @user.id == @current_user.id
      if @user.update(user_params)
        render "api/v1/users/update"
      else
        render json: {response: t('crud.update_error'), status: :bad_request }, status: :bad_request
      end
    else
      render json: {response: t('credentials.error'), status: :bad_request }, status: :bad_request
    end
  end
  private
  def user_params
    params.require(:user).permit(:email, :password)
  end
  def validate_user
    if !params[:user].present?()
      render json: {:message => t('message.add_name')}
    elsif params[:user].empty?
      render json: {:message => t('rules.dont_empty')}
    end
  end
  def set_user
    begin
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {:message => t('message.dont_find')}
    end
  end
end