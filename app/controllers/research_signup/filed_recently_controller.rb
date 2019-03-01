module ResearchSignup
  class FiledRecentlyController < ResearchSignupFormsController
    def current_step
      4
    end

    def next_path
      return research_registration_research_index_path if current_eitc_estimate.filed_recently == 'no'
      super
    end
  end
end
