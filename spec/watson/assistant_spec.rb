require 'spec_helper'

RSpec.describe Watson::Assistant do


  describe "#version" do
    it "has a version number" do
      expect(Watson::Assistant::VERSION).not_to be nil
    end
  end



  describe "#initialize" do
    it "invalid config" do
      manager = Watson::Assistant::Manager.new(
        apikey: ENV["APIKEY"],
        username: ENV["USERNAME"],
        password: ENV["PASSWORD"],
        workspace_id: ENV["WORKSPACE_ID"],
        region: ENV["REGION"],
        storage: ENV["STORAGE"]
      )
      expect(manager.has_dlg?).to be nil
    end

    it "valid config" do
      manager = Watson::Assistant::Manager.new(
        username: ENV["USERNAME"],
        password: ENV["PASSWORD"],
        workspace_id: ENV["WORKSPACE_ID"],
        region: ENV["REGION"],
        storage: ENV["STORAGE"]
      )
      expect(manager.has_dlg?).not_to be nil
    end
  end



  describe "talk" do
    shared_examples_for "auth" do |manager|
      describe "#talk" do
        let(:user) {"user1"}
        it "responds a greet message" do
          expect(manager.talk(user, "")).to match(/200/)
        end

        it "responds to a user's input" do
          expect(manager.talk(user, "bar")).to match(/200/)
        end
      end
    end

    manager = Watson::Assistant::Manager.new(
      username: ENV["USERNAME"],
      password: ENV["PASSWORD"],
      workspace_id: ENV["WORKSPACE_ID"],
      region: ENV["REGION"],
      storage: ENV["STORAGE"]
    )
    it_behaves_like "auth", manager

    manager = Watson::Assistant::Manager.new(
      apikey: ENV["APIKEY"],
      workspace_id: ENV["WORKSPACE_ID"],
      region: ENV["REGION"],
      storage: ENV["STORAGE"]
    )
    it_behaves_like "auth", manager
  end



  describe "stroge" do
    shared_examples_for "storage" do |location|

      manager = Watson::Assistant::Manager.new(
        #apikey: ENV["APIKEY"],
        username: ENV["USERNAME"],
        password: ENV["PASSWORD"],
        workspace_id: ENV["WORKSPACE_ID"],
        region: ENV["REGION"],
        storage: location
      )

      user1 = "user1"
      user2 = "user2"

      manager.talk(user1, "")

      describe "#has_key?" do
        it "checks if the the user exists" do
          expect(manager.has_key?(user1)).to eq true
        end

        it "checks if the the user doesnot exist" do
          expect(manager.has_key?(user2)).to eq false
        end
      end

      describe "#delete" do
        it "checks if the the user exists" do
          expect(manager.delete(user1)).to include(a_string_starting_with("conversation_id")).or eq(1)
        end

        it "checks if the the user doesnot exist" do
          expect(manager.delete(user2)).to eq(nil).or eq(0)
        end
      end
    end

    it_behaves_like "storage", "hash"
    it_behaves_like "storage", "redis://127.0.0.1:6379"
  end

end
