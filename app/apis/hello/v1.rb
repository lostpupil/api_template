module Hello
  class Hello::V1 < Grape::API
    version 'v1'

    desc "Return hello world"
    get :hello do
      { msg: "hello world" }
    end
  end
end
