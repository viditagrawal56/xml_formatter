- [x] Make the XMLXMLLINT_INDENT variable configurable.
- [x] Graceful error handling:- throw an error if xmllint is missing or even if diff is missing.
- [x] Throw an error early if Windows is detected.
- [x] Make the script modular.
- [x] Update the script to allow users to choose between spaces and tabs for indentation with the -i option, defaulting to 4 spaces and 1 tab, and add a -s option to specify the number of spaces (only applicable when using spaces for indentation).
- [ ] Add -v for verbose output to show path traversal details and -q for quiet mode which would not show progress dots nor verbose output. The default should be to show progress dots for each file scanned.
- [ ] Path parameter:- Add support for glob patterns.
- [ ] GitHub Actions runner.
- [ ] Write tests for the script.