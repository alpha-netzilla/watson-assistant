require 'spec_helper'

RSpec.describe Watson::Assistant do
  describe "#version" do
    it "has a version number" do
      expect(Watson::Assistant::VERSION).not_to be nil
    end
  end



  describe "#initialize" do
    describe "invalid config" do
      it "is nil" do
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
    end


    describe "valid config" do
      it "is not nil" do
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
  end


  describe "talk" do
    shared_examples_for "auth" do |manager|
      describe "#talk" do
        user = "user1"
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
=begin
    manager = Watson::Assistant::Manager.new(
      apikey: ENV["APIKEY"],
      workspace_id: ENV["WORKSPACE_ID"],
      region: ENV["REGION"],
      storage: ENV["STORAGE"]
    )
    it_behaves_like "auth", manager
=end
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
        context "checks if the the user exists" do
          it "true" do
            expect(manager.has_key?(user1)).to eq true
          end
        end

        context "checks if the the user doesnot exist" do
          it "false" do
            expect(manager.has_key?(user2)).to eq false
          end
        end
      end

      describe "#delete" do
        context "checks if the the user exists" do
          it "hash value at hash or 1 at redis" do
            expect(manager.delete(user1)).to include(a_string_starting_with("conversation_id")).or eq(1)
          end
        end

        context "checks if the the user doesnot exist" do
          it "nil at hash or 0 at redis" do
            expect(manager.delete(user2)).to eq(nil).or eq(0)
          end
        end
      end
    end

    it_behaves_like "storage", "hash"
    it_behaves_like "storage", "redis://127.0.0.1:6379"
  end


  describe "context", type: :hoge do
    shared_examples_for "storage2" do |location|
      manager = Watson::Assistant::Manager.new(
        username: ENV["USERNAME"],
        password: ENV["PASSWORD"],
        workspace_id: ENV["WORKSPACE_ID"],
        region: ENV["REGION"],
        storage: location
      )
      user = "user1"
      describe "#read_context" do
        it "all context" do
          manager.talk(user, "")
          expect(manager.read_context(user: user)).to include("conversation_id")
        end
      end


      describe "#read_context_section" do
        it "context section" do
          manager.talk(user, "")
          expect(manager.read_context_section(user: user, key: "conversation_id")).to match(/(\d|\w)+-/)
        end
      end


      describe "#update_context_section" do
        it "true" do
          section = {"my_credentials"=> {
                       "user": "1367baf8-09af-4a1e-b3b9-d6e4dd94d436",
                       "password": "BHFIKIjjixRo3tcUHSfJ983nbBksKHfLQWHuNDKGVuNTlE1X7FUYoqCGcHC2RpZB"
                      }
                    }
          manager.talk(user, "")
          expect(manager.update_context_section(user: user, key: "private", value: section)).to include("conversation_id")
        end
      end

      describe "#delete_context_section" do
        it "true" do
          expect(manager.delete_context_section(user: user, key: "private")).to include("conversation_id")
          manager.delete(user)
        end
      end
    end
    it_behaves_like "storage2", "hash"
    it_behaves_like "storage2", "redis://127.0.0.1:6379"
  end


end
