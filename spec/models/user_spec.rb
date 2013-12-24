require_relative '../spec_helper'

module Ottoman
    describe 'An instance of', User do
        before :each do
            @user = User.new
        end

        it 'should be properly initialized' do
            expect(@user).to be_a User
        end

        context 'always' do
            it 'should return its class name' do
                expect(@user.get_class_name).to eq 'user'
            end
        end
    end

    describe 'Class', User do
        it 'should return its name' do
            expect(User.get_class_name).to eq 'user'
        end
    end
end
