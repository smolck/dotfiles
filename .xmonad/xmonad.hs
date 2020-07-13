{-# LANGUAGE OverloadedStrings #-}

-- xmonad config used by Malcolm MD
-- https://github.com/randomthought/xmonad-config

import           System.IO
import           System.Exit

import           Data.List                      ( isInfixOf )
import           Data.Text                      ( replace
                                                , unpack
                                                , pack
                                                , splitOn
                                                , Text
                                                )

import           XMonad
import           XMonad.Actions.Navigation2D
import           XMonad.Actions.UpdatePointer

import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.SetWMName
import           XMonad.Hooks.EwmhDesktops      ( ewmh )

import           XMonad.Layout.IndependentScreens
import           XMonad.Layout.Gaps
import           XMonad.Layout.Fullscreen
import           XMonad.Layout.BinarySpacePartition
                                               as BSP
import           XMonad.Layout.NoBorders
import           XMonad.Layout.Tabbed
import           XMonad.Layout.Spacing
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoFrillsDecoration
import           XMonad.Layout.Renamed
import           XMonad.Layout.Simplest
import           XMonad.Layout.SubLayouts
import           XMonad.Layout.WindowNavigation
import           XMonad.Layout.ZoomRow          ( )

import           XMonad.Util.Run                ( spawnPipe )
import           XMonad.Util.Cursor

import           Graphics.X11.ExtraTypes.XF86
import qualified XMonad.StackSet               as W
import qualified Data.Map                      as M


-----------------------------------------------------------------------------
-- my*'s
--
--
-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
-- myTerminal = "alacritty"
myTerminal = "st"

myBrowser = "chromium"

-- The command to lock the screen or show the screensaver.
myScreensaver = "dm-tool switch-to-greeter"

-- The command to take a selective screenshot, where you select
-- what you'd like to capture on the screen.
-- mySelectScreenshot = "select-screenshot"

-- The command to take a fullscreen screenshot.
myScreenshot = "xfce4-screenshooter"

-- The command to use as a launcher, to launch commands that don't have
-- preset keybindings.
myLauncher = "rofi -show drun -theme gruvbox-dark-soft"



------------------------------------------------------------------------
-- Workspaces
-- The default number of workspaces (virtual screens) and their names.
--
-- myWorkspaces = ["1:<name>", "2:<name>", "3", "4"] ++ map show [5 .. 9]


------------------------------------------------------------------------
-- Window rules
-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
  [ className =? "Google-chrome" --> doShift "2:web"
  , resource =? "desktop_window" --> doIgnore
  , className =? "Galculator" --> doCenterFloat
  , className =? "Steam" --> doCenterFloat
  , className =? "Gimp" --> doCenterFloat
  , resource =? "gpicview" --> doCenterFloat
  , className =? "MPlayer" --> doCenterFloat
  , className =? "Pavucontrol" --> doCenterFloat
  , className =? "Mate-power-preferences" --> doCenterFloat
  , className =? "Xfce4-power-manager-settings" --> doCenterFloat
  , className =? "VirtualBox" --> doShift "4:vm"
  , className =? "Xchat" --> doShift "5:media"
  , className =? "stalonetray" --> doIgnore
  , isFullscreen --> (doF W.focusDown <+> doFullFloat)
    -- , isFullscreen                             --> doFullFloat
  ]



------------------------------------------------------------------------
-- Layouts
-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.

outerGaps = 10

myGaps = gaps [(U, outerGaps), (R, outerGaps), (L, outerGaps), (D, outerGaps)]

addSpace =
  renamed [CutWordsLeft 2]
    . spacingRaw
                 -- borders not applied when fewer than two windows? (smart border)
                 False
                 (Border 5 5 5 5) -- screen border
                 True             -- screen border enabled?
                 (Border 5 5 5 5) -- window border
                 True             -- window border enabled?

tab = avoidStruts $ renamed [Replace "Tabbed"] $ addTopBar $ myGaps $ tabbed
  shrinkText
  myTabTheme

layouts = avoidStruts
  (   ( renamed [CutWordsLeft 1]
      $ addTopBar
      $ windowNavigation
      $ renamed [Replace "BSP"]
      $ addTabs shrinkText myTabTheme
      $ subLayout [] Simplest
      $ myGaps
      $ addSpace (BSP.emptyBSP)
      )
  ||| tab
  )

myLayout = smartBorders $ mkToggle (NOBORDERS ?? FULL ?? EOT) $ layouts

myNav2DConf = def { defaultTiledNavigation = centerNavigation
                  , floatNavigation        = centerNavigation
                  , screenNavigation       = lineNavigation
                  , layoutNavigation       = [("Full", centerNavigation)]
                  , unmappedWindowRect     = [("Full", singleWindowRect)]
                  }


------------------------------------------------------------------------
-- Colors and borders
--
-- Width of the window border in pixels.
myBorderWidth = 0

myNormalBorderColor = "#000000"
myFocusedBorderColor = active

fg = "#ddc7a1"
base0 = "#191a1a"
base2 = "#32302f"
base3 = "#383432"
yellow = "#d8a657"
red = "#ea6962"
blue = "#7daea3"
-- bg = "#262727"
-- base1 = "#202121"
-- orange = "#e78a4e"
-- purple = "#d3869b"
-- green = "#a9b665"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = blue

topbar = 5

active = blue
-- activeWarn = red
-- inactive = base2
-- focusColor = blue
-- unfocusColor = base2

myFont = "xft:Hasklig:size=9:bold:antialias=true"

-- this is a "fake title" used as a highlight bar in lieu of full borders
-- (I find this a cleaner and less visually intrusive solution)
topBarTheme = def { fontName            = myFont
                  , inactiveBorderColor = base3
                  , inactiveColor       = base3
                  , inactiveTextColor   = base3
                  , activeBorderColor   = active
                  , activeColor         = active
                  , activeTextColor     = active
                  , urgentBorderColor   = red
                  , urgentTextColor     = yellow
                  , decoHeight          = topbar
                  }

addTopBar = noFrillsDeco shrinkText topBarTheme

myTabTheme = def { fontName            = myFont
                 , activeColor         = active
                 , inactiveColor       = base2
                 , activeBorderColor   = active
                 , inactiveBorderColor = base2
                 , activeTextColor     = base3
                 , inactiveTextColor   = base0
                 }

------------------------------------------------------------------------
-- Key bindings
--
-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask = mod4Mask

myKeys conf@(XConfig { XMonad.modMask = modMask' }) =
  M.fromList
    $
  ----------------------------------------------------------------------
  -- Custom key bindings
  --
         -- Start a terminal.  Terminal to start is specified by myTerminal variable.
       [ ((modMask', xK_Return), spawn $ XMonad.terminal conf)
       , ( (modMask' .|. shiftMask, xK_p)
         , spawn myBrowser
         )

         -- Lock the screen using command specified by myScreensaver.
       , ( (modMask', xK_0)
         , spawn myScreensaver
         )

         -- Spawn the launcher using command specified by myLauncher.
         -- Use this to launch programs without a key binding.
       , ( (modMask', xK_a)
         , spawn myLauncher
         )

  -- Take a selective screenshot using the command specified by mySelectScreenshot.
  -- , ((modMask' .|. shiftMask, xK_p),
  --     spawn mySelectScreenshot)

         -- Take a full screenshot using the command specified by myScreenshot.
       , ( (modMask' .|. controlMask .|. shiftMask, xK_p)
         , spawn myScreenshot
         )

         -- Toggle current focus window to fullscreen
       , ( (modMask', xK_f)
         , sendMessage $ Toggle FULL
         )

         -- Mute volume.
       , ( (0, xF86XK_AudioMute)
         , spawn "amixer -q set Master toggle"
         )

         -- Decrease volume.
       , ( (0, xF86XK_AudioLowerVolume)
         , spawn "amixer -q set Master 5%-"
         )

         -- Increase volume.
       , ( (0, xF86XK_AudioRaiseVolume)
         , spawn "amixer -q set Master 5%+"
         )

         -- Audio previous.
       , ( (0, 0x1008FF16)
         , spawn ""
         )

         -- Play/pause.
       , ( (0, 0x1008FF14)
         , spawn ""
         )

         -- Audio next.
       , ( (0, 0x1008FF17)
         , spawn ""
         )

         -- Eject CD tray.
       , ( (0, 0x1008FF2C)
         , spawn "eject -T"
         )

  --------------------------------------------------------------------

         -- Close focused window.
       , ( (modMask' .|. shiftMask, xK_q)
         , kill
         )

         -- Cycle through the available layout algorithms.
       , ( (modMask', xK_space)
         , withFocused $ windows . W.sink
         )

         -- Reset the layouts on the current workspace to default.
       , ( (modMask' .|. shiftMask, xK_space)
         , sendMessage NextLayout
         )

         -- Resize viewed windows to the correct size.
       , ( (modMask', xK_n)
         , refresh
         )

         -- Move focus to the next window.
       , ( (modMask', xK_l)
         , windows W.focusDown
         )

         -- Move focus to the previous window.
       , ( (modMask', xK_h)
         , windows W.focusUp
         )

         -- Move focus to the master window.
       , ( (modMask', xK_m)
         , windows W.focusMaster
         )

  -- Swap the focused window and the master window.
  -- , ((modMask', xK_Return),
  --    windows W.swapMaster)

         -- Swap the focused window with the next window.
       , ( (modMask' .|. shiftMask, xK_j)
         , windows W.swapDown
         )

         -- Swap the focused window with the previous window.
       , ( (modMask' .|. shiftMask, xK_k)
         , windows W.swapUp
         )

  -- Shrink the master area.
  -- , ((modMask', xK_h),
  -- sendMessage Shrink)

  -- Expand the master area.
  -- , ((modMask', xK_l),
  --    sendMessage Expand)

         -- Push window back into tiling.
       , ( (modMask', xK_t)
         , withFocused $ windows . W.sink
         )

         -- Increment the number of windows in the master area.
       , ( (modMask', xK_comma)
         , sendMessage (IncMasterN 1)
         )

         -- Decrement the number of windows in the master area.
       , ( (modMask', xK_period)
         , sendMessage (IncMasterN (-1))
         )

         -- Toggle the status bar gap.
         -- TODO: update this binding with avoidStruts, ((modMask', xK_b),

         -- Suspend computer.
       , ( (modMask' .|. shiftMask, xK_s)
         , spawn "systemctl suspend"
         )

         -- Quit xmonad.
       , ( (modMask' .|. shiftMask, xK_e)
         , io (exitWith ExitSuccess)
         )

         -- Restart xmonad.
       , ((modMask', xK_q), restart "xmonad" True)
       ]
    ++

         -- mod-[1..9], Switch to workspace N
         -- mod-shift-[1..9], Move client to workspace N
       [ ((m .|. modMask', k), windows $ onCurrentScreen f i)
       | (i, k) <- zip (workspaces' conf) [xK_1 .. xK_9]
       , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
       ]
    ++

       -- Bindings for manage sub tabs in layouts please checkout the link below for reference
       -- https://hackage.haskell.org/package/xmonad-contrib-0.13/docs/XMonad-Layout-SubLayouts.html
       [
         -- Tab current focused window with the window to the left
         ( (modMask' .|. controlMask, xK_h)
         , sendMessage $ pullGroup L
         )

         -- Tab current focused window with the window to the right
       , ( (modMask' .|. controlMask, xK_l)
         , sendMessage $ pullGroup R
         )

         -- Tab current focused window with the window above
       , ( (modMask' .|. controlMask, xK_k)
         , sendMessage $ pullGroup U
         )

         -- Tab current focused window with the window below
       , ( (modMask' .|. controlMask, xK_j)
         , sendMessage $ pullGroup D
         )

         -- Tab all windows in the current workspace with current window as the focus
       , ( (modMask' .|. controlMask, xK_m)
         , withFocused (sendMessage . MergeAll)
         )

         -- Group the current tabbed windows
       , ( (modMask' .|. controlMask, xK_u)
         , withFocused (sendMessage . UnMerge)
         )

         -- Toggle through tabs from the right
       , ((modMask', xK_Tab), onGroup W.focusDown')
       ]

    ++
         -- Some bindings for BinarySpacePartition
         -- https://github.com/benweitzman/BinarySpacePartition
       [ ((modMask' .|. controlMask, xK_Right), sendMessage $ ExpandTowards R)
       , ( (modMask' .|. controlMask .|. shiftMask, xK_Right)
         , sendMessage $ ShrinkFrom R
         )
       , ((modMask' .|. controlMask, xK_Left), sendMessage $ ExpandTowards L)
       , ( (modMask' .|. controlMask .|. shiftMask, xK_Left)
         , sendMessage $ ShrinkFrom L
         )
       , ((modMask' .|. controlMask, xK_Down), sendMessage $ ExpandTowards D)
       , ( (modMask' .|. controlMask .|. shiftMask, xK_Down)
         , sendMessage $ ShrinkFrom D
         )
       , ((modMask' .|. controlMask, xK_Up), sendMessage $ ExpandTowards U)
       , ( (modMask' .|. controlMask .|. shiftMask, xK_Up)
         , sendMessage $ ShrinkFrom U
         )
       , ((modMask', xK_r), sendMessage BSP.Rotate)
       , ((modMask', xK_s), sendMessage BSP.Swap)
  -- , ((modMask',                               xK_n     ), sendMessage BSP.FocusParent)
  -- , ((modMask' .|. controlMask,               xK_n     ), sendMessage BSP.SelectNode)
  -- , ((modMask' .|. shiftMask,                 xK_n     ), sendMessage BSP.MoveNode)
       ]

------------------------------------------------------------------------
-- Mouse bindings
--
-- Focus rules
-- True if your focus should follow your mouse cursor.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myMouseBindings (XConfig { XMonad.modMask = modMask' }) =
  M.fromList
    $ [
        -- mod-button1, Set the window to floating mode and move by dragging
        ( (modMask', button1)
        , (\w -> focus w >> mouseMoveWindow w)
        )

        -- mod-button2, Raise the window to the top of the stack
      , ( (modMask', button2)
        , (\w -> focus w >> windows W.swapMaster)
        )

        -- mod-button3, Set the window to floating mode and resize by dragging
      , ((modMask', button3), (\w -> focus w >> mouseResizeWindow w))

        -- you may also bind events to the mouse scroll wheel (button4 and button5)
      ]


------------------------------------------------------------------------
-- Status bars and logging
-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--


------------------------------------------------------------------------
-- Startup hook
-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = do
  setWMName "LG3D"
  spawn "bash ~/.xmonad/startup.sh"
  setDefaultCursor xC_left_ptr

-- See https://github.com/pkrog/public-config/blob/365904a0a396ec295aab45e12b00c3381a675ea9/xmonad/xmonad.hs
-- Adapted multi-monitor config from there.
xmobarCommand :: Int -> String
xmobarCommand x = "xmobar -x " ++ show x ++ " ~/.xmonad/xmobarrc.hs"

pp :: Handle -> Int -> PP
pp h screenId = xmobarPP
  { ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
  , ppVisible = xmobarColor fg ""
  , ppTitle   = shorten 50
  , ppSep     = " | "
  , ppOutput  =
    (\strOut ->
      let (x : xs)           = splitOn " | " $ pack strOut
          filteredWorkspaces = filterWorkspaces $ unpack x
      in  hPutStrLn h $ concat
            [filteredWorkspaces, mconcat $ map ((" | " ++) . unpack) xs]
    )
  }
 where
  -- Probably inefficient and unnecessary, but takes "0_1 0_2 1_2 1_3 1_4 ..." and turns
  -- it into "2 3 4 ..." assuming the screen (`s`) is 1.
  -- So overall, this filters out the other screen's workspaces and tidies things up.
  filterWorkspaces :: String -> String
  filterWorkspaces =
    unwords
      . map (unpack . replace screenId' "" . pack)
      . filter (isInfixOf $ unpack screenId')
      . words

  screenId' :: Text
  screenId' = pack $ show screenId ++ "_"

------------------------------------------------------------------------
-- Run xmonad with all the defaults we set up.
--
main = do
  nScreens <- countScreens
  xmprocs  <- mapM (spawnPipe . xmobarCommand) [0 .. nScreens - 1]
  -- xmproc <- spawnPipe "taffybar"

  xmonad
    $ docks
    $ withNavigation2DConfig myNav2DConf
    $ additionalNav2DKeys
        (xK_Up, xK_Left, xK_Down, xK_Right)
        [(mod4Mask, windowGo), (mod4Mask .|. shiftMask, windowSwap)]
        False
    $ ewmh
    $ defaults
        { workspaces = withScreens 2 (workspaces defaults)
        , logHook    = ( mapM_ dynamicLogWithPP
                       $ zipWith pp xmprocs [0 .. nScreens - 1]
                       )
                         >> updatePointer (0.75, 0.75) (0.75, 0.75)
        }

------------------------------------------------------------------------
-- Combine it all together
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--
defaults = def {
               -- simple stuff
                 terminal           = myTerminal
               , focusFollowsMouse  = myFocusFollowsMouse
               , borderWidth        = myBorderWidth
               , modMask            = myModMask
               , normalBorderColor  = myNormalBorderColor
               , focusedBorderColor = myFocusedBorderColor

               -- key bindings
               , keys               = myKeys
               , mouseBindings      = myMouseBindings

               -- hooks, layouts
               , layoutHook         = myLayout
               , handleEventHook    = fullscreenEventHook
               , manageHook         = manageDocks <+> myManageHook
               , startupHook        = myStartupHook
               }
