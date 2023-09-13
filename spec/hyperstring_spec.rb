require 'rspec'
require_relative '../lib/hyperstring'

RSpec.describe Hyperstring do
   it "should be empty if initialized from the empty string" do
        x = Hyperstring.new("")
        expect(x.items.empty?)
   end
   it "should have one item if intialized from a string without tag" do
        x = Hyperstring.new("test string")
        expect(x.items.count).to eq(1)
        expect(x.items[0]).to eq("test string")
   end
   it "should have one item item if only tag" do
        x = Hyperstring.new("$(TEST_TAG)")
        expect(x.items.count).to eq(1)
        expect(x.items[0]).to eq("$(TEST_TAG)")
   end
   it "should have twos item if intialized from a string ending with tag" do
        x = Hyperstring.new("test string #(TEST)")
        expect(x.items[0]).to eq("test string ")
        expect(x.items[1]).to eq("#(TEST)")
        expect(x.items.count).to eq(2)
   end
   it "should have twos item if intialized from a string start with tag but stuff after" do
        x = Hyperstring.new("#(TEST) stuff after")
        expect(x.items[0]).to eq("#(TEST)")
        expect(x.items[1]).to eq(" stuff after")
        expect(x.items.count).to eq(2)
   end
   it "should have three items if initialized from string with stuff tag stuff" do
        x = Hyperstring.new("test string #(TEST) more text")
        expect(x.items[0]).to eq("test string ")
        expect(x.items[1]).to eq("#(TEST)")
        expect(x.items[2]).to eq(" more text")
        expect(x.items.count).to eq(3)
   end
   it "should have three items if initialized from string with tag stuff tag" do
        x = Hyperstring.new("#(TEST) #(TEST2)")
        expect(x.items[0]).to eq("#(TEST)")
        expect(x.items[1]).to eq(" ")
        expect(x.items[2]).to eq("#(TEST2)")
        expect(x.items.count).to eq(3)
   end
end
