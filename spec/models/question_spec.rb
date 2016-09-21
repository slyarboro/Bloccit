require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { Question.new(title: "New Question Body", body: "New Question Body", resolve: false) }

  it "responds to title" do
    expect(question).to respond_to(:title)
  end

  it "responds to body" do
    expect(question).to respond_to(:body)
  end

  it "responds to resolved" do
    expect(question).to respond_to(:resolve)
  end
end
