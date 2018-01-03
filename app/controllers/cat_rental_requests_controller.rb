class CatRentalRequestsController < ApplicationController
  def new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_request_params)

    if @cat_rental_request.save
      redirect_to cat_rental_request_url(@cat_rental_request)
    else
      render json: @cat_rental_request.errors.full_messages, status: :unprocessable_entity
    end
  end

  def show
    @cat_rental_requests = CatRentalRequest.all.order('start_date')

    render :show
  end

  def approve
    @cat_rental_request = CatRentalRequest.find_by(id: params[:id])

    if @cat_rental_request.approve!
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render json: @cat_rental_request.errors.full_messages, status: :unprocessable_entity
    end
  end

  def deny
    @cat_rental_request = CatRentalRequest.find_by(id: params[:id])

    if @cat_rental_request.deny!
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render json: @cat_rental_request.errors.full_messages, status: :unprocessable_entity
    end
  end

  private
  def cat_rental_request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
  end
end
