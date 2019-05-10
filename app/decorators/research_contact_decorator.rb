class ResearchContactDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def formatted_phone_number
    Phonelib.parse(phone_number).local_number
  end

  def full_source
    case source
    when 'fb'
      "Facebook"
    when 'cl'
      "Craigslist"
    when 'cld'
      "Craigslist Denver"
    when 'clcs'
      "Craigslist Colorado Springs"
    when 'clp'
      "Craigslist Pueblo"
    when 'clws'
      "Craigslist Western Slope"
    when 'organic_google'
      "Google search"
    when 'mt'
      "Mechanical Turk"
    else
      "some ad maybe"
    end
  end

  def name_and_phone
    "#{full_name} #{formatted_phone_number}"
  end

  def marital_status
    eitc_estimate.status == 'joint' ? "Married" : "Single"
  end

  def kids
    amount = eitc_estimate.children == 3 ? "#{eitc_estimate.children}+" : eitc_estimate.children.to_s
    "#{amount} kids"
  end

  def earnings
    "Earned #{number_to_currency(eitc_estimate.income, precision: 0)} in 2018"
  end

  def eligibility_data
    "#{marital_status}, #{kids}, #{earnings}"
  end

  def whether_they_claimed_eitc
    case eitc_estimate.claimed_eitc
    when 'no'
      "Didn't claim EITC"
    when 'unsure'
      "Not sure if they claimed EITC"
    when 'yes'
      "Claimed EITC"
    end
  end

  def filing_situation
    if eitc_estimate.filed_recently == 'no'
      "Hasn't filed this last tax season"
    else
      "Has filed this season #{whether_they_claimed_eitc}"
    end
  end

  def refund_estimate
    "Estimated refund: #{number_to_currency(eitc_estimate.refund, precision: 0)}"
  end

  def interview_link
    "Interview scheduling link: #{interview_scheduling_url}"
  end

  def summary
    rows = [email]
    if eitc_estimate
      rows += [eligibility_data, filing_situation, refund_estimate, interview_link]
    end
    rows.compact.join("\n")
  end
end