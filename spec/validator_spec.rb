require 'spec_helper'

RSpec.describe LocalizedDecimalValidator do
  let(:model) { TestClass.new }

  context 'with translations' do
    before { I18n.locale = :de }

    it 'allows numbers without separator as string' do
      model.test_decimal_localized = "12"
      expect(model).to be_valid
    end

    it 'allows number without separator as integer' do
      model.test_decimal_localized = 8
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

    it 'allows numbers with separators as float' do
      model.test_decimal_localized = 56.0
      expect(model).to be_valid
    end

    it 'does not allow numbers with multiple separators (can these still be '\
       'called "numbers" anyway?)' do
      model.test_decimal_localized = "98,2,7"
      expect(model).not_to be_valid
      expect(model.errors[:test_decimal_localized].size).to eq 1
    end

    it 'has a translated error message' do
      model.test_decimal_localized = "wrong"
      expect(model).not_to be_valid
      expect(model.errors[:test_decimal_localized])
      .to eq ["not a number error message"]
    end

    shared_examples_for :being_valid do
      it 'is valid' do
        expect(model).to be_valid
      end
    end

    shared_examples_for :having_an_error_on_the_field do
      it 'is not valid' do
        expect(model).not_to be_valid
        expect(model.errors[:test_attribute].size).to eq 1
      end

      it 'includes the options value in the error message' do
        expect(model).not_to be_valid
        expect(model.errors[:test_attribute].first).to match "3"
      end
    end

    describe 'supports the :equal_to option' do
      class TestEqualTo
        include ActiveModel::Model

        attr_accessor :test_attribute
        validates :test_attribute, localized_decimal: { equal_to: 3 }
      end

      let(:model) { TestEqualTo.new }

      context 'when value equals the option' do
        before { model.test_attribute = "3" }
        it_behaves_like :being_valid
      end

      context 'when value does not equal the option' do
        before { model.test_attribute = "4,1" }
        it_behaves_like :having_an_error_on_the_field
      end
    end

    describe 'supports the :greater_than option' do
      class TestGreaterThan
        include ActiveModel::Model

        attr_accessor :test_attribute
        validates :test_attribute, localized_decimal: { greater_than: 3 }
      end

      let(:model) { TestGreaterThan.new }

      context 'when value equals the option' do
        before { model.test_attribute = "3" }
        it_behaves_like :having_an_error_on_the_field
      end

      context 'when value is less than the option' do
        before { model.test_attribute = "2,6" }
        it_behaves_like :having_an_error_on_the_field
      end

      context 'when value is greater than the option' do
        before { model.test_attribute = "4,1" }
        it_behaves_like :being_valid
      end
    end

    describe 'supports the :greater_than_or_equal_to option' do
      class TestGreaterThanOrEqualTo
        include ActiveModel::Model

        attr_accessor :test_attribute
        validates :test_attribute, localized_decimal: { greater_than_or_equal_to: 3 }
      end

      let(:model) { TestGreaterThanOrEqualTo.new }

      context 'when value equals the option' do
        before { model.test_attribute = "3" }
        it_behaves_like :being_valid
      end

      context 'when value is less than the option' do
        before { model.test_attribute = "2,6" }
        it_behaves_like :having_an_error_on_the_field
      end

      context 'when value is greater than the option' do
        before { model.test_attribute = "4,1" }
        it_behaves_like :being_valid
      end
    end

    describe 'supports the :less_than option' do
      class TestLessThan
        include ActiveModel::Model

        attr_accessor :test_attribute
        validates :test_attribute, localized_decimal: { less_than: 3 }
      end

      let(:model) { TestLessThan.new }

      context 'when value equals the option' do
        before { model.test_attribute = "3" }
        it_behaves_like :having_an_error_on_the_field
      end

      context 'when value is less than the option' do
        before { model.test_attribute = "2,6" }
        it_behaves_like :being_valid
      end

      context 'when value is greater than the option' do
        before { model.test_attribute = "4,1" }
        it_behaves_like :having_an_error_on_the_field
      end
    end

    describe 'supports the :less_than_or_equal_to option' do
      class TestLessThanOrEqualTo
        include ActiveModel::Model

        attr_accessor :test_attribute
        validates :test_attribute, localized_decimal: { less_than_or_equal_to: 3 }
      end

      let(:model) { TestLessThanOrEqualTo.new }

      context 'when value equals the option' do
        before { model.test_attribute = "3" }
        it_behaves_like :being_valid
      end

      context 'when value is less than the option' do
        before { model.test_attribute = "2,6" }
        it_behaves_like :being_valid
      end

      context 'when value is greater than the option' do
        before { model.test_attribute = "4,1" }
        it_behaves_like :having_an_error_on_the_field
      end
    end
  end

  context 'without translations' do
    before { I18n.locale = :en }

    it 'uses . as separator' do
      model.test_decimal_localized = "389.01"
      expect(model).to be_valid
    end
  end
end
