#!/usr/bin/env bash
printf "\e[33;1m%s\e[0m\n" 'Running the Flutter analyzer'
dart analyze
if [ $? -ne 0 ]; then
  printf "\e[31;1m%s\e[0m\n" 'Flutter analyzer error'
  exit 1
fi
printf "\e[33;1m%s\e[0m\n" 'Finished running the Flutter analyzer'
# Run the unit tests
