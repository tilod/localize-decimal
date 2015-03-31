class LocalizedDecimalValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    number_separator = I18n.t "number.format.separator", default: "."
    value_string     = value.to_s

    unless value_string =~ /\A\-?\d+(?:#{number_separator}\d+)?\Z/
      record.errors.add attribute, (options[:message] || :not_a_number)
      return
    end

    decimal = BigDecimal(value_string.tr(number_separator, "."))

    # equal_to
    #
    option = options[:equal_to]
    if option && decimal != option
      record.errors.add attribute,
                       (options[:message] || :equal_to),
                        count: option
    end

    # greater_than
    #
    option = options[:greater_than]
    if option && decimal <= option
      record.errors.add attribute,
                       (options[:message] || :greater_than),
                        count: option
    end

    # greater_than_or_equal_to
    #
    option = options[:greater_than_or_equal_to]
    if option && decimal < option
      record.errors.add attribute,
                       (options[:message] || :greater_than_or_equal_to),
                        count: option
    end

    # less_than
    #
    option = options[:less_than]
    if option && decimal >= option
      record.errors.add attribute,
                       (options[:message] || :less_than),
                        count: option
    end

    # less_than_or_equal_to
    #
    option = options[:less_than_or_equal_to]
    if option && decimal > option
      record.errors.add attribute,
                       (options[:message] || :less_than_or_equal_to),
                        count: option
    end
  end
end
