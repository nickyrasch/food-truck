class BaseApiController < ApplicationController
  before_filter :parse_request, :authenticate_user_from_token!

  before_filter :indicate_source

  def indicate_source
    @api = true
  end

  before_filter only: :create do |c|
    meth = c.method(:validate_json)
    meth.call (@json.has_key?('truck') && @json['truck'].responds_to?(:[]) && @json['truck']['name'])
  end

  before_filter only: :update do |c|
    meth = c.method(:validate_json)
    meth.call (@json.has_key?('truck'))
  end

  before_filter only: :create do |c|
    meth = c.method(:check_existence)
    meth.call(@truck, "Truck", "find_by_name(@json['truck']['name'])")
  end

  def validate_json(condition)
    unless condition
      render nothing: true, status: :bad_request
    end
  end

  def update_values(ivar, attributes)
    instance_variable_get(ivar).assign_attributes(attributes)
    if instance_variable_get(ivar).save
      render nothing: true, status: :ok
    else
      render nothing: true, status: :bad_request
    end
  end

  def check_existence(ivar, object, finder)
    instance_variable_set(ivar, instance_eval(object+"."+finder))
  end

  def create
    if @truck.present?
      render nothing: true, status: :conflict
    else
      @truck = Truck.new
      update_values :@truck, @json['truck']
    end
  end

  private

  def parse_request
    @json = JSON.parse(request.body.read)
  end

  def authenticate_user_from_token!
    if !@json['api_token']
      render nothing: true, status: :unauthorized
    else
      @user = nil
      User.find_each do |u|
        if Devise.secure_compare(u.api_token, @json['api_token'])
          @user = u
        end
      end
    end
  end
end
