#!/bin/bash

THISDIR=$(cd $(dirname $0) && pwd)

for module in .git/modules/vim/bundle/*; do
  echo "doc/tags" >> "${module}/info/exclude"
done
