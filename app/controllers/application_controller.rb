class ApplicationController < ActionController::Base
  before_action :set_visitor_id
  before_action :set_params_in_session
  before_action :track_page_view, except: [:update, :create, :destroy]

  def ad_name(ad_id)
    {
      'a0' => "You may be losing money for you and your family.",
      'a1' => "Moms — get your money back!",
      'a2' => "It's your money, get it back",
      'a3' => "You earned it, now get your money back",
      'a4' => "Does the government owe you money?",
      'a5' => "It's your money — get it back!",
      'a6' => "Are you leaving money on the table?",
      'a7' => "Leaving thousands of dollars on the table?",
      'a8' => "Not filing taxes? You may be missing out on cash.",
      'a9' => "Does the government owe you money?",
      'a10' => "Losing money?",
      'a11' => "Get back the cash you earned — now",
      'a12' => "It's your money — get it back!",
      'a13' => "Carousel",
      'a14' => "Leaving money on the table?",
      'a15' => "Are you leaving money on the table? - alt",
      'a16' => "Does the government owe you money?",
      'a17' => "Not filing taxes? You may be missing out on cash.",
    }[ad_id]
  end

  def campaign_name(campaign_id)
    {
      'c0' => "EITC - Susan Conversions",
      'c1' => "EITC - Employee Conversions",
      'c2' => "EITC - David Conversions",
      'c3' => "EITC - Carlos Conversions",
    }[campaign_id]
  end

  def set_visitor_id
    return if session[:visitor_id].present?
    session[:visitor_id] = SecureRandom.hex(26)
  end

  def visitor_id
    session[:visitor_id]
  end

  def source
    session[:source]
  end

  def set_params_in_session
    if params[:source]
      session[:source] = params[:source]
    elsif params[:utm_source]
      session[:source] = params[:utm_source]
    elsif params[:s]
      session[:source] = params[:s]
    elsif request.headers.fetch(:referer, "").include?("google.com")
      session[:source] = "organic_google"
    end

    %w(campaign content).each do |param|
      if params[param]
        session[param] = params[param]
      end
    end
  end

  def user_agent
    @user_agent ||= DeviceDetector.new(request.user_agent)
  end

  def track_page_view
    send_mixpanel_event(event_name: 'page_view')
  end

  def send_mixpanel_event(event_name:, unique_id: nil, data: {})
    major_browser_version = user_agent.full_version.try { |v| v.partition('.').first }
    unless user_agent.bot?
      default_data = {
          source: source,
          referrer: request.referrer,
          ad_campaign_id: session[:campaign],
          ad_campaign_name: campaign_name(session[:campaign]),
          ad_id: session[:content],
          ad_name: ad_name(session[:content]),
          full_user_agent: request.user_agent,
          browser_name: user_agent.name,
          browser_full_version: user_agent.full_version,
          browser_major_version: major_browser_version,
          os_name: user_agent.os_name,
          os_full_version: user_agent.os_full_version,
          os_major_version: user_agent.os_full_version.try { |v| v.partition('.').first },
          is_bot: user_agent.bot?,
          bot_name: user_agent.bot_name,
          device_brand: user_agent.device_brand,
          device_name: user_agent.device_name,
          device_type: user_agent.device_type,
          device_browser_version: "#{user_agent.os_name} #{user_agent.device_type} #{user_agent.name} #{major_browser_version}",
          locale: I18n.locale,
          path: request.path,
          full_path: request.fullpath,
          controller_name: self.class.name.sub("Controller", ""),
          controller_action: "#{self.class.name}##{action_name}",
          controller_action_name: action_name,
      }

      MixpanelService.instance.run(
          unique_id: unique_id || visitor_id,
          event_name: event_name,
          data: default_data.merge(data),
      )
    end
  end
end
