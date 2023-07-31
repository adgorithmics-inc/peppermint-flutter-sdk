#!/usr/bin/env bash
printf "\e[33;1m%s\e[0m\n" 'Running the Flutter analyzer'
dart analyze
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" 'Flutter analyzer error'
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running the Flutter analyzer'
# Run the unit tests
echo "Running unit tests..."
flutter test

# Check the exit status of the tests
test_result=$?

# If the tests fail, cancel the push
if [ $test_result -ne 0 ]; then
    echo "Unit tests failed. Push aborted."
    exit 1
fi

# If the tests pass, allow the push
exit 0