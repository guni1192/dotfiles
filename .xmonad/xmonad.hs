import qualified Data.Map as M
import Control.Monad (liftM2)          -- myManageHookShift
import System.Posix.Env (getEnv)
import Data.Monoid
import Data.Maybe (maybe)
import System.IO                       -- for xmobar

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import qualified XMonad.StackSet as W  -- myManageHookShift

import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize as Flex -- flexible resize
import XMonad.Actions.FloatKeys
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo
-- import XMonad.Actions.Volume

import XMonad.Hooks.DynamicLog         -- for xmobar
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks        -- avoid xmobar area
import XMonad.Hooks.ManageHelpers

import XMonad.Layout
import XMonad.Layout.Circle
import XMonad.Layout.DragPane          -- see only two window
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutScreens
import XMonad.Layout.NoBorders         -- In Full mode, border is no use
import XMonad.Layout.PerWorkspace      -- Configure layouts on a per-workspace
import XMonad.Layout.ResizableTile     -- Resizable Horizontal border
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing           -- this makes smart space around windows
import XMonad.Layout.ToggleLayouts     -- Full window at any time
import XMonad.Layout.TwoPane

import XMonad.Prompt
import XMonad.Prompt.Window            -- pops up a prompt with window names
import XMonad.Util.EZConfig            -- removeKeys, additionalKeys
import XMonad.Util.Run
import XMonad.Util.Run(spawnPipe)      -- spawnPipe, hPutStrLn
import XMonad.Util.SpawnOnce
-- import Xmonad.Util.Dzen


import Graphics.X11.ExtraTypes.XF86

myWorkspaces = ["1", "2", "3", "4", "5"]
modm = mod4Mask
myTerminal = "urxvt"
baseConfig = kdeConfig

-- Color Setting
colorBlue      = "#4271f4"
colorGreen     = "#3bdb45"
colorRed       = "#db533b"
colorGray      = "#666666"
colorWhite     = "#bdbdbd"
colorNormalbg  = "#1c1c1c"
colorfg        = "#a8b6b8"

-- Border width
borderwidth = 3

-- Border color
mynormalBorderColor  = "#262626"
myfocusedBorderColor = "#585858"

-- Float window control width
moveWD = borderwidth
resizeWD = 2*borderwidth

-- gapwidth
gapwidth  = 6
gwU = 1
gwD = 0
gwL = 42
gwR = 42


desktop "gnome" = gnomeConfig
desktop "kde" = kde4Config
desktop "xfce" = xfceConfig
desktop "xmonad-mate" = gnomeConfig
desktop _ = desktopConfig

main :: IO()
main = do
    session <- getEnv "DESKTOP_SESSION"
    let config = maybe desktopConfig desktop session
    xmonad $ config
        { borderWidth       = borderwidth
        , terminal          = myTerminal
        , workspaces        = myWorkspaces
        , focusFollowsMouse  = True
        , normalBorderColor  = mynormalBorderColor
        , focusedBorderColor = myfocusedBorderColor
        , modMask           = modm
        , startupHook       = myStartupHook
        , layoutHook        = avoidStruts $ ( toggleLayouts (noBorders Full)
                                          $ myLayout
                                          )
        }

        `additionalKeysP`
        [ ("M-c"    , kill1)
        -- Toggle layout (Fullscreen mode)
        , ("M-f"    , sendMessage ToggleLayout)
        , ("M-S-f"  , withFocused (keysMoveWindow (-borderwidth,-borderwidth)))
        -- Move the focused window
        , ("M-C-<R>", withFocused (keysMoveWindow (moveWD, 0)))
        , ("M-C-<L>", withFocused (keysMoveWindow (-moveWD, 0)))
        , ("M-C-<U>", withFocused (keysMoveWindow (0, -moveWD)))
        , ("M-C-<D>", withFocused (keysMoveWindow (0, moveWD)))
        -- Go to the next / previous workspace
        , ("M-<R>"  , nextWS )
        , ("M-<L>"  , prevWS )
        , ("M-l"    , nextWS )
        , ("M-h"    , prevWS )
        -- Shift the focused window to the next / previous workspace
        , ("M-S-<R>", shiftToNext)
        , ("M-S-<L>", shiftToPrev)
        , ("M-S-l"  , shiftToNext)
        , ("M-S-h"  , shiftToPrev)
        -- Move the focus down / up
        , ("M-j"    , windows W.focusDown)
        , ("M-k"    , windows W.focusUp)
        -- Swap the focused window down / up
        , ("M-S-j"  , windows W.swapDown)
        , ("M-S-k"  , windows W.swapUp)
        -- Move the focus to next screen (multi screen)
        , ("M-<Tab>", nextScreen)
        -- Now we have more than one screen by dividing a single screen
        , ("M-C-<Space>", layoutScreens 2 (TwoPane 0.5 0.5))
        , ("M-C-S-<Space>", rescreen)

        -- , ("F11", lowerVolume 4 >> alert)
        -- , ("F12", raiseVolume 4 >> alert)
        ]
 
        -------------------------------------------------------------------- }}}
        -- Keymap: custom commands                                           {{{
        ------------------------------------------------------------------------
 
        `additionalKeysP`
        [ ("M-<Return>", spawn "urxvt")
        , ("M-g"       , spawn "google-chrome-stable")
        -- Seacret Mode
        , ("M-S-g"     , spawn "google-chrome-stable --incognito")
        -- TweetDeck
        , ("M-d"       , spawn "google-chrome-stable --app-id=hbdpomandigafcibbmofojjchbcdagbl")
        , ("M-v"       , spawn "vivaldi-stable")
        , ("M-S-v"     , spawn "vivaldi-stable --incognito")
        , ("M-n"       , spawn "nocturn")
        , ("M-p", spawn "exe=`dmenu_run -fn 'Migu 1M:size=20'` && exec $exe")
        -- Volume setting media keys
        , ("<XF86AudioRaiseVolume>", spawn "amixer -c 0 set Master 2dB+")
        , ("<XF86AudioLowerVolume>", spawn "amixer -c 0 set Master 2dB-")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight + 5 -time 100 -steps 1")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight - 5 -time 100 -steps 1")

        ]

myStartupHook = do
        spawnOnce "gnome-settings-daemon"
        spawnOnce "nm-applet"
        spawnOnce "$HOME/.dropbox-dist/dropboxd"
        spawnOnce "nitrogen --restore"
        spawnOnce "stalonetray"
        spawnOnce "fcitx"
 
myLayout = spacing gapwidth $ gaps [(U, gwU),(D, gwD),(L, gwL),(R, gwR)]
            $ (ResizableTall 1 (1/204) (119/204) [])
              ||| (TwoPane (1/204) (119/204))
              ||| (TwoPane (1/204) (149/204))
              ||| Simplest
              ||| (dragPane Horizontal (1/10) (1/2))
              ||| (dragPane Vertical   (1/10) (1/2))
              ||| Circle


