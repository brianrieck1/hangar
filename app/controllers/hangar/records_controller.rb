module Hangar
  class RecordsController < ActionController::Base

    def delete
      Hangar.created_data.each do |key, value|
        begin
          value.constantize.find(key).destroy
          Hangar.created_data.delete(key)
        rescue ActiveRecord::RecordNotFound => e
          Hangar.created_data.delete(key)
        rescue Exception => e
          json = {"error": e.to_s}.to_json
        end
      end
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
