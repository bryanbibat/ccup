require 'spec_helper'

describe Ccup::Exec do
  pending "should display banner on incorrect input"

  describe "initial load" do

    subject { Ccup::Exec.new(["submission_file.rb", "input_folder", "output.txt", "answer.txt"]) }

    its(:submission) { should == "submission_file.rb" }
    its(:input_folder) { should == "input_folder" }
    its(:output_file) { should == "output.txt" }
    its(:answer_key) { should == "answer.txt" }

  end
end
