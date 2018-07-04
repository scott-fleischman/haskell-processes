# Processes
Start multiple processes and interleave log output. This code is a basic setup for this kind of thing. The processes that are started are also Haskell programs in the same project, started with `stack exec`.

[![Build Status](https://travis-ci.org/scott-fleischman/haskell-processes.svg?branch=master)](https://travis-ci.org/scott-fleischman/haskell-processes)

## Example run:
```
$ stack exec process -- Aconitum Daisy Floss Alchemilla
"/home/.../haskell-processes/.stack-work/install/x86_64-linux/lts-11.16/8.2.2/bin/repeat"
1 2018-07-03T17:34:04-0700 Aconitum
2 2018-07-03T17:34:04-0700 Daisy
3 2018-07-03T17:34:04-0700 Floss
4 2018-07-03T17:34:04-0700 Alchemilla
1 2018-07-03T17:34:05-0700 Aconitum
2 2018-07-03T17:34:05-0700 Daisy
3 2018-07-03T17:34:05-0700 Floss
4 2018-07-03T17:34:05-0700 Alchemilla
1 2018-07-03T17:34:06-0700 Aconitum
2 2018-07-03T17:34:06-0700 Daisy
4 2018-07-03T17:34:06-0700 Alchemilla
3 2018-07-03T17:34:06-0700 Floss
1 2018-07-03T17:34:07-0700 Aconitum
3 2018-07-03T17:34:07-0700 Floss
4 2018-07-03T17:34:07-0700 Alchemilla
2 2018-07-03T17:34:07-0700 Daisy
1 2018-07-03T17:34:08-0700 Aconitum
```
