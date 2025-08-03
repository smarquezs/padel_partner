require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "sanity check" do
    it "is a Rails controller" do
      expect(ApplicationController).to be < ActionController::Base
    end
  end
end