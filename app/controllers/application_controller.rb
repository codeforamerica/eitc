class ApplicationController < ActionController::Base
  before_action :set_visitor_id
  before_action :set_source_in_session
  before_action :track_page_view, only: [:show, :edit, :new]

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

  def set_source_in_session
    if params[:source]
      session[:source] = params[:source]
    elsif params[:s]
      session[:source] = params[:s]
    elsif request.headers.fetch(:referer, "").include?("google.com")
      session[:source] = "organic_google"
    end
  end

  def user_agent
    @user_agent ||= DeviceDetector.new(request.user_agent)
  end

  def track_page_view
    send_mixpanel_event(event_name: 'page_view')
  end

  def send_mixpanel_event(event_name:, data: {})
    major_browser_version = user_agent.full_version.try { |v| v.partition('.').first }
    unless user_agent.bot?
      default_data = {
          source: source,
          referrer: request.referrer,
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
          unique_id: visitor_id,
          event_name: event_name,
          data: default_data.merge(data),
      )
    end
  end
end
