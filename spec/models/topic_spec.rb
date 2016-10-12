require 'rails_helper'

RSpec.describe Topic, type: :model do

  # let(:name) { RandomData.random_sentence }
  # let(:description) { RandomData.random_paragraph }
  # let(:public) { true }
  # let(:topic) { Topic.create!(name: name, description: description) }

    let(:topic) { Topic.create!(name: RandomData.random_sentence, description: RandomData.random_paragraph)}


  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:labelings) }
  it { is_expected.to have_many(:labels).through(:labelings) }


  describe "attributes" do
    it "responds to name" do
      expect(topic).to respond_to(:name)
    end

    it "responds to description" do
      expect(topic).to respond_to(:description)
    end

    it "responds to public" do
      expect(topic).to respond_to(:public)
    end

      # describe "attributes" do
      # it "has name, description, and public attributes" do
      # expect(topic).to have_attributes(name: name, description: description, public: public)
      # end

    it "is public by default" do
      expect(topic.public).to be(true)
    end
  end
end
