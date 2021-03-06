require 'spec_helper'

describe 'Factory routing' do
  HANGAR_HEADERS = {
    'HTTP_ACCEPT' => 'application/json',
    'HTTP_FACTORY' => 'hangar'
  }

  before do
    expect(Rack::MockRequest).to receive(:env_for).and_wrap_original do |original_method, *args, &block|
      original_method.call(*args, &block).dup.tap { |hash| hash.merge! HANGAR_HEADERS }
    end
  end

  context 'when route does not have a namespace' do
    it 'provides #create route' do
      expect(post: '/posts').to route_to('hangar/resources#create')
    end

    it 'provides #new route' do
      expect(get: '/posts/new').to route_to('hangar/resources#new')
    end

    it 'provides global #delete route' do
      expect(delete: '/').to route_to('hangar/records#delete')
    end
  end

  context 'when route has a namespace' do
    before do
      Hangar.route_namespace = :factories
      Rails.application.reload_routes!
    end

    after do
      Hangar.route_namespace = nil
      Rails.application.reload_routes!
    end

    it 'provides namspaced #create route' do
      expect(post: '/factories/posts').to route_to('hangar/resources#create')
    end

    it 'provides namspaced #new route' do
      expect(get: '/factories/posts/new').to route_to('hangar/resources#new')
    end

    it 'provides global namspaced #delete route' do
      expect(delete: '/factories').to route_to('hangar/records#delete')
    end
  end
end