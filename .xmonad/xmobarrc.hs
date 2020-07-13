Config {
       font = "xft:Hasklig:size=12:bold:antialias=true"
       , additionalFonts = [ "xft:FontAwesome:size=11" ]
       , allDesktops = True
       , bgColor = "#262727"
       , fgColor = "#ddc7a1"
       , pickBroadest = True
       , commands = [ Run Cpu [ "--template","CPU: <total>"
       -- "--template", "<fc=#a9a1e1><fn=1></fn></fc> <total>%"
                              , "--Low","3"
                              , "--High","50"
                              , "--low","#ddc7a1"
                              , "--normal","#ddc7a1"
                              , "--high","#fb4934"] 50

                    , Run Memory ["-t","Mem: <usedratio>"
                    -- "-t","<fc=#51afef><fn=1></fn></fc> <usedratio>%"
                                 ,"-H","80"
                                 ,"-L","10"
                                 ,"-l","#ddc7a1"
                                 ,"-n","#ddc7a1"
                                 ,"-h","#fb4934"] 50

                    , Run Date "<fc=#d8a657><fn=1></fn></fc> %a %b %_d %I:%M" "date" 300
                    , Run DynNetwork ["-t","<fc=#7daea3><fn=1></fn></fc> <rx>, <fc=#d3869b><fn=1></fn></fc> <tx>"
                                     ,"-H","200"
                                     ,"-L","10"
                                     ,"-h","#ea6962"
                                     ,"-l","#ddc7a1"
                                     ,"-n","#ddc7a1"] 50

                    , Run CoreTemp [ "-t","Temp: <core0>°"
                    -- "-t", "<fc=#CDB464><fn=1></fn></fc> <core0>°"
                                   , "-L","30"
                                   , "-H","75"
                                   , "--low","#ddc7a1"
                                   , "--normal","#ddc7a1"
                                   , "--high","#ea6962"] 50

                    -- battery monitor
                    , Run BatteryP       [ "BAT0" ]
                                         [ "--template" , "<fc=#a9b665><fn=1></fn></fc> <acstatus>"
                                         , "--Low"      , "10"
                                         , "--High"     , "80"
                                         , "--low"      , "#ea6962"
                                         , "--normal"   , "#ddc7a1"
                                         , "--high"     , "#a9b665"

                                         , "--" -- battery specific options
                                                   -- discharging status
                                                   , "-o"   , "<left>% (<timeleft>)"
                                                   -- AC "on" status
                                                   , "-O"   , "<left>% (<fc=#98be65>Charging</fc>)" -- 50fa7b
                                                   -- charged status
                                                   , "-i"   , "<fc=#a9b665>Charged</fc>"
                                         ] 50
                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ %cpu% | %coretemp% | %memory% | %battery% | %dynnetwork% | %date%"
       }
