require 'rails_helper'

RSpec.describe Granity::Example, type: :model do
  describe 'validations' do
    it 'requires a name' do
      example = Granity::Example.new(name: nil)
      expect(example.valid?).to be false
      expect(example.errors[:name]).to include("can't be blank")
    end
  end

  describe '#formatted_name' do
    it 'returns the name in uppercase' do
      example = create(:granity_example, name: 'test example')
      expect(example.formatted_name).to eq('TEST EXAMPLE')
    end
  end
end
