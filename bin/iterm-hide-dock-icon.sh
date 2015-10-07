#!/bin/bash

pb='/usr/libexec/PlistBuddy'
iTerm='/Applications/iTerm.app/Contents/Info.plist'

echo "Do you wish to hide iTerm in Dock?"
select ync in "Hide" "Show" "Cancel"; do
  case $ync in
    'Hide' )
      $pb -c "Add :LSUIElement bool true" $iTerm
      echo "relaunch iTerm to take effect"
      break
      ;;
    'Show' )
      $pb -c "Delete :LSUIElement" $iTerm
      echo "relaunch iTerm to take effect"
      break
      ;;
    'Cancel' )
      break
      ;;
  esac
done
