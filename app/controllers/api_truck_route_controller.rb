class ApiTruckRouteController < BaseApiController

  private

  def find_truck
    @truck = Truck.find_by_name(params[:name])
    render nothing: true, status: :not_found unless @truck.present? && @truck.user == @user
  end
end
