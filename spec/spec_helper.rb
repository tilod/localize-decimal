require 'localize_decimal'

require 'bigdecimal'
require 'pry'

I18n.load_path = Dir['spec/translations.yml']
I18n.backend.load_translations

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

#  config.profile_examples = 10

  config.order = :random
  Kernel.srand config.seed
end


class TestClass
  include ActiveModel::Model
  include LocalizeDecimal::Concern

  attr_accessor :test_decimal, :test_decimal_2,
                :test_coerce_float, :test_coerce_big_decimal,
                :test_custom_coerce

  localize_decimal :test_decimal, :test_decimal_2
  localize_decimal :test_coerce_float, coerce: :Float
  localize_decimal :test_coerce_big_decimal, coerce: :BigDecimal
  localize_decimal :test_custom_coerce, coerce: :reverse_value

  validates :test_decimal_localized, localized_decimal: true

  def reverse_value(value)
    value.reverse
  end
end
