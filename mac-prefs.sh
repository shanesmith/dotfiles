#!/bin/bash

set -ex

# Check out
# - https://github.com/benbalter/plister
# - https://github.com/robperc/FinderSidebarEditor

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

defaults write AppleScrollerPagingBehavior -bool true

defaults write com.apple.dock mineffect -string scale

defaults write com.apple.dock minimize-to-application -bool true

defaults write com.apple.dock show-recents -bool false

defaults write com.apple.dock expose-group-apps -bool true

defaults write com.apple.dock autohide -bool true

defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true

defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1
defaults write com.apple.dock wvous-bl-corner -int 1

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehaviour -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehaviour -int 1

defaults write com.apple.trackpad.scaling -int 1

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

defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder PathBarRootAtHome -bool true

# Search current folder and not whole system
defaults write com.apple.finder FXDefaultSearchScope -string SCcf

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disablw writing of .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop         -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop     -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop     -bool false

defaults write com.apple.finder NewWindowTarget -string PfHm
defaults write com.apple.finder NewWindowTargetPath -string "file:///Users/shane/"

defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true

defaults write com.apple.finder ShowRecentTags -bool false

defaults write -g NSNavPanelExpandedStateForSaveMode -bool true

defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# https://apple.stackexchange.com/a/431021/214341
defaults -currentHost write com.apple.Spotlight MenuItemHidden -int 1

# https://superuser.com/a/1723655/261110
defaults -currentHost write com.apple.controlcenter WiFi -int 24

defaults write com.apple.controllcenter "NSStatusItem Visible NowPlaying" -bool false

defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write $(osascript -e 'id of app "Cursor"') ApplePressAndHoldEnabled -bool false

killall Dock
killall Finder

# Needed for "com.apple.AppleMultitouchTrackpad Clicking" at the very least
# https://apple.stackexchange.com/a/414836/214341
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
