require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  describe "sanity check" do
    it "is an ActiveRecord model" do
      expect(ApplicationRecord).to be < ActiveRecord::Base
    end
  end
end