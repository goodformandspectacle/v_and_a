#! /usr/bin/env ruby

currentrev = `git log --pretty=format:'%h' -n 1`

`git archive -o rev-#{currentrev}.zip master:spelunker`
