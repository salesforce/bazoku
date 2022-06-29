# bazoku 🚀

## bazel + heroku = bazoku

Bazoku brings Heroku deployments to bazel. We could have called this *rules_heroku* but *bazoku* sounds too much like *bazooka* to turn down. After all, bazoku literally launches your bazel target into Heroku 🚀.

## Supported Languages

All of the languages we have tested can be seen in the [examples](./examples) directory. Other languages may also be supported but we just haven't tried them. So far, we've tried:

- [Go](./examples/go/BUILD.bazel)
- [Python](./examples/python/BUILD.bazel)

## Setup

### Prerequisites

- `git` CLI available.
- Existing app created in Heroku.

### WORKSPACE File

Adding the following to your Bazel `WORKSPACE` file will fetch `bazoku` and its dependencies:

```
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "bazoku",
    sha256 = "bb12e93d3319c670427decaa2240e1c2afc3e09ffd179bf4e11210313b9be6ba",
    urls = ["https://github.com/salesforce/bazoku/releases/download/v0.2.0/bazoku-v0.2.0.tar.gz"],
)

load("@bazoku//tools:deps.bzl", "bazoku_deps")
bazoku_deps()
```

## Usage

```
...
load("@bazoku//:bazoku.bzl", "bazoku")

go_binary(
    name = "example",
    srcs = ["main.go"]
)

bazoku(
    name = "bazoku-deployment",
    heroku_app_name = "my-heroku-app-name-123",
    binary = ":example"
)
```

Heroku uses a linux/amd64 architecture. This means that any executables generated should be compatible with that. An example is provided below for how to do this for a golang application:

```
cd examples
bazel run go:bazoku-deployment --platforms=@io_bazel_rules_go//go/toolchain:linux_amd64
```

There's also another example for a python application:

```
cd examples
bazel run python:bazoku-deployment
```

## Authentication

### Interactive

If the non-interactive methods (below) are not provided, the heroku CLI will prompt for credentials.

### Non-Interactive (CI)

- The Heroku CLI checks for valid authentication in the `.netrc` file ([see details](https://devcenter.heroku.com/articles/authentication#api-token-storage)). That means that if there are valid credentials there, bazoku does not require any interactive authentication to heroku.

- The Heroku CLI also checks for the presence of the `HEROKU_API_KEY` environment variable. If a Heroku API key is set, the CLI will read the value & won't prompt for credentials.

## Disclaimers

- We've only tested applications in the [examples](./examples) directory. Different use-cases aren't guaranteed to work. This was a fun side-project & hasn't been battle tested in production yet..

- We've only tested running deployments from MacOS host machines so far.
