require 'rails_helper'

RSpec.describe EitcEstimate, type: :model do
  describe "#complete?" do
    context "with everything present" do
      it "returns true" do
        estimate = EitcEstimate.new(status: 'single', children: 2, income: 0)
        expect(estimate.complete?).to eq true
      end
    end

    context "without everything present" do
      it "returns false" do
        estimate = EitcEstimate.new(status: 'joint')
        expect(estimate.complete?).to eq false
      end
    end
  end

  describe "#analytics_data" do
    context "with all unknowns" do
      it "returns appropriate nil or unknown strings" do
        estimate = EitcEstimate.new
        expect(estimate.analytics_data).to eq({
          filing_status: nil,
          children: 'unknown',
          income: nil,
          eligible: 'unknown',
          refund: nil,
        })
      end
    end

    context "with no unknowns" do
      it "returns a formatted hash" do
        estimate = EitcEstimate.new(status: 'single', children: 2, income: 0)
        expect(estimate.analytics_data).to eq({
            filing_status: 'single',
            children: '2',
            income: 0,
            eligible: 'false',
            refund: 0,
        })
      end
    end
  end
end
