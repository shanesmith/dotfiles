#!/bin/bash

#
# When you are working on your macbook sitting in cafe and you have to go pee, 
# you need some way to guard you machine. 
#
# Start this script, remove any earphones, and go do the job.
# The assumption is the thief will close the lid of the laptop before taking it away.
# This script detects the closing of the lid and plays some loud audio that will
# likely distract the thief and/or grab attention of nearby people, making the
# thief abondon his/her attempt of larceny
#

COUNTDOWN_FROM=5
LAUGHTER_LENGTH=5

checkNoSleep()
{
  if [[ ! -f `which NoSleepCtrl` ]]
  then
    echo "Please install NoSleepCtrl from "
    echo "  https://github.com/integralpro/nosleep/releases"
    echo " "
    echo "Install it with CLI included in it. It's necessary to prevent"
    echo "your macbook from going to sleep when somebody closes the clamshell."
    echo "When you launch this script it will automatically turn the 'NoSleep'"
    echo "mode ON and when you exit the script with Ctrl-C, the 'NoSleep' mode"
    echo "will automatically be turned OFF."
    echo "(You are not required to be running it in the tray)"
    echo " "
    exit
  fi
}

turnNoSleepOn()
{
  NoSleepCtrl -a -s 1
  NoSleepCtrl -b -s 1
}

turnNoSleepOff()
{
  NoSleepCtrl -a -s 0
  NoSleepCtrl -b -s 0
}

onCtrlC()
{
  turnNoSleepOff
  # Reset the volume to medium value
  osascript -e "set Volume 5"
  exit
}

main()
{
  checkNoSleep

  turnNoSleepOn

  # Turn Volume Up all the way
  osascript -e "set Volume 10"

  trap onCtrlC SIGINT

  let INTRUSION_DETECTED=0

  while true
  do
    CLAMSHELL_OPEN=`ioreg -r -k AppleClamshellState -d 4 | \
      grep AppleClamshellState  | \
      head -1 | cut -d = -f 2`

    if [ $CLAMSHELL_OPEN == "Yes" ] || [ $INTRUSION_DETECTED -eq 1 ]
    then
      say -v Fiona "Please stay away from this laptop"
      say -v Fiona "This machine will auto destruct in"
      let count=$COUNTDOWN_FROM
      while [ $count -gt 0 ]
      do
        say -v Fiona "$count"
        let count-=1
        sleep 1
      done
      for i in `seq 1 $LAUGHTER_LENGTH`
      do
        say -v "Hysterical" "Ha Ha Ha"
      done
      INTRUSION_DETECTED=1
    fi
    sleep 1
  done
}

main