# cobra
COntinous Benchmarking, Reporting, and Alerting.


## Console runner

```sh
cd your-git-project-folder
```

Cobra expects a configuration (`.cobra.yaml`):

```yaml
build-command: build command --maybe with some --flags
bench-command: stack bench # For instance
```

```sh
cobra
```

This will run build and run the benchmark program for the current revision.

The benchmark program has to output lines like the following:

```text
"Write to file - time" "average (milliseconds)" 102.3 "std dev (milliseconds)" 23
"Write to file - memory" "average (MB)" 20 "std dev" 1
"Lines of code" "KLOC" 24.9
```

After the benchmark program is completed, the results will be stored to file,
and reported to the standard output:

```text
"Write to file - time":
   - "average (milliseconds)":
     - current: 102.3
     - best so far:    103.3
       - version: some hash
       - date: some date
     - improvement: 1 (x %)
  - "std dev (milliseconds)"
    - current ...
    - best:
       - version: some hash
       - date: some date
    - deterioration: y (z %)
"Write to file - memory":
  ...
```

