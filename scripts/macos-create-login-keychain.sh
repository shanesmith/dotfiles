#!/bin/bash

# https://gist.github.com/thimslugga/dd7e0963b4a48f85d63fcb96fc478526

mkdir -p ~/Library/Keychains
security create-keychain ~/Library/Keychains/login.keychain
security unlock-keychain ~/Library/Keychains/login.keychain
security login-keychain -d user -s ~/Library/Keychains/login.keychain

security default-keychain -d user
security list-keychains -d user
security default-keychain
security list-keychains
