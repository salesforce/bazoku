# bazoku 🚀

## bazel + heroku = bazoku

Bazoku brings Heroku deployments to bazel. We could have called this *rules_heroku* but *bazoku* sounds too much like *bazooka* to turn down. After all, Bazoku literally launches your bazel target into Heroku 🚀.

## Supported Languages

All of the languages we have tested can be seen in the [examples](./examples) directory. Other languages may also be supported but we just haven't tried them. So far, we've tried:

- [Go](./examples/go/BUILD.bazel)
- [Python](./examples/python/BUILD.bazel)

## Prerequisites

- `git` CLI available.
- Existing app created in Heroku.

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
    heroku_app_name = "thawing-dawn-07697",
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

The heroku CLI checks for valid authentication in the `.netrc` file ([see details](https://devcenter.heroku.com/articles/authentication#api-token-storage)). That means that if you already have valid credentials there, bazoku does not require any extra authentication to heroku. If there are no heroku credentials in your `.netrc` file, bazoku will prompt you to follow the Heroku authentication flow.

## Disclaimers

- We've only tested applications in the [examples](./examples) directory. Different use-cases aren't guaranteed to work. This was a fun side-project & hasn't been battle tested in production yet..

- We've only tested running deployments from MacOS host machines so far.
