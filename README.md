# LocalizeDecimal

A gem for localizing decimal numbers in ActiveModel (and any other ruby class
having attributes accessible with getters and setters).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'localize_decimal'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install localize_decimal


### Configuration

LocalizeDecimal reads the decimal separator from I18n. To make it work you need
at least:

```yml
de:
  number:
    format:
      separator: ","
```

This is included in the standard I18n files rails provides.

If the I18n key is not present, `.` is used as separator.


## Usage


### Localized getters and setters

Include the LocalizeDecimal concern and use `.localize_decimal` to specify
which attributes should be localized. You than can use setters and getters
that are suffixed with `_localized` to read an write localized strings:

```ruby
# == Schema Information
#
# Table name: liquid_payment_core_vats
#
#  id    :integer          not null, primary key
#  name  :string
#  price :decimal(, )
#

class Product < ActiveRecord::Base
  include LocalizeDecimal

  localize_decimal :price
end


product = Product.new(price: 42.6)
product.price_localized        # => "42,6"
product.price_localized = "23,4"
product.price                  # => 23.4
product.price_localized        # => "23,4"
```

To use LocalizeDecimal in a class that does not coerce attributes by itself,
you can use the built in coercion:

```ruby
require "bigdecimal"

class Product
  include LocalizeDecimal

  attr_accessor :name, :price

  localize_decimal :price
end


product = Product.new
product.price_localized = "71,3"
product.price_localized        # => "71,3"
product.price                  # => <BigDecimal:7fef2b154998,'0.713E2',18(18)>
product.price.to_s             # => "71.3"
```


### Validator

The LocalizeDecimal validator can be used as every other ActiveModel
validator.

```ruby
# == Schema Information
#
# Table name: liquid_payment_core_vats
#
#  id    :integer          not null, primary key
#  name  :string
#  price :decimal(, )
#

class Product < ActiveRecord::Base
  include LocalizeDecimal

  localize_decimal :price

  validates :price_localized, localized_decimal: true
end
```

Please note that the validation must be defined for the localized attribute
(`price_localized` in the example above) and not for the attribute itself.

TODO:

  - allow also negative numbers
  - implement other validations supported by numericality validator


## Contributing

1. Fork it ( https://github.com/tilod/localized_decimal/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
