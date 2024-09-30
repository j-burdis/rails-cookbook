class CategoriesController < ApplicationController
  # before_action :set_list, only: [ :show]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  private
  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :photo)
  end
end
