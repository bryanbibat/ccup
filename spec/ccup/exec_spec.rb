require 'spec_helper'

valid_submission = "./spec/files/submission.rb"
valid_input_folder = "./spec/files/input/"
valid_output = "./spec/files/output.txt"
valid_answer_key = "./spec/files/answer_key.txt"

valid_values = [valid_submission, valid_input_folder, valid_output, valid_answer_key]

describe Ccup::Exec do

  describe "input" do
    it "should output error" do
      error = capture(:stderr) do 
        Ccup::Exec.new([])
      end
      error.should == Ccup::Exec::BANNER
    end

    it "should have 4 arguments" do
      capture(:stderr) do 
        Ccup::Exec.new([]).error.should be true
      end
      error = capture(:stderr) do 
        Ccup::Exec.new(valid_values[0,3]).error.should be true
      end
      error.should == Ccup::Exec::BANNER
    end
  end

  describe "correct input" do
    it "should not return with error" do
      error = capture(:stderr) do 
        Ccup::Exec.new(valid_values).error.should_not be true
      end
      error.should_not == Ccup::Exec::BANNER
    end
  end

  describe "initial load" do

    subject { Ccup::Exec.new(valid_values) }

    its(:submission) { should == valid_submission }
    its(:input_folder) { should == valid_input_folder }
    its(:output_file) { should == valid_output }
    its(:answer_key) { should == valid_answer_key }

  end
end
