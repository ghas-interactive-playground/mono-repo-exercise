#!/usr/bin/env awk -f

BEGIN {
  # identify source code language for each directory
  while ("cat cfg_for_dir.txt" | getline) {
    # fields are delimited with a semicolon
    split($0, record, ";")
    # cfg_for_dir[<path>][<cfg.key>] = <cfg.value>
    cfg_for_dir[record[1]]["lang"] = record[2]
    cfg_for_dir[record[1]]["build_mode"] = record[3]
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
    dirs[$1] = sprintf( \
      "{\"directory\": \"%s\", \"language\": \"%s\", \"build_mode\": \"%s\"}", \
      $1, \
      cfg_for_dir[$1]["lang"], \
      cfg_for_dir[$1]["build_mode"] \
    )
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
