class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  before_action :ensure_correct_user, only: [:index, :show, :users]
  def index
    @users = User.order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.order(id: :desc).page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def ensure_correct_user
    if @current_user.id !=  params[:id].to_i
      redirect_to @current_user
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
