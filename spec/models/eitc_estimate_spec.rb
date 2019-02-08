require 'rails_helper'

RSpec.describe EitcEstimate, type: :model do
  describe "#eligibility_knowable??" do
    context "with everything present" do
      it "returns true" do
        estimate = EitcEstimate.new(status: 'single', children: 2, income: 0)
        expect(estimate.eligibility_knowable?).to eq true
      end
    end

    context "without everything present" do
      it "returns false" do
        estimate = EitcEstimate.new(status: 'joint')
        expect(estimate.eligibility_knowable?).to eq false
      end
    end
  end

  describe "#gap_knowable?" do
    let(:status) { 'joint' }
    let(:children) { 2 }
    let(:income) { 10000 }
    let(:filed_recently) { 'unset' }
    let(:claimed_eitc) { 'unset' }
    let(:estimate) do
      EitcEstimate.new(
          status: status,
          children: children,
          income: income,
          filed_recently: filed_recently,
          claimed_eitc: claimed_eitc
      )
    end

    context "without full eligibility info" do
      let(:income) { nil }
      it "returns false" do
        expect(estimate.gap_knowable?).to eq false
      end
    end

    context "without full filing info" do
      it "returns false" do
        expect(estimate.gap_knowable?).to eq false
      end
    end

    context "when they havent filed recently" do
      let(:filed_recently) { 'no' }
      it "returns true" do
        expect(estimate.gap_knowable?).to eq true
      end
    end

    context "when they answered whether they claimed eitc or not" do
      let(:claimed_eitc) { 'unsure' }
      it "returns true" do
        expect(estimate.gap_knowable?).to eq true
      end
    end
  end

  describe "#in_gap?" do
    let(:status) { 'joint' }
    let(:children) { 2 }
    let(:income) { 10000 }
    let(:filed_recently) { 'unset' }
    let(:claimed_eitc) { 'unset' }
    let(:estimate) do
      EitcEstimate.new(
        status: status,
        children: children,
        income: income,
        filed_recently: filed_recently,
        claimed_eitc: claimed_eitc
      )
    end

    context "without full gap info" do
      it "returns nil" do
        expect(estimate.in_gap?).to eq nil
      end
    end

    context "when they aren't eligible" do
      let(:income) { 0 }
      let(:filed_recently) { 'no' }
      it "returns false" do
        expect(estimate.in_gap?).to eq false
      end
    end

    context "when they are eligible" do
      context "haven't filed recently" do
        let(:filed_recently) { 'no' }
        it "returns true" do
          expect(estimate.in_gap?).to eq true
        end
      end

      context "have filed recently" do
        let(:filed_recently) { 'yes' }
        context "aren't sure if they claimed eitc" do
          let(:claimed_eitc) { 'unsure' }
          it "returns true" do
            expect(estimate.in_gap?).to eq true
          end
        end

        context "didn't claim eitc" do
          let(:claimed_eitc) { 'no' }
          it "returns true" do
            expect(estimate.in_gap?).to eq true
          end
        end

        context "claimed eitc" do
          let(:claimed_eitc) { 'false' }
          it "returns false" do
            expect(estimate.in_gap?).to eq false
          end
        end
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
          filed_recently: 'unknown',
          claimed_eitc: 'unknown',
          in_gap: 'unknown',
        })
      end
    end

    context "with no unknowns" do
      it "returns a formatted hash" do
        estimate = EitcEstimate.new(status: 'single', children: 2, income: 0, filed_recently: 'yes', claimed_eitc: 'unsure')
        expect(estimate.analytics_data).to eq({
            filing_status: 'single',
            children: '2',
            income: 0,
            eligible: 'false',
            refund: 0,
            filed_recently: 'yes',
            claimed_eitc: 'unsure',
            in_gap: 'false'
        })
      end
    end
  end
end
