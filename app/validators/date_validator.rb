class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    if !date_present?(record, attribute)
      record.errors[attribute] <<
          missing_date_error(record, attribute)
    elsif !valid_date?(record, attribute)
      record.errors[attribute] << "Please provide a real date."
    end
  end

  private

  def date_present?(record, field)
    ["#{field}_year".to_sym, "#{field}_month".to_sym, "#{field}_day".to_sym].all? { |att| record.send(att).present? }
  end

  def valid_date?(record, field)
    DateTime.new(
        record.send("#{field}_year".to_sym).to_i,
        record.send("#{field}_month".to_sym).to_i,
        record.send("#{field}_day".to_sym).to_i,
        )
    true
  rescue ArgumentError
    false
  end

  def missing_date_error(record, field_base)
    field_to_message = {
        "#{field_base}_month": "a month",
        "#{field_base}_day": "a day",
        "#{field_base}_year": "a year",
    }
    missing_fields = field_to_message.reject { |field, _| record.send(field).present? }
    "Please add #{missing_fields.values.to_sentence}."
  end
end
