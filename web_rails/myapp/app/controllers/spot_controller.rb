class SpotController < ApplicationController
  def new
    if logged_in?
      @product = Product.new
    else
      redirect_to root_url
    end
  end

  def commit_product
    @product = Product.new(product_params)
    if @product.save
      session[:product_name] = @product[:product_name]
      
      redirect_to :reg_spot
    else
      flash.now[:danger] = 'さくひんの名前を入力してください'
      redirect_to :add_spot
    end
  end

  def create
    if logged_in?
      @p = Product.find_by(product_name: session[:product_name])
      @spot = Spot.new(spot_params)
      @spot.rate = 0
      @spot.product_id = @p.id
      if @spot.save
        @user_spot = UserSpot.new()
        @user_spot.user_id = session[:user_id]
        @user_spot.spot_id = @spot.id

        @user_spot.save

        session.delete(:product_id)
      
        flash[:success] = "観光地の登録が完了しました!"
        redirect_to :complete_spot
      else
        flash[:danger] = 'さくひんの名前を入力してください'
        redirect_to :add_spot
      end
    else
      redirect_to root_url
    end
  end

  private

    def product_params
      params.require(:product).permit(
        :product_name,
        :genre_id,
      )
    end

    def spot_params
      params.require(:spot).permit(
        :spot_name,
        :product_id,
        :evalution,
        :user_id,
        :details,
        :image_path,
        :postcode1,
        :postcode2,
        :prefecture_code, 
        :address_city, 
        :address_street, 
        :address_building,
        {images: []})
    end
end
