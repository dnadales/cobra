#!/bin/sh

echo \"My \\\"slow\\\" benchmark\" 2.3495 micro-secs 1.234 std-dev 0.234 r2
echo \"My \\\"fast\\\" benchmark\" 0.3495 micro-secs 0.234 std-dev 0.034 r2
## Memory benchmarks could also be collected.
echo \"Some memory benchmark\" 20 MB 1 std-dev
## And `cobra` does not care about what is added as label to the data.
echo \"Just a number\" 20 bogus-units
echo \"And a last benchmark\" 0.3495 micro-secs 0.234 std-dev 0.034 r2
