require 'httparty'

class Kele
    include HTTParty
    base_uri 'https://www.bloc.io/api/v1'
    
    def initialize(email, password)
        response = self.class.post('/sessions', body: { email: email, password: password })
        raise "Invalid email or password, try again." if response.code == 401
        @auth_token = response['auth_token']
    end
    
end
