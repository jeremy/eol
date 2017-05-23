# EOL [![Build Status](https://travis-ci.org/jeremy/eol.svg?branch=master)](https://travis-ci.org/jeremy/eol)

EOL sniffs line ending style and binary vs. text using Git's heuristics.

Feed it a text string or IO and it'll answer these questions:

* Is it binary? (Does it contain null bytes, non-printable chars, etc.)
* Does it have \r\n (aka "DOS") or \n (aka "Unix") line endings?

It'll also normalize line endings for you if you'd like to uniformly
work with \r\n or \n.

# What is a "CRLF" anyway??

[Everything about newlines](https://en.wikipedia.org/wiki/Newline)

# Compatibility

EOL supports Ruby 1.8 and later. It's tested on 1.8.7, 1.9.3, and 2.x.

"Ancient" Ruby support is intentional so other libraries that support
older Rubies may depend on EOL.

# Usage

```ruby
# Is this string or IO a binary?
# Note: reads the IO and doesn't rewind.
EOL.text?(string_or_io)
# => true/false

# Is this string or IO a binary?
# Note: reads the IO and doesn't rewind.
EOL.binary?(string_or_io)
# => true/false

# What line endings does this use?
EOL.sniff(string_or_io)
# => :crlf/:lf/:binary

# Shorthand sniffer
EOL(string_or_io)
# => :crlf/:lf/:binary

# I want more detail. Zoom in… enhance…
EOL.stat(string_or_io)
# => #<EOL::Stat @crlf=103 @lf=0 @nonprintable=0 …>

# Convert line endings to \r\n
EOL.convert("foo\nbar\n", :crlf)
# => "foo\r\nbar\r\n"
```

# Implementation

EOL just scans the text for end-of-line, null, and non-printable chars and
tallies up counts.

# License

MIT
