require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { Question.new(title: "New Question Body", body: "New Question Body", resolve: false) }
  let(:answer) { Answer.new(question: question, body: "New Answer Body") }

  it "responds to body" do
    expect(answer).to respond_to(:body)
  end
end
