require 'feature_flag'

RSpec.describe 'FeatureFlag' do
    let(:feature_name) { 'feature_name' }
    let(:user) { { id: 1234 } }
    let(:feature_flag) { FeatureFlag.new }

    describe 'on/off' do
        it 'disables a feature by default' do
            expect(feature_flag.is_feature_active(feature_name, user)).to eq(false)
        end

        describe 'when activating a feature' do
            before do
              feature_flag.activate_feature(feature_name)
            end

            it 'activates that feature' do
                expect(feature_flag.is_feature_active(feature_name, user)).to eq(true)
            end
        end

        describe 'when deactivating a feature' do
            before do
                feature_flag.activate_feature(feature_name)
                feature_flag.deactivate_feature(feature_name)
            end

            it 'deactivates that feature' do
                expect(feature_flag.is_feature_active(feature_name, user)).to eq(false)
            end
        end
    end

    describe 'percentages' do
        # maybe do this in a for loop?
        # I suspect that the sample size isn't big enough
        let(:user1) { { id: 1 } }
        let(:user2) { { id: 2 } }

        it 'works' do
            feature_flag.activate_feature_percentage(feature_name, 0.5)            

            result1 = feature_flag.is_feature_active(feature_name, user1)
            result2 = feature_flag.is_feature_active(feature_name, user2)
            results = [result1, result2]

            true_results = results.filter { |e| e == true }
            false_results = results.filter { |e| e == false }

            expect(true_results.size).to eq(1)
            expect(false_results.size).to eq(1)
        end
    end
end