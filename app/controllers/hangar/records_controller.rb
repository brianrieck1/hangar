module Hangar
  class RecordsController < ActionController::Base
    def delete
      Hangar.created_data.each do |key, value|
        value.constantize.destroy(key)
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
  end
end
