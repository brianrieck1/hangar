module Hangar
  class RecordsController < ActionController::Base
    @@foriegn_key_ref = nil
    def delete
      Hangar.created_data.each do |key, value|
        begin
          if !@@foriegn_key_ref.nil?
            @@foriegn_key_ref[1].singularize.camelize.constantize.where(@@foriegn_key_ref[2] => @@foriegn_key_ref[3]).destroy_all
            @@foriegn_key_ref = nil

            value.constantize.find(key).delete
            Hangar.created_data.delete(key)
          else
            value.constantize.find(key).delete
            Hangar.created_data.delete(key)
          end
        rescue ActiveRecord::RecordNotFound => e
          Hangar.created_data.delete(key)
        rescue ActiveRecord::StatementInvalid => e
          puts e.to_s
          @@foriegn_key_ref = /Mysql2::Error: Cannot delete or update a parent row: a foreign key constraint fails\s\(`.*?`.`(.*?)`, CONSTRAINT `\w*` FOREIGN KEY \(`(.*)`\) REFERENCES `.*?`.* WHERE `.*?`.`.*?` = (\d+)/.match(e.to_s)
          retry
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

    private

    def delete_records(key, value)
      begin
        value.constantize.find(key).delete
        Hangar.created_data.delete(key)
      rescue ActiveRecord::RecordNotFound => e
        Hangar.created_data.delete(key)
      rescue ActiveRecord::StatementInvalid => e
        puts e.to_s
        foriegn_key_ref = /Mysql2::Error: Cannot delete or update a parent row: a foreign key constraint fails\s\(`.*?`.`(.*?)`, CONSTRAINT `\w*` FOREIGN KEY \(`(.*)`\) REFERENCES `.*?`.* WHERE `.*?`.`.*?` = (\d+)/.match(e.to_s)
        foriegn_key_ref[1].singularize.camelize.constantize.where(foriegn_key_ref[2] => foriegn_key_ref[3]).destroy_all
        value.constantize.find(key).destroy
        Hangar.created_data.delete(key)
      rescue Exception => e
        json = {"error": e.to_s}.to_json
      end
    end 
  end
end