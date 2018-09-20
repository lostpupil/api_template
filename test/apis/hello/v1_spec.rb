require_relative '../../test_helper'
scope do
  test "get hello" do
    get "/api/v1/hello"
    assert 200 == last_response.status
  end
end
