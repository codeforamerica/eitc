module StatesHelper
  STATES_AND_TIMEZONES = {
      'Alabama' => 'Mountain Time (US & Canada)',
      'Alaska' => 'Mountain Time (US & Canada)',
      'Arizona' => 'Mountain Time (US & Canada)',
      'Arkansas' => 'Mountain Time (US & Canada)',
      'California' => 'Pacific Time (US & Canada)',
      'Colorado' => 'Mountain Time (US & Canada)',
      'Connecticut' => 'Mountain Time (US & Canada)',
      'Delaware' => 'Mountain Time (US & Canada)',
      'Florida' => 'Mountain Time (US & Canada)',
      'Georgia' => 'Mountain Time (US & Canada)',
      'Hawaii' => 'Mountain Time (US & Canada)',
      'Idaho' => 'Mountain Time (US & Canada)',
      'Illinois' => 'Mountain Time (US & Canada)',
      'Indiana' => 'Mountain Time (US & Canada)',
      'Iowa' => 'Mountain Time (US & Canada)',
      'Kansas' => 'Mountain Time (US & Canada)',
      'Kentucky' => 'Mountain Time (US & Canada)',
      'Louisiana' => 'Mountain Time (US & Canada)',
      'Maine' => 'Mountain Time (US & Canada)',
      'Maryland' => 'Mountain Time (US & Canada)',
      'Massachusetts' => 'Mountain Time (US & Canada)',
      'Michigan' => 'Mountain Time (US & Canada)',
      'Minnesota' => 'Mountain Time (US & Canada)',
      'Mississippi' => 'Mountain Time (US & Canada)',
      'Missouri' => 'Mountain Time (US & Canada)',
      'Montana' => 'Mountain Time (US & Canada)',
      'Nebraska' => 'Mountain Time (US & Canada)',
      'Nevada' => 'Mountain Time (US & Canada)',
      'New Hampshire' => 'Mountain Time (US & Canada)',
      'New Jersey' => 'Eastern Time (US & Canada)',
      'New Mexico' => 'Mountain Time (US & Canada)',
      'New York' => 'Mountain Time (US & Canada)',
      'North Carolina' => 'Mountain Time (US & Canada)',
      'North Dakota' => 'Mountain Time (US & Canada)',
      'Ohio' => 'Mountain Time (US & Canada)',
      'Oklahoma' => 'Mountain Time (US & Canada)',
      'Oregon' => 'Mountain Time (US & Canada)',
      'Pennsylvania' => 'Mountain Time (US & Canada)',
      'Rhode Island' => 'Mountain Time (US & Canada)',
      'South Carolina' => 'Mountain Time (US & Canada)',
      'South Dakota' => 'Mountain Time (US & Canada)',
      'Tennessee' => 'Mountain Time (US & Canada)',
      'Texas' => 'Mountain Time (US & Canada)',
      'Utah' => 'Mountain Time (US & Canada)',
      'Vermont' => 'Mountain Time (US & Canada)',
      'Virginia' => 'Mountain Time (US & Canada)',
      'Washington' => 'Mountain Time (US & Canada)',
      'West Virginia' => 'Mountain Time (US & Canada)',
      'Wisconsin' => 'Mountain Time (US & Canada)',
      'Wyoming' => 'Mountain Time (US & Canada)',
  }

  def state_choices
    STATES_AND_TIMEZONES.keys
  end

  def timezone_for_state(state)
    STATES_AND_TIMEZONES[state]
  end
end