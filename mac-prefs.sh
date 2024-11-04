#!/bin/bash

set -ex

defaults write AppleScrollerPagingBehavior -bool true

defaults write com.apple.dock mineffect -string scale

defaults write com.apple.dock minimize-to-application -bool true

defaults write com.apple.dock show-recents -bool false

defaults write com.apple.dock expose-group-apps -bool true

defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true

defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

defaults write com.apple.dock wvous-tr-corner -int 5

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehaviour -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehaviour -int 1

# Disable Notifaction Centre Swipe left from right edge with two fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 0

# Mission Control - Swipe Up with Four Fingers
# App Expose - Swipe Down with Four Fingers
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadFourFingerVertSwipeGesture -int 2
defaults write com.apple.dock showAppExposeGestureEnabled -bool true
defaults write com.apple.dock showMissionControlGestureEnabled -bool true

# defaults delete com.apple.Spotlight "NSStatusItem Visible Item-0"

killall Dock
