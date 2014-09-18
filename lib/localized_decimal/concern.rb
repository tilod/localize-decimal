module LocalizedDecimal
  module Concern
    extend ActiveSupport::Concern


    private

    def localized_number_separator
      @_localized_number_separator ||=
        I18n.t "number.format.separator", default: "."
    end


    module ClassMethods
      def localize_decimal(*attributes, coerce: false)
        attributes.each do |attribute|
          define_method "#{attribute}_localized" do
            send(attribute).to_s.gsub(".", localized_number_separator)
          end

          if coerce
            define_method "#{attribute}_localized=" do |value|
              localized_value = value.to_s.gsub(localized_number_separator, ".")
              send("#{attribute}=", send(coerce.to_s, localized_value))
            end
          else
            define_method "#{attribute}_localized=" do |value|
              localized_value = value.to_s.gsub(localized_number_separator, ".")
              send("#{attribute}=", localized_value)
            end
          end
        end
      end
    end
  end
end
