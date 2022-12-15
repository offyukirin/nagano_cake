class Public::OrdersController < ApplicationController
  
  before_action :authenticate_customer!

  def index
    @orders = current_customer.orders.all.page(params[:page]).per(6).order('created_at DESC')
    
  end


  def new
    @order = Order.new
    @customer = current_customer
    @addresses = current_customer.addresses
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    if @order.save!
      @cart_items = current_customer.cart_items
      @cart_items.each do |cart_item|
        order_detail = OrderDetail.new(order_id: @order.id)
        order_detail.price = cart_item.item.price
        order_detail.amount = cart_item.amount
        order_detail.item_id = cart_item.item_id
        order_detail.save!
      end
      @cart_items.destroy_all
      redirect_to public_orders_complete_path
    else
      render "new"
    end
  end

  def show
    @order = Order.find(params[:id])
    @order.pay = 0
    @order.price = 1900
    @order.postage = 800
    @order_details = @order.order_details.all
    
  end

  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.pay = 0
    @total_price = current_customer.cart_items.cart_items_total_price(@cart_items)
    @order.postage = 800
     @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + " " + current_customer.first_name
      render 'confirm'

    if params[:address_option] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + " " + current_customer.first_name
      render 'confirm'
    elsif params[:address_option] == "1"
      @address = Address.find(params[:order][:id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
      render 'confirm'
    elsif params[:address_option] == "2"
      @address = current_customer.addresses.new
      @address.address = params[:address]
      @address.name = params[:name]
      @address.postal_code = params[:order][:postal_code]
      @address.customer_id = current_customer.id
      if @address.save
      @order.postal_code = @address.postal_code
      @order.name = @address.name
      @order.address = @address.address
      else
       render 'new'
      end
    end
  end

  def complete
  end

  private

  def order_params
    params.permit(:pay, :postal_code, :addresss, :name, :postage, :price)
  end

  def address_params
    params.require(:address).permit(:customer_id, :postal_code, :address, :name)
  end


end
