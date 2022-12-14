# Copyright (c) 2022, salesforce.com, inc.
# All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
# For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

def _bazoku_impl(ctx):
    toolchain = ctx.toolchains["//tools/heroku_cli:toolchain_type"]
    heroku_cli = toolchain.cli.files.to_list()[0]
    binary = ctx.attr.binary.files.to_list()[-1] # this index changes depending on lang.. So far, I've seen success with using the last element
    script = ctx.actions.declare_file("%s-bazoku" % ctx.label.name)
    script_content = \
    """
    #!/bin/bash
    heroku_relative_path={}
    heroku="$(cd "$(dirname "$heroku_relative_path")" && pwd -P)/$(basename "$heroku_relative_path")"
    spacer="------------------------------"
    echo $spacer
    echo "checking authentication.."
    if ! $heroku whoami; then
      if ! $heroku login; then
        exit
      fi
    fi

    echo $spacer
    app_name={}
    if ! $heroku ps -a $app_name &> /dev/null; then
      echo "[ERROR] app ($app_name) does not exist in your account.."
      exit
    fi

    echo Starting heroku deployment of $app_name using bazoku..
    rm -rf /tmp/bazoku
    runfile_path=`pwd`
    cd ../../
    project_root=`pwd`
    # Doing everything here so we don't mess with rundir.
    # We can delete this dir at start and end.
    mkdir /tmp/bazoku
    cd /tmp/bazoku
    binary={}
    cp -L -R $project_root ./
    git init &> /dev/null
    $heroku git:remote -a $app_name &> /dev/null
    echo Adding heroku-binary-buildpack to $app_name..
    $heroku buildpacks:set https://github.com/ph3nx/heroku-binary-buildpack.git -a $app_name &> /dev/null
    cmd=$binary
    exists=0

    i=10 # try 10 times to find correct path
    while : ; do
      if [ ! -f "$cmd" ]; then
          # $cmd file doesn't exist, moving up a directory
          cmd=$(echo $cmd | sed 's/^[^/]*\\///g')
      else
          exists=1
      fi
      i=$((i-1))
      [[ $exists == 0 && $i > 0 ]] || break
    done

    if [[ $exists == 0 ]]; then
      echo "[ERROR] bazoku is confused with the path of your binary, exiting.."
      exit
    fi

    echo "web: ./$cmd" > Procfile
    git add . # TODO: try and restrict this a little. Maybe it's no possible due to deps etc..
    git commit -m --allow-empty &> /dev/null
    echo $spacer
    git push heroku $(git rev-parse --abbrev-ref HEAD):main -f --quiet
    cd $runfile_path
    rm -rf /tmp/bazoku
    """.format(heroku_cli.short_path, ctx.attr.heroku_app_name, binary.short_path)
    ctx.actions.write(script, script_content, is_executable = True)
    return [DefaultInfo(
        executable = script,
        runfiles = ctx.runfiles(files = [heroku_cli] + ctx.attr.binary.files.to_list()),
    )]

bazoku = rule(
    implementation = _bazoku_impl,
    executable = True,
    attrs = {
        "binary": attr.label(
            executable = True,
            mandatory = True,
            cfg = "target",
        ),
        "heroku_app_name": attr.string(
            mandatory = True,
        ),
    },
    toolchains = ["//tools/heroku_cli:toolchain_type"],
)
