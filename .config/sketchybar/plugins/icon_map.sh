#!/bin/bash

case "$1" in
"App Store")                                  icon_result=":app_store:" ;;
"Bitwarden")                                  icon_result=":bit_warden:" ;;
"Calendar")                                   icon_result=":calendar:" ;;
"Google Chrome")                              icon_result=":google_chrome:" ;;
"Cursor" | "Code")                            icon_result=":code:" ;;
"Discord" | "Vesktop")                        icon_result=":discord:" ;;
"Docker" | "Docker Desktop")                  icon_result=":docker:" ;;
"OrbStack")                                   icon_result=":orbstack:" ;;
"Drafts")                                     icon_result=":drafts:" ;;
"FaceTime")                                   icon_result=":face_time:" ;;
"Finder")                                     icon_result=":finder:" ;;
"Ghostty")                                    icon_result=":ghostty:" ;;
"Warp")                                       icon_result=":warp:" ;;
"Helium")                                     icon_result=":helium:" ;;
"Mail")                                       icon_result=":mail:" ;;
"Messages")                                   icon_result=":messages:" ;;
"Microsoft Edge")                             icon_result=":microsoft_edge:" ;;
"Microsoft Excel")                            icon_result=":microsoft_excel:" ;;
"Microsoft PowerPoint")                       icon_result=":microsoft_power_point:" ;;
"Microsoft Teams" | "Microsoft Teams (PWA)")  icon_result=":microsoft_teams:" ;;
"Music")                                      icon_result=":music:" ;;
"Notes")                                      icon_result=":notes:" ;;
"Notion")                                     icon_result=":notion:" ;;
"Obsidian")                                   icon_result=":obsidian:" ;;
"Podcasts")                                   icon_result=":podcasts:" ;;
"Postman")                                    icon_result=":postman:" ;;
"Preview")                                    icon_result=":pdf:" ;;
"Reminders")                                  icon_result=":reminders:" ;;
"Safari")                                     icon_result=":safari:" ;;
"Slack")                                      icon_result=":slack:" ;;
"Spotify")                                    icon_result=":spotify:" ;;
"System Preferences" | "System Settings")     icon_result=":gear:" ;;
"Xcode")                                      icon_result=":xcode:" ;;
"Zalo")                                       icon_result=":default:" ;;
"Zed")                                        icon_result=":zed:" ;;
"Zen" | "Zen Browser")                        icon_result=":zen_browser:" ;;
*)                                            icon_result=":default:" ;;
esac

echo "$icon_result"
