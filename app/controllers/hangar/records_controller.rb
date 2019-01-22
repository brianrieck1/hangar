module Hangar
  class RecordsController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    def delete
      Hangar.created_data.each do |key, value|
        value.constantize.find(key)&.destroy
      end
      Hangar.created_data.clear
      render json: {"delete": "success"}.to_json, status: 200
    end

    def status
      render json: Hangar.created_data.to_json, status: 200
    end

    def remove
      Hangar.created_data.clear
      render json: {"removal": "success"}.to_json, status: 200
    end

    def record_not_found(_e)
      json = {"record_not_found": _e.to_s}.to_json
      render json: json, status: 404
    end
  end
end
