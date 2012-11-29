require 'open4'
require 'tmpdir'

module Ccup
  class Exec

    attr_reader :submission, :input_folder, :output_file, :answer_key, :error, :temp_folder
    BANNER = <<-MSG

Usage
  ccup SUBMISSION_FILE INPUT_FOLDER OUTPUT_FILE ANSWER_KEY_FILE

Description
  Creates a temporary directory and copies SUBMISSION_FILE, the files inside
  INPUT_FOLDER, and ANSWER_KEY_FILE into it before compiling (if needed) and
  executing the SUBMISSION_FILE.

  Verification will be done by running "diff" on OUTPUT_FILE and ANSWER_KEY_FILE
  and putting the results into result.txt on the same folder. The running time
  will also be added to result.txt.

  The program ends with displaying the temporary folder.

MSG
    def initialize(argv)
      if argv.size != 4
        $stderr.puts BANNER
        @error = true
        return
      end
      @submission = argv[0]
      @input_folder = argv[1]
      @output_file = argv[2]
      @answer_key = argv[3]
      unless @error
        @submission_file = File.basename(@submission)
        validate
        @pl = determine_pl(File.extname(@submission))
      end
    end

    def validate
      unless File.exist? @submission
        @error = true
        $stderr.puts "Can't find #{@submission}"
      end
      unless Dir.exist? @input_folder
        @error = true
        $stderr.puts "Can't find #{@input_folder}"
      end
      unless File.exist? @answer_key
        @error = true
        $stderr.puts "Can't find #{@answer_key}"
      end
    end

    def determine_pl(ext)
      case ext
      when ".c"
        :c
      when ".cpp"
        :cpp
      when ".cs"
        :csharp
      when ".java"
        :java
      when ".php"
        :php
      when ".vb"
        :vbnet
      when ".rb"
        :ruby
      when ".py"
        :python
      when ".js"
        :js
      else
        @error = true
        $stderr.puts "Invalid submission"
      end
    end

    def process
      return if @error
      @temp_folder = prepare_temp_folder
      Dir.chdir @temp_folder do 
        @results_file = File.open("results.txt", "w")
        compile
        unless @error
          run
        end
        unless @error
          compare
        end
        @results_file.puts "Done."
        @results_file.close
      end
      return self
    end

    def prepare_temp_folder
      temp_folder = Dir.mktmpdir
      FileUtils.cp @submission, temp_folder
      Dir.chdir @input_folder do
        FileUtils.cp Dir.entries(".").reject { |x| File.directory? x }, temp_folder
      end
      FileUtils.cp @answer_key, temp_folder
      `touch #{File.join temp_folder, @output_file}`
      temp_folder
    end

    def compile
      command = case @pl
      when :c
        "gcc -Wall #{@submission_file} -o #{root_name}"
      when :cpp
        "g++ -Wall #{@submission_file} -o #{root_name}"
      when :csharp
        "gmcs #{@submission_file}"
      when :java
        "javac #{@submission_file}"
      when :vbnet
        "vbnc #{@submission_file}"
      end
      if command
        @results_file.puts "Compiling submission..."
        pid, stdin, stdout, stderr = Open4::popen4 command
        ignored, status = Process::waitpid2 pid
        unless status.exitstatus == 0
          @error = true
          @results_file.puts "ERROR ENCOUNTERED:"
          @results_file.puts stderr.read.strip
        end
      end
    end

    def run
      command = case @pl
      when :c, :cpp
        "./#{root_name}"
      when :csharp, :vbnet
        "mono #{root_name}.exe"
      when :java
        "java #{root_name}"
      when :ruby
        "ruby #{@submission_file}"
      when :python
        "python #{@submission_file}"
      when :phpFile.e
        "php #{@submission_file}"
      when :js
        "node #{@submission_file}"
      end
      @results_file.puts "Running submission..."
      start_at = Time.now
      pid, stdin, stdout, stderr = Open4::popen4 command
      ignored, status = Process::waitpid2 pid
      
      unless status.exitstatus == 0
        @error = true
        @results_file.puts "ERROR ENCOUNTERED:"
        @results_file.puts stderr.read.strip
      end
      #TODO check status
      @results_file.puts "Execution time: #{ Time.now - start_at } seconds"
    end

    def root_name
      File.basename(@submission_file, File.extname(@submission_file))
    end

    def compare
      @results_file.puts "Comparing output with answer key..."
      pid, stdin, stdout, stderr = Open4::popen4 "diff #{@output_file} #{File.basename @answer_key}"
      ignored, status = Process::waitpid2 pid

      @results_file.puts stdout.read.strip
    end

  end
end
