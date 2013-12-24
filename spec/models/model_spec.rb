require_relative '../spec_helper'

module Ottoman
    describe 'An instance of', Model do
        before :each do
            @model = Model.new
        end

        it 'should be properly initialized' do
            expect(@model).to be_a Model
        end

        context 'always' do
            it 'should return its class name' do
                expect(@model.get_class_name).to eq 'model'
            end
        end
    end

    describe 'Class', Model do
        it 'should return its name' do
            expect(Ottoman::Model.get_class_name).to eq 'model'
        end
    end
end
