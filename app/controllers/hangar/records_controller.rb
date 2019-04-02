module Hangar
  class RecordsController < ActionController::Base

    def delete
      Hangar.created_data.each do |key, value|
        begin

          associations = class_goes_here.reflect_on_all_associations
          associations = associations.select { |a| a.macro == :belongs_to }
          association_foreign_keys = associations.map(&:foreign_key)
          puts "************************************"
          puts association_foreign_keys
          puts "************************************"

          value.constantize.find(key).delete
          Hangar.created_data.delete(key)
        rescue ActiveRecord::RecordNotFound => e
          Hangar.created_data.delete(key)
        rescue ActiveRecord::StatementInvalid => e
          puts e.to_s
          puts "HEYOOOOOOOOOOOOOOOOOOO"
          foriegn_key_ref = /Mysql2::Error: Cannot delete or update a parent row: a foreign key constraint fails\s\(`.*?`.`(.*?)`, CONSTRAINT `\w*` FOREIGN KEY \(`(.*)`\) REFERENCES `.*?`.* WHERE `.*?`.`.*?` = (\d+)/.match(e.to_s)
          foriegn_key_ref[1].singularize.camelize.constantize.where(foriegn_key_ref[2] => foriegn_key_ref[3]).destroy_all
          value.constantize.find(key).destroy
          Hangar.created_data.delete(key)
        rescue Exception => e
          puts "ANOTHER DAMN ERROR DAMNIT"
          retry
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