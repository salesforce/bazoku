# Copyright (c) 2022, salesforce.com, inc.
# All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause
# For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause

import os
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
  return "hello world, from python app deployed with bazoku!"

if __name__ == '__main__':
  port = os.getenv('PORT') if os.getenv('PORT') else 8080
  app.run(host="0.0.0.0", port=port)
