require 'spec_helper'

RSpec.describe LocalizedDecimalValidator do
  let(:model) { TestClass.new }

  context 'with I18n configured' do
    before { allow(I18n).to receive(:t)
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

    it 'allows negative numbers' do
      model.test_decimal_localized = "-91,7"
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

    it 'has a translated error message' do
      # TODO Is there a better way to stub this? That's awful...
      allow(I18n).to receive(:translate)
                 .with(:test_class, {:scope=>[:activemodel, :models], :count=>1, :default=>["Test class"]})
                 .and_call_original
      allow(I18n).to receive(:translate)
                 .with(any_args)
                 .and_return("test error message")

      model.test_decimal_localized = "wrong"
      expect(model).not_to be_valid
      expect(model.errors[:test_decimal_localized]).to eq ["test error message"]
    end
  end


  context 'without I18n configured' do
    it 'uses . as separator' do
      model.test_decimal_localized = "389.01"
      expect(model).to be_valid
    end

    describe 'the error message' do
      it 'is :not_a_number' do
        model.test_decimal_localized = "wrong"
        expect(model).not_to be_valid
        expect(model.errors[:test_decimal_localized]).to eq ["is not a number"]
      end
    end
  end
end
