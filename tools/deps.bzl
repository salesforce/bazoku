# Copyright (c) 2022, salesforce.com, inc.
# All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
# For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def bazoku_deps():
    http_archive(
        name = "heroku_darwin",
        # TODO: we need to pin to a version, otherwise the sha would fail eventually..
        # can't find pinned versions hosted anywhere, need to ask around.
        # that's why the SHA is commented out..
        # sha256 = "d96f75059a195226a36a8bd367e0422106f9051e229773dad07d2c9adabd5e68",
        urls = [ "https://cli-assets.heroku.com/heroku-darwin-x64.tar.gz" ],
        build_file_content = """exports_files(glob(["**/*"]))""",
    )

    http_archive(
        name = "heroku_linux",
        # TODO: we need to pin to a version, otherwise the sha would fail eventually..
        # can't find pinned versions hosted anywhere, need to ask around.
        # that's why the SHA is commented out..
        # sha256 = "d96f75059a195226a36a8bd367e0422106f9051e229773dad07d2c9adabd5e68",
        urls = [ "https://cli-assets.heroku.com/heroku-linux-x64.tar.gz" ],
        build_file_content = """exports_files(glob(["**/*"]))""",
    )

    native.register_toolchains(
        "//tools/heroku_cli:heroku_cli_darwin_toolchain",
        "//tools/heroku_cli:heroku_cli_linux_toolchain"
    )
