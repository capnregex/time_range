require 'rails_helper'

RSpec.fdescribe TimeRange, type: :model do
  let(:now) { Time.zone.now }
  let(:today) { now.to_date }
  let(:yesterday) { now.yesterday }
  let(:tomorrow) { now.tomorrow }
  let(:last_week) { now.advance(weeks: 1) }
  let(:next_week) { now.advance(weeks: -1) }
  let(:last_month) { now.advance(months: 1) }
  let(:next_month) { now.advance(months: -1) }

  let(:older) { create :time_range, starting: last_month, ending: yesterday }
  let(:prev) { create :time_range, starting: last_week, ending: tomorrow }
  let(:this) { create :time_range, starting: yesterday, ending: tomorrow }
  let(:reversed) { build :time_range, starting: tomorrow, ending: yesterday }
  let(:next) { create :time_range, starting: yesterday, ending: next_week }
  let(:future) { create :time_range, starting: tomorrow, ending: next_month }

  describe "factory" do
    it "should make a valid record" do
      expect(this).to be_valid
      binding.pry
    end
    it "should not permit reversed ranges" do
      expect(reversed).not_to be_valid
    end
  end

  describe "overlapping" do
    describe "timestamps" do
    end
  end

end
