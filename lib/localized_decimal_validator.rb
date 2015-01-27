class LocalizedDecimalValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    number_separator = I18n.t "number.format.separator", default: "."

    unless value =~ /\A\d+(?:#{number_separator}\d+)?\Z/
      record.errors[attribute] << (options[:message] ||
                                   generate_error_message(record, attribute))
    end
  end


  private

  def generate_error_message(record, attribute)
    record.errors.generate_message(attribute, :not_a_number)
  end
end
