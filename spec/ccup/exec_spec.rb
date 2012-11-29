require 'spec_helper'

valid_submission = "./spec/files/submission.rb"
valid_input_folder = "./spec/files/input"
valid_output = "output.txt"
valid_answer_key = "./spec/files/answer_key.txt"

incorrect_submission = "./spec/files/wrong_submission.rb"
error_submission = "./spec/files/error_submission.rb"
missing_submission = "./spec/files/missing.rb"
missing_input_folder = "./spec/files/inputx"
missing_answer_key = "./spec/files/answer_keyx.txt"
compile_error_submission = "./spec/files/SubmissionError.java"
valid_python = "./spec/files/submission.py"
valid_java = "./spec/files/Submission.java"

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

    it "for java should not return with error" do
      error = capture(:stderr) do 
        java_values = [valid_java] + valid_values[1,3]
        c = Ccup::Exec.new(java_values)
        c.error.should_not be true
        c.process 
        6.should == IO.readlines(File.join(c.temp_folder, "results.txt")).size
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

    it "should stop on missing submission files" do
      error = capture(:stderr) do 
        invalid_values = [missing_submission] + valid_values[1,3]
        c = Ccup::Exec.new(invalid_values)
        c.error.should == true
      end
      error.strip.should == "Can't find #{missing_submission}"
    end

    it "should stop on missing input folder" do
      error = capture(:stderr) do 
        invalid_values = [valid_values[0], missing_input_folder] + valid_values[2,2]
        c = Ccup::Exec.new(invalid_values)
        c.error.should == true
      end
      error.strip.should == "Can't find #{missing_input_folder}"
    end

    it "should stop on missing answer key" do
      error = capture(:stderr) do 
        invalid_values = valid_values[0,3] + [missing_answer_key]
        c = Ccup::Exec.new(invalid_values)
        c.error.should == true
      end
      error.strip.should == "Can't find #{missing_answer_key}"
    end

    it "should stop on non-programs" do
      error = capture(:stderr) do 
        invalid_values = [valid_answer_key] + valid_values[1,3]
        c = Ccup::Exec.new(invalid_values)
        c.error.should == true
      end
      error.strip.should == "Invalid submission"
    end

    it "should produce a large result file" do
      invalid_values = [incorrect_submission] + valid_values[1,3]
      c = Ccup::Exec.new(invalid_values).process
      5.should < IO.readlines(File.join(c.temp_folder, "results.txt")).size
    end

    it "should stop on compiler error" do
      invalid_values = [compile_error_submission] + valid_values[1,3]
      c = Ccup::Exec.new(invalid_values).process
      "ERROR ENCOUNTERED:".should == IO.readlines(File.join(c.temp_folder, "results.txt"))[1].strip
    end

    it "should stop on runtime error" do
      invalid_values = [error_submission] + valid_values[1,3]
      c = Ccup::Exec.new(invalid_values).process
      "ERROR ENCOUNTERED:".should == IO.readlines(File.join(c.temp_folder, "results.txt"))[1].strip
    end
  end
end
