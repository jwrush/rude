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
   it "should have twos item if intialized from a string ending with tag" do
        x = Hyperstring.new("test string #(TEST)")
        expect(x.items[0]).to eq("test string ")
        expect(x.items[1]).to eq("#(TEST)")
        expect(x.items.count).to eq(2)
   end
end
