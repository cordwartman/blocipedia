class WikisController < ApplicationController
  include ApplicationHelper
  
  before_filter :authenticate_user!

 
  
  def index
    @wikis = policy_scope(Wiki)
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @user = current_user
    @wiki = Wiki.new
  end

  def create
    @user = current_user
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user

    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to [ @wiki ]
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :new
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    @users = User.all
    @collaborator = Collaborator.new
  end
  
  def update
    @wiki = Wiki.find(params[:id])

    @wiki.assign_attributes(wiki_params)
    @wiki.user_ids = params[:wiki][:user_ids] if params[:wiki][:user_ids].present?
    
    if @wiki.save
      flash[:notice] = "Wiki was updated."
      redirect_to wiki_url(@wiki)
    else
      flash.now[:alert] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end  

  
  def destroy
    @wiki = Wiki.find(params[:id])

    if @wiki.destroy
      flash[:notice] = "\"#{@wiki.title}\" was deleted successfully."
      redirect_to action: :index
    else
      flash.now[:alert] = "There was an error deleting the wiki."
      render :show
    end
  end
  
  
  private
  
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private, :user, :user_ids)
  end
end
