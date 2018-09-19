Cuba.use Rack::Cors do
  allow do
    origins '*'
    resource '/*', :headers => :any, :methods => [:get,:post,:delete,:put]
  end
end

class API < Grape::API
  format :json

  mount ::Hello::V1
  mount ::Hello::V2

  add_swagger_documentation
end

Cuba.define do
  on 'api' do
    run API
  end
end
