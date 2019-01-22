Rails.application.routes.draw do
  constraints Hangar::RouteConstraint.new do
    scope Hangar.route_namespace do
      FactoryBot.factories.map { |factory| factory.name.to_s.to_sym }.each do |factory|
        resources factory, only: [:new, :create], controller: 'resources'
      end
      delete '/', to: 'records#delete'
      get '/status', to: 'records#status'
      get '/remove', to: 'records#remove'
    end
  end
end
