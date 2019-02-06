class RedirectsController < ApplicationController
  def my_free_taxes
    send_mixpanel_event(
      event_name: 'follow_link',
      data: {
          link_name: 'MyFreeTaxes.com',
          link: 'https://www.myfreetaxes.com/'
      })
    redirect_to 'https://www.myfreetaxes.com/'
  end

  def get_ahead_colorado_locations
    send_mixpanel_event(
        event_name: 'follow_link',
        data: {
            link_name: 'GetAheadColorado.org',
            link:'https://www.garycommunity.org/tax-help#gci-tax-app-filter-form'
        })
    redirect_to 'https://www.garycommunity.org/tax-help#gci-tax-app-filter-form'
  end
end