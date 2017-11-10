#!/bin/sh

## A benchmark program can output benchmark data for the same benchmark item,
## however what it is being measured must be different. 

echo \"Foo bench\" 22 micro-secs
echo \"Foo bench\" 12 MB
## Since the micro-seconds that "foo bench" too were already output, the next
## measurement will be ignored.
echo \"Foo bench\" 88 micro-secs
