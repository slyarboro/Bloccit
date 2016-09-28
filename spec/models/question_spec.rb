require 'rails_helper'

RSpec.describe Question, type: :model do

  context "attributes" do
    let(:question) { Question.create!(title: "Quest-ion Title", body: "Quest-atom Body", resolved: false) }

    it "responds to title" do
      expect(question).to respond_to(:title)
    end

    it "responds to body" do
      expect(question).to respond_to(:body)
    end

    it "responds to resolved" do
      expect(question).to respond_to(:resolved)
    end

  end
end
