# Log parser

Enjoy.

# Usage

Run `make build` to install pre-requisites.

You can run `parser.rb` with the following options:

```
Usage: parser.rb FILENAME [options]
    -v, --[no-]verbose               Run verbosely (default false)
    -s, --[no-]strict                Strict mode (drops non-ipv4 traffic) (default false)
    -b, --batch-size BATCHSIZE       Number of rows to process at once (default 1000)
        --views a,b                  Views to display. (unique-page-views, traffic-counter available. Defaults to both.)
    -h, --help                       Prints this help
```

# Contributing

You can run the tests and check coverage using `make test`
