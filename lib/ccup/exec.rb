module Ccup
  class Exec
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
      $stderr.puts BANNER
    end
  end
end
