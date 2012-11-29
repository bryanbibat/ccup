require 'spec_helper'

valid_submission = "./spec/files/submission.rb"
valid_input_folder = "./spec/files/input"
valid_output = "output.txt"
valid_answer_key = "./spec/files/answer_key.txt"

incorrect_submission = "./spec/files/wrong_submission.rb"
valid_python = "./spec/files/submission.py"

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
        c = Ccup::Exec.new(valid_values)
        c.error.should_not be true
        c.process 
        5.should == IO.readlines(File.join(c.temp_folder, "results.txt")).size
      end
      error.should_not == Ccup::Exec::BANNER
    end

    it "should not return with error" do
      error = capture(:stderr) do 
        c = Ccup::Exec.new(valid_values)
        c.error.should_not be true
        c.process 
        5.should == IO.readlines(File.join(c.temp_folder, "results.txt")).size
      end
      error.should_not == Ccup::Exec::BANNER
    end

    it "for python should not return with error" do
      error = capture(:stderr) do 
        python_values = [valid_python] + valid_values[1,3]
        c = Ccup::Exec.new(python_values)
        c.error.should_not be true
        c.process 
        5.should == IO.readlines(File.join(c.temp_folder, "results.txt")).size
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

  describe "incorrect input" do
    it "should produce a large result file" do
      invalid_values = [incorrect_submission] + valid_values[1,3]
      c = Ccup::Exec.new(invalid_values).process
      5.should < IO.readlines(File.join(c.temp_folder, "results.txt")).size
    end
  end
end
