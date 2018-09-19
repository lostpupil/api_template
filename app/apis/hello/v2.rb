module Hello
  class Hello::V2 < Grape::API
    version 'v2'

    desc "Return hello world"
    get :hello do
      { msg: "hello world" }
    end
  end
end
