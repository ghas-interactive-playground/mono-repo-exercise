#!/usr/bin/env awk -f

BEGIN {
  # identify source code language for each directory
  while ("cat lang_for_dir.txt" | getline) {
    # fields are delimited with a semicolon
    split($0, record, ";")
    # lang_for_dir[<path>] = <language>
    lang_for_dir[record[1]] = record[2]
  }

  # create dirs variable as empty array
  split("", dirs)

  # field separator is path separator for linux
  FS = "/"
}

{
  # skip directory if already procesed
  if (!dirs[$1]) {
    # record directory where files have changed, and programming language for codeql analysis 
    dirs[$1] = sprintf("{\"directory\": \"%s\", \"language\": \"%s\"}", $1, lang_for_dir[$1])
  }
}

END {
  # print json
  print "{\"changes\":["

  for (key in dirs) {
    idx++
    print dirs[key]
    if (idx < length(dirs)) {
      print ","
    }
  }

  print "]}"
}
