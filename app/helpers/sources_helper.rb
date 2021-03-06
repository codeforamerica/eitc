module SourcesHelper
  SOURCES = {
      "ak" => "Alaska Outreach",
      "fb" => "Facebook",
      "cl" => "Craigslist",
      "cld" => "Craigslist Denver",
      "clcs" => "Craigslist Colorado Springs",
      "clp" => "Craigslist Pueblo",
      "clws" => "Craigslist Western Slope",
      "organic_google" => "Google search",
      "mt" => "Mechanical Turk",
      "gcftext" => "GetCalFresh Survey Outreach",
      "gcf" => "GetCalFresh",
      "cbo" => "Some CBO",
      "thco" => "Tax Help Colorado",
      "uwba" => "United Way Bay Area",
      "4me" => "CalEITC4Me"
  }

  def full_source
    return "Unknown source" unless source.present?
    SOURCES.fetch(source, source)
  end
end