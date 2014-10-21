#!/bin/bash

sed --in-place=orig -e 's/^GUI_JAVA_OPTS="\(.*\)"$/GUI_JAVA_OPTS="\1 -Dorg.eclipse.swt.browser.DefaultType=mozilla"/' /usr/local/crashplan/bin/run.conf
