This is a Ruby script using two libraries: json for parsing ScoutSuite exported AWS/GCP data and erb for generating templates for reporting purposes.

*Instructions*
0. Install json library using `gem install json`
1. After generating the AWS/GCP results using ScoutSuite, the "scoutsuite-results" folder contains a .js file which is the raw data. This file needs
   to be converted to a proper json format using this command:
```
python -m json.tool < scoutsuite-results.js > scoutsuite-clean-results.json
```
2. When finished, modify the .rb script file's "File.read" method to read the new json file. Execute the script when completed using `ruby
   aws-assess.rb`
3. Check output directory for the results and drag and drop the html items into Microsoft Word report.
