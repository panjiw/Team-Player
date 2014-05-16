# spec/support/auth_helpers.rb
module AuthHelpers
  def authWithUser (user)
    request.headers['X-ACCESS-TOKEN'] = "#{user.find_api_key.access_token}"
  end

  def clearToken
    request.headers['X-ACCESS-TOKEN'] = nil
  end
end


# spec/spec_helper.rb
config.include AuthHelpers, :type => :controller