require 'spec_helper'

RSpec.describe Watson::Assistant do
  it "has a version number" do
    expect(Watson::Assistant::VERSION).not_to be nil
  end


  shared_examples_for "assistant" do |storage|

    manager = Watson::Assistant::Manager.new(
      username: ENV["USERNAME"],
      password: ENV["PASSWORD"],
      workspace_id: ENV["WORKSPACE_ID"],
      region: ENV["REGION"],
      storage: ENV["STORAGE"]
    )

    describe "#talk" do
      let(:user) {"user1"}
      it "responds a greet message" do
        expect(manager.talk(user, "")).to match(/status_code/)
      end

      it "responds to a user's input" do
        expect(manager.talk(user, "bar")).to match(/status_code/)
      end
    end


    describe "#has_key?" do
      let(:user1) {"user1"}
      let(:user2) {"user2"}
      it "checks if the the user exists" do
        expect(manager.users.has_key?(user1)).to eq true
      end

      it "checks if the the user doesnot exist" do
        expect(manager.users.has_key?(user2)).to eq false
      end
    end

    describe "#delete" do
      let(:user1) {"user1"}
      let(:user2) {"user2"}
      it "checks if the the user exists" do
        expect(manager.users.delete(user1)).to include(a_string_starting_with("conversation_id")).or eq(1)
      end

      it "checks if the the user doesnot exist" do
        expect(manager.users.delete(user2)).to eq(nil).or eq(0)
      end
    end
  end


  describe "Hash" do
    it_behaves_like "assistant", "hash"
  end

  describe "Redis" do
    it_behaves_like "assistant", "redis://127.0.0.1:6379"
  end

end
