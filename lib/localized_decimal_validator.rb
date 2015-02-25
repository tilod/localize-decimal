class LocalizedDecimalValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    number_separator = I18n.t "number.format.separator", default: "."

    unless value =~ /\A\-?\d+(?:#{number_separator}\d+)?\Z/
      record.errors.add attribute, (options[:message] || :not_a_number)
    end
  end
end
