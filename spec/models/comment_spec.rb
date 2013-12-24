require_relative '../spec_helper'

module Ottoman
    describe 'An instance of', Comment do
        before :each do
            @comment = Comment.new
        end

        it 'should be properly initialized' do
            expect(@comment).to be_a Comment
        end

        context 'always' do
            it 'should return its class name' do
                expect(@comment.get_class_name).to eq 'comment'
            end
        end
    end

    describe 'Class', Comment do
        it 'should return its name' do
            expect(Comment.get_class_name).to eq 'comment'
        end
    end
end
