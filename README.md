# Ccup

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'ccup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ccup

## Usage

    $ ccup SUBMISSION_FILE INPUT_FOLDER OUTPUT_FILE ANSWER_KEY_FILE

Creates a temporary directory and copies SUBMISSION\_FILE, the files inside
INPUT\_FOLDER, and ANSWER\_KEY\_FILE into it before compiling (if needed) and
executing the SUBMISSION\_FILE.

Verification will be done by running "diff" on OUTPUT\_FILE and ANSWER\_KEY\_FILE
and putting the results into result.txt on the same folder. The running time
will also be added to result.txt.

The program ends with displaying the temporary folder.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
