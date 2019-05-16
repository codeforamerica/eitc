# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += [
    :password, :last_four_ssn, :last_four_ssn_spouse,
    :email, :phone_number, :non_citizen, :disabled, :legally_blind,
    :full_time_student, :birthdate, :birthdate_year, :birthdate_month,
    :birthdate_day, :first_name, :last_name, :street_address, :zip, :city,
    :signature, :spouse_signature, :anything_else
]
