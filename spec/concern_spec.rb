require 'spec_helper'

module LocalizeDecimal
  RSpec.describe Concern do
    let(:model) { TestClass.new(test_decimal: 14.2) }


    context 'with I18n configured' do
      before { allow(I18n)
                 .to receive(:t)
                 .with("number.format.separator", default: ".")
                 .and_return "," }

      describe '.localize_decimal' do
        it 'generates a localized getter for the attribute' do
          expect(model).to respond_to :test_decimal_localized
          expect(model).to respond_to :test_decimal_2_localized
          expect(model).to respond_to :test_coerce_float_localized
          expect(model).to respond_to :test_coerce_big_decimal_localized
        end

        it 'generates a localized setter for the attribute' do
          expect(model).to respond_to :test_decimal_localized=
          expect(model).to respond_to :test_decimal_2_localized=
          expect(model).to respond_to :test_coerce_float_localized=
          expect(model).to respond_to :test_coerce_big_decimal_localized=
        end

        it 'leaves the original getters and setters unchanged' do
          expect(model.test_decimal).to eq 14.2
          model.test_decimal = 23.5
          expect(model.test_decimal).to eq 23.5
        end
      end


      describe '#[attribute]_localized' do
        it 'returns the attribute as string using the separator set in I18n' do
          expect(model.test_decimal_localized).to eq "14,2"
        end
      end


      context 'when coercion is not used' do
        describe '#[attribute]_localized=' do
          it 'parses the string and sets the attribute value' do
            model.test_decimal_localized = "83,7"
            expect(model.test_decimal).to eq "83.7"
          end
        end
      end


      context 'when coercion is used' do
        describe '#[attribute]_localized=' do
          it 'parses the string and sets the attribute value' do
            model.test_coerce_float_localized = "54,9"
            expect(model.test_coerce_float).to be_a Float
            expect(model.test_coerce_float).to eq 54.9

            model.test_coerce_big_decimal_localized = "102,6"
            expect(model.test_coerce_big_decimal).to be_a BigDecimal
            expect(model.test_coerce_big_decimal).to eq BigDecimal("102.6")
          end
        end
      end


      context 'without I18n configured' do
        it 'uses . as separator' do
          model.test_decimal_localized = "72.8"
          expect(model.test_decimal).to eq "72.8"
        end
      end
    end
  end
end
