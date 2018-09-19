module Hello
  class Hello::V1 < Grape::API
    version 'v1'

    helpers SharedParams

    desc "Return hello world"
    get :hello do
      { msg: "hello world" }
    end

    desc "Get hello world list"
    params do
      use :pagination
    end
    get :hello_list do
      { msg: "hello world", list: [*100..110]}
    end
  end
end
