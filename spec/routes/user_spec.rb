require_relative '../spec_helper'

module Ottoman
    describe 'User Routes', UserRoutes do
        before :all do
            @client_id = 'aad56796-c3e0-4b2e-b130-a4f23e117049' # REscour client_id
        end

        # describe 'get all route' do
        #     before :all do
        #         get '/users/'
        #     end
        #     let(:users) { json_parse(last_response.body) }

        #     it 'should return a 200 status code' do
        #         last_response.should be_ok
        #     end

        #     it 'should return an array' do
        #         expect(users).to be_a Array
        #     end

        #     it 'should return the users in the correct format' do
        #         users.each do |user|
        #             user[:id].should_not be_nil
        #             user[:client_id].should_not be_nil
        #             user[:email].should_not be_nil
        #             user[:first_name].should_not be_nil
        #             user[:last_name].should_not be_nil
        #             user[:phone].should_not be_nil
        #         end
        #     end
        # end

        # describe 'edit myself route' do
        #     before :all do
        #         @user_id = '3701b231-9848-4f0d-82ad-0cf8f0a0133e'
        #         route = '/users/'
        #         body = {
        #             :client_id => @client_id,
        #             :email => 'test@rescour.com',
        #             :first_name => 'craig',
        #             :last_name => 'fag',
        #             :phone => '000-000-0000'
        #         }.to_json

        #         put route, body, { 'Content-Type' => 'application/json' }
        #     end
        #     let(:message) { json_parse(last_response.body) }

        #     it 'should return a 200 status code' do
        #         last_response.should be_ok
        #     end

        #     it 'should return a successful message' do
        #         expect(message).to be_a Hash
        #         expect(message[:message]).to eq 'success'
        #     end
        # end

        # describe 'edit route' do
        #     before :all do
        #         @user_id = 'c6443626-a3f6-4b89-b285-7b65f2db472f'
        #         route = '/users/' + @user_id
        #         body = {
        #             :client_id => @client_id,
        #             :email => 'spencer@rescour.com',
        #             :first_name => 'spencerA',
        #             :last_name => 'applegate',
        #             :phone => '205-482-8758'
        #         }.to_json

        #         put route, body, { 'Content-Type' => 'application/json' }
        #     end
        #     let(:message) { json_parse(last_response.body) }

        #     it 'should return a 200 status code' do
        #         last_response.should be_ok
        #     end

        #     it 'should return a successful message' do
        #         expect(message).to be_a Hash
        #         expect(message[:message]).to eq 'success'
        #     end
        # end

        # describe 'edit roles route' do
        #     before :all do
        #         @user_id = 'c6443626-a3f6-4b89-b285-7b65f2db472f'
        #         route = '/users/' + @user_id + '/roles/'
        #         body = {
        #             :roles => ['admin', 'verified']
        #         }.to_json

        #         put route, body, { 'Content-Type' => 'application/json' }
        #     end
        #     let(:message) { json_parse(last_response.body) }

        #     it 'should return a 200 status code' do
        #         last_response.should be_ok
        #     end

        #     it 'should return a successful message' do
        #         expect(message).to be_a Hash
        #         expect(message[:message]).to eq 'success'
        #     end

        #     it 'should return it to the way it was successfully' do
        #         delete_route = '/users/' + @user_id + '/roles/'
        #         delete_body = {
        #             :roles => ['verified']
        #         }.to_json

        #         put delete_route, delete_body, { 'Content-Type' => 'application/json' }
        #         message = json_parse(last_response.body)

        #         last_response.should be_ok

        #         expect(message).to be_a Hash
        #         expect(message[:message]).to eq 'success'
        #     end
        # end

        # context 'user signup' do
        #     describe 'without a client routes' do
        #         before :all do
        #             ENV['OTTOMAN_AUTH_GROUP'] = '-1' # pass in this route
        #             route = '/users/'
        #             body = {
        #                 :email => 'morgan@rescour.com',
        #                 :password => 'morgan',
        #                 :first_name => 'morgan',
        #                 :last_name => 'spartz',
        #                 :phone => '000-000-0000'
        #             }.to_json

        #             post route, body, { 'Content-Type' => 'application/json' }
        #         end
        #         let(:id) { json_parse(last_response.body) }

        #         it 'should return a 200 status code' do
        #             last_response.should be_ok
        #         end

        #         it 'should return an id in a hash' do
        #             expect(id).to be_a Hash
        #             id[:id].should_not be_nil
        #         end

        #         it 'should delete the user successfully afterwards' do
        #             ENV['OTTOMAN_AUTH_GROUP'] = '0' # staff for this route
        #             route = '/users/' + id[:id]
        #             delete route

        #             message = json_parse(last_response.body)

        #             last_response.should be_ok

        #             expect(message).to be_a Hash
        #             expect(message[:message]).to eq 'success'
        #         end
        #     end

        #     describe 'with a client routes' do
        #         before :all do
        #             ENV['OTTOMAN_AUTH_GROUP'] = '0' # admin in this case
        #             route = '/users/'
        #             body = {
        #                 :email => 'morgan@rescour.com',
        #                 :password => 'morgan',
        #                 :first_name => 'morgan',
        #                 :last_name => 'spartz',
        #                 :phone => '000-000-0000'
        #             }.to_json

        #             post route, body, { 'Content-Type' => 'application/json' }
        #         end
        #         let(:id) { json_parse(last_response.body) }

        #         it 'should return a 200 status code' do
        #             last_response.should be_ok
        #         end

        #         it 'should return an id in a hash' do
        #             expect(id).to be_a Hash
        #             id[:id].should_not be_nil
        #         end

        #         it 'should delete the user successfully afterwards' do
        #             ENV['OTTOMAN_AUTH_GROUP'] = '0' # staff for this route
        #             route = '/users/' + id[:id]
        #             delete route

        #             message = json_parse(last_response.body)

        #             last_response.should be_ok

        #             expect(message).to be_a Hash
        #             expect(message[:message]).to eq 'success'
        #         end
        #     end
        # end

        # describe 'reset password route' do
        #     before :all do
        #         route = '/user/password/reset/'
        #         body = {
        #             :newPassword => 'helloworld',
        #             :token => 'e0d70986e0377f9f0b2a4502d2c33d53'
        #         }.to_json

        #         post route, body, { 'Content-Type' => 'application/json' }
        #     end
        #     let(:message) { json_parse(last_response.body) }

        #     it 'should return a 200 status code' do
        #         last_response.should be_ok
        #     end

        #     it 'should return a succesful message' do
        #         expect(message).to be_a Hash
        #         expect(message[:message]).to eq 'success'
        #     end
        # end

        # context 'changing password routes' do
        #     describe 'as yourself' do
        #         before :all do
        #             route = '/users/password/'
        #             body = {
        #                 :oldPassword => 'helloworld',
        #                 :newPassword => 'test'
        #             }.to_json

        #             put route, body, { 'Content-Type' => 'application/json' }
        #         end
        #         let(:message) { json_parse(last_response.body) }

        #         it 'should return a 200 status code' do
        #             last_response.should be_ok
        #         end

        #         it 'should return a successful message' do
        #             expect(message).to be_a Hash
        #             expect(message[:message]).to eq 'success'
        #         end
        #     end

        #     describe 'for someone else' do
        #         before :all do
        #             @user_id = 'c6443626-a3f6-4b89-b285-7b65f2db472f'
        #             route = '/users/' + @user_id + '/password/'
        #             body = {
        #                 :newPassword => 'helloworld'
        #             }.to_json

        #             put route, body, { 'Content-Type' => 'application/json' }
        #         end
        #         let(:message) { json_parse(last_reponse.body) }

        #         it 'should return a 200 status code' do
        #             last_response.should be_ok
        #         end

        #         it 'should return a successful message' do
        #             expect(message).to be_a Hash
        #             expect(message[:message]).to eq 'success'
        #         end
        #     end
        # end
    end
end
