require_relative '../spec_helper'

module Ottoman
    describe 'Comment Routes', CommentRoutes do
        before :all do
            @mdu_id = '39ccd163-dd48-4d3c-abc8-071a6080316e'
        end

        # describe 'getting all comments for an mdu' do
        #     before :all do
        #         get '/mdus/' + @mdu_id + '/comments/'
        #     end
        #     let(:comments) { json_parse(last_response.body) }

        #     it 'should be successful' do
        #         last_response.should be_ok
        #     end

        #     it 'should be an array' do
        #         expect(comments).to be_a Array
        #     end

        #     it 'should contain the correct root elements' do
        #         comments.each do |comment|
        #             comment[:id].should_not be_nil
        #             comment[:user_id].should_not be_nil
        #             comment[:text].should_not be_nil
        #         end if comments
        #     end
        # end

        # describe 'should create a comment for an mdu' do
        #     before :all do
        #         route = '/mdus/' + @mdu_id + '/comments/'
        #         body = {
        #             :text => 'Craig is super gay'
        #         }.to_json

        #         post route, body, { 'Content-Type' => 'application/json' }
        #     end
        #     let(:id) { json_parse(last_response.body) }

        #     it 'should be successful' do
        #         last_response.should be_ok
        #     end

        #     it 'should return an id' do
        #         expect(id).to be_a Hash
        #         id[:id].should_not be_nil
        #     end

        #     it 'should be deleted successfuly' do
        #         delete_route = '/mdus/' + @mdu_id + '/comments/' + id[:id]
        #         delete delete_route
        #         message = json_parse(last_response.body)

        #         last_response.should be_ok

        #         expect(message).to be_a Hash
        #         expect(message[:message]).to eq 'success'
        #     end
        # end

        # describe 'should edit a comment for an mdu' do
        #     before :all do
        #         @comment_id = '95f7218c-ff22-4d33-b5a5-defb7ac56514'
        #         route = '/mdus/' + @mdu_id + '/comments/' + @comment_id
        #         body = {
        #             :text => 'WHATEVER'
        #         }.to_json

        #         put route, body, { 'Content-Type' => 'application/json' }
        #     end
        #     let(:message) { json_parse(last_response.body) }

        #     it 'should be successful' do
        #         last_response.should be_ok
        #     end

        #     it 'should return a successful message' do
        #         expect(message).to be_a Hash
        #         expect(message[:message]).to eq 'success'
        #     end
        # end

        # describe 'should get a single comment for an mdu' do
        #     before :all do
        #         @comment_id = '95f7218c-ff22-4d33-b5a5-defb7ac56514'
        #         route = '/mdus/' + @mdu_id + '/comments/' + @comment_id

        #         get route
        #     end
        #     let(:comment) { json_parse(last_response.body) }

        #     it 'should be successful' do
        #         last_response.should be_ok
        #     end

        #     it 'should return a hash' do
        #         expect(comment).to be_a Hash
        #     end

        #     it 'should contain all the correct root elements' do
        #         comment[:id].should_not be_nil
        #         comment[:user_id].should_not be_nil
        #         comment[:text].should_not be_nil
        #     end
        # end
    end
end
