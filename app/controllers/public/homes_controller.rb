class Public::HomesController < ApplicationController
  
  def top
    @genres = Genre.where(is_active: true)
    @items = Item.all
    @random = Item.order("RANDOM()").limit(4)
  end

  def about
  end
  
  private
	def params_product
		parmas.require(:item).permit(:image ,:name )
	end

end
