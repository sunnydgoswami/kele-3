require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
    include HTTParty
    include Roadmap
    base_uri 'https://www.bloc.io/api/v1'
    
    def initialize(email, password)
        response = self.class.post('/sessions', body: { "email": email, "password": password })
        raise "Invalid email or password, try again." if response.code == 401
        @auth_token = response['auth_token']
    end
    
    def get_me
        response = self.class.get('/users/me', headers: { 'authorization' => @auth_token })
        JSON.parse(response.body)
    end
    
    def get_mentor_availability(mentor_id)
        response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { 'authorization' => @auth_token })
        JSON.parse(response.body)
    end
    
    def get_messages(page = nil)
        response = self.class.get("/message_threads", body: {"page": page}, headers: {"authorization" => @auth_token})
        JSON.parse(response.body)
    end
    
    def create_message(sender, recipient_id, subject, text)
        response = self.class.post("/messages", body: {"sender": @email, "recipient_id": recipient_id, "subject": subject, "stripped-text": text}, headers: {authorization: @auth_token})
        JSON.parse(response.body)
    end    
    
    def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
        response = self.class.post("/checkpoint_submissions", 
            values: {
                "checkpoint_id": checkpoint_id, 
                "assignment_branch": assignment_branch, 
                "assignment_commit_link": assignment_commit_link, 
                "comment": comment
            }, 
            headers: {authorization: @auth_token})
        puts response
    end    
    
end
