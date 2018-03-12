class ApiTrucksController < BaseApiController
  before_filter :find_truck, only: [:show, :update]

  before_filter only: :create do
    unless @json.has_key?('truck') && @json['truck'].responds_to?(:[]) && @json['truck']['name']
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :update do
    unless @json.has_key?('truck')
      render nothing: true, status: :bad_request
    end
  end

  before_filter only: :create do
    @truck = Truck.find_by_name(@json['truck']['name'])
  end

  def index
    render json: Truck.where('owner_id = ?', @user.id)
  end

  def show
    render json: @truck
  end

  def create
    if @truck.present?
      render nothing: true, status: :conflict
    else
      @truck = Truck.new
      @truck.assign_attributes(@json['truck'])
      if @truck.save
        render json: @truck
      else
        render nothing: true, status: :bad_request
      end
    end
  end

  def update
    @truck.assign_attributes(@json['truck'])
    if @truck.save
      render json: @truck
    else
      render nothing: true, status: :bad_request
    end
  end

  private
  
  def find_truck
    @truck = Truck.find_by_name(params[:name])
    render nothing: true, status: :not_found unless @truck.present? && @truck.user == @user
  end
end

