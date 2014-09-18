require 'spec_helper'

RSpec.describe LocalizedDecimalValidator do
  let(:model) { TestClass.new }

  context 'with I18n configured' do
    before { allow(I18n)
               .to receive(:t)
               .with("number.format.separator", default: ".")
               .and_return "," }

    it 'allows numbers without separator' do
      model.test_decimal_localized = "12"
      expect(model).to be_valid
    end

    it 'allows numbers with correct separator' do
      model.test_decimal_localized = "11,4"
      expect(model).to be_valid
    end

    it 'does not allow numbers with the wrong separator' do
      model.test_decimal_localized = "43-0"
      expect(model).not_to be_valid
      expect(model.errors[:test_decimal_localized].size).to eq 1
    end

    it 'allows . as separator too (this is not intentional, but preventing '\
       'this would bloat the setter method)' do
      model.test_decimal_localized = "0.75"
      expect(model).to be_valid
    end

    it 'does not allow numbers with multiple separators (can these still be '\
       'called "numbers" anyway?)' do
      model.test_decimal_localized = "98,2,7"
      expect(model).not_to be_valid
      expect(model.errors[:test_decimal_localized].size).to eq 1
    end
  end


  context 'without I18n configured' do
    it 'uses . as separator' do
      model.test_decimal_localized = "389.01"
      expect(model).to be_valid
    end
  end
end
