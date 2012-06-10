class ProductController < ApplicationController
  def create
  end

  def show
  end

  def delete
  end
  
  def index
  @products = Product.all
  respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @products }
    end
  
  end
end
