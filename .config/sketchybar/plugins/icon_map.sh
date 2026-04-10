#!/bin/bash

case "$1" in
"Alacritty")                   icon_result=":alacritty:" ;;
"Alfred")                      icon_result=":alfred:" ;;
"Android Studio")              icon_result=":android_studio:" ;;
"App Store")                   icon_result=":app_store:" ;;
"Arc")                         icon_result=":arc:" ;;
"Bitwarden")                   icon_result=":bit_warden:" ;;
"Blender")                     icon_result=":blender:" ;;
"Brave Browser")               icon_result=":brave_browser:" ;;
"Calendar" | "Fantastical")    icon_result=":calendar:" ;;
"Chromium" | "Google Chrome" | "Google Chrome Canary")
                               icon_result=":google_chrome:" ;;
"Code" | "Code - Insiders")    icon_result=":code:" ;;
"Cursor")                      icon_result=":code:" ;;
"Discord" | "Discord Canary" | "Discord PTB")
                               icon_result=":discord:" ;;
"Docker" | "Docker Desktop")   icon_result=":docker:" ;;
"Drafts")                      icon_result=":drafts:" ;;
"Emacs")                       icon_result=":emacs:" ;;
"FaceTime")                    icon_result=":face_time:" ;;
"Figma")                       icon_result=":figma:" ;;
"Finder" | "访达")              icon_result=":finder:" ;;
"Firefox")                     icon_result=":firefox:" ;;
"Firefox Developer Edition" | "Firefox Nightly")
                               icon_result=":firefox_developer_edition:" ;;
"GitHub Desktop")              icon_result=":git_hub:" ;;
"Ghostty")                     icon_result=":ghostty:" ;;
"Hyper")                       icon_result=":hyper:" ;;
"IntelliJ IDEA")               icon_result=":idea:" ;;
"iTerm2")                      icon_result=":iterm:" ;;
"Joplin")                      icon_result=":joplin:" ;;
"Kakoune")                     icon_result=":kakoune:" ;;
"KeePassXC")                   icon_result=":kee_pass_x_c:" ;;
"Keynote")                     icon_result=":keynote:" ;;
"kitty")                       icon_result=":kitty:" ;;
"League of Legends")           icon_result=":league_of_legends:" ;;
"Linear")                      icon_result=":linear:" ;;
"Mail" | "Outlook" | "Mailspring" | "MailMate")
                               icon_result=":mail:" ;;
"Messages" | "Nachrichten")    icon_result=":messages:" ;;
"Microsoft Edge")              icon_result=":microsoft_edge:" ;;
"Microsoft Excel")             icon_result=":microsoft_excel:" ;;
"Microsoft PowerPoint")        icon_result=":microsoft_power_point:" ;;
"Microsoft Teams" | "Microsoft Teams (PWA)")             icon_result=":microsoft_teams:" ;;
"Microsoft Word")              icon_result=":microsoft_word:" ;;
"Min")                         icon_result=":min_browser:" ;;
"Music")                       icon_result=":music:" ;;
"Neovide" | "MacVim" | "Vim" | "VimR")
                               icon_result=":vim:" ;;
"Notes")                       icon_result=":notes:" ;;
"Notion")                      icon_result=":notion:" ;;
"Numbers")                     icon_result=":numbers:" ;;
"OBS")                         icon_result=":obsstudio:" ;;
"Obsidian")                    icon_result=":obsidian:" ;;
"Pages")                       icon_result=":pages:" ;;
"Podcasts")                    icon_result=":podcasts:" ;;
"Postman")                     icon_result=":postman:" ;;
"Preview" | "Skim" | "zathura")
                               icon_result=":pdf:" ;;
"Reminders")                   icon_result=":reminders:" ;;
"Safari" | "Safari Technology Preview")
                               icon_result=":safari:" ;;
"Signal")                      icon_result=":signal:" ;;
"Sketch")                      icon_result=":sketch:" ;;
"Slack")                       icon_result=":slack:" ;;
"Spotify")                     icon_result=":spotify:" ;;
"Sublime Text")                icon_result=":sublime_text:" ;;
"System Preferences" | "System Settings")
                               icon_result=":gear:" ;;
"Telegram")                    icon_result=":telegram:" ;;
"Terminal")                    icon_result=":terminal:" ;;
"Thunderbird")                 icon_result=":thunderbird:" ;;
"Todoist")                     icon_result=":todoist:" ;;
"Tor Browser")                 icon_result=":tor_browser:" ;;
"Transmit")                    icon_result=":transmit:" ;;
"Trello")                      icon_result=":trello:" ;;
"Vivaldi")                     icon_result=":vivaldi:" ;;
"VLC")                         icon_result=":vlc:" ;;
"VSCodium")                    icon_result=":vscodium:" ;;
"WebStorm")                    icon_result=":web_storm:" ;;
"WezTerm")                     icon_result=":wezterm:" ;;
"WhatsApp")                    icon_result=":whats_app:" ;;
"Xcode")                       icon_result=":xcode:" ;;
"Zalo")                        icon_result=":default:" ;;
"Zed")                         icon_result=":zed:" ;;
"Zen" | "Zen Browser")         icon_result=":zen_browser:" ;;
"zoom.us")                     icon_result=":zoom:" ;;
"1Password" | "1Password 7")   icon_result=":one_password:" ;;
*)                             icon_result=":default:" ;;
esac

echo "$icon_result"
