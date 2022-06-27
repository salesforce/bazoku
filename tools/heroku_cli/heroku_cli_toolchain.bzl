# Copyright (c) 2022, salesforce.com, inc.
# All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
# For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

def _heroku_cli_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        cli = ctx.attr.cli,
    )
    return [toolchain_info]

heroku_cli_toolchain = rule(
    implementation = _heroku_cli_toolchain_impl,
    attrs = {
        "cli": attr.label(
          allow_single_file=True,
          executable=True,
          cfg="host",
        ),
    },
)
