require_relative 'spec_helper'

describe 'My Sinatra Application' do
    it 'should allow incoming requests' do
        get '/'
        last_response.should be_ok
    end
end
