require 'open4'

module Ccup
  class Exec

    attr_reader :submission, :input_folder, :output_file, :answer_key, :error
    BANNER = <<-MSG

Usage
  ccup SUBMISSION_FILE INPUT_FOLDER OUTPUT_FILE ANSWER_KEY_FILE

Description
  Creates a temporary directory and copies SUBMISSION_FILE, the files inside
  INPUT_FOLDER, and ANSWER_KEY_FILE into it before compiling (if needed) and
  executing the SUBMISSION_FILE.

  Verification will be done by running "diff" on OUTPUT_FILE and ANSWER_KEY_FILE
  and putting the results into result.txt on the same folder. The running time
  as calculated by "time" will also be added to result.txt.

  The program ends with displaying the contents of result.txt.

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
      @submission_file = File.basename(@submission)
      @pl = determine_pl(File.extname(@submission))
    end

    def determine_pl(ext)
      case ext
      when "rb"
        :ruby
      end
    end

    def process
      temp_folder = prepare_temp_folder
      Dir.chdir temp_folder do 
        @results_file = File.open("results.txt", "w")
        compile
        run
        compare
      end
    end

    def prepare_temp_folder
      temp_folder = Dir.mktmpdir
      FileUtils.cp @submission, temp_folder
      FileUtils.cp Dir.entries(@input_folder).reject { |x| File.directory? x }, temp_folder
      FileUtils.cp @answer_key, temp_folder
      temp_folder
    end

    def compile
      case @pl
      when :ruby
        # do nothing
      end
    end

    def run
      command = case @pl
      when :ruby
        "ruby #{@submission_file}"
      end
      @output_file.puts "Running submission..."
      start_at = Time.now
      pid, stdin, stdout, stderr = Open4::popen4 command

      ignored, status = Process::waitpid2 pid
      @output_file.puts "Execution time: #{(Time.now - start_at) * 1000.0 }"
    end

  end
end
