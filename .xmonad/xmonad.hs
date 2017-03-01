import qualified Data.Map as M
import Control.Monad (liftM2)
import Data.Monoid
import Data.Maybe (maybe)
import System.IO
import System.Posix.Env (getEnv)

import XMonad
import XMonad.Config.Desktop
import XMonad.Config.Gnome
import XMonad.Config.Kde
import XMonad.Config.Xfce
import qualified XMonad.StackSet as W

import XMonad.Actions.CopyWindow
import XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize as Flex
import XMonad.Actions.FloatKeys
import XMonad.Actions.UpdatePointer
import XMonad.Actions.WindowGo
-- import XMonad.Actions.Volume

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Layout
import XMonad.Layout.Circle
import XMonad.Layout.DragPane
import XMonad.Layout.Gaps
import XMonad.Layout.LayoutScreens
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.ResizableTile
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.TwoPane
import XMonad.Layout.ThreeColumns

import XMonad.Prompt
import XMonad.Prompt.Window
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.SpawnOnce
-- import Xmonad.Util.Dzen


import Graphics.X11.ExtraTypes.XF86

myWorkspaces = ["1", "2", "3", "4", "5"]
modm = mod4Mask
myTerminal = "urxvt"

colorBlue      = "#4271f4"
colorGreen     = "#3bdb45"
colorRed       = "#db533b"
colorGray      = "#666666"
colorWhite     = "#bdbdbd"
colorNormalbg  = "#1c1c1c"
colorfg        = "#a8b6b8"

-- Border width
borderwidth = 3

mynormalBorderColor  = "#262626"
myfocusedBorderColor = "#585858"

moveWD = borderwidth
resizeWD = 2*borderwidth

gapwidth  = 6
gwU = 1
gwD = 0
gwL = 42
gwR = 42


desktop "gnome"         = gnomeConfig
desktop "kde"           = kde4Config
desktop "xfce"          = xfceConfig
desktop "xmonad-mate"   = gnomeConfig
desktop _               = desktopConfig

main :: IO()
main = do
    session <- getEnv "DESKTOP_SESSION"
    let config = maybe desktopConfig desktop session
    xmonad $ config
        { borderWidth       = borderwidth
        , terminal          = myTerminal
        , workspaces        = myWorkspaces
        , focusFollowsMouse = True
        , normalBorderColor = mynormalBorderColor
        , focusedBorderColor= myfocusedBorderColor
        , modMask           = modm
        , startupHook       = myStartupHook
        , layoutHook        = avoidStruts $ ( toggleLayouts (noBorders Full)
                                          $ myLayout
                                          )
        }

        `additionalKeysP`
        [ ("M-c"            , kill1)
        , ("M-f"            , sendMessage ToggleLayout)
        , ("M-S-f"          , withFocused (keysMoveWindow (-borderwidth,-borderwidth)))
        , ("M-C-<R>"        , withFocused (keysMoveWindow (moveWD, 0)))
        , ("M-C-<L>"        , withFocused (keysMoveWindow (-moveWD, 0)))
        , ("M-C-<U>"        , withFocused (keysMoveWindow (0, -moveWD)))
        , ("M-C-<D>"        , withFocused (keysMoveWindow (0, moveWD)))
        , ("M-<R>"          , nextWS )
        , ("M-<L>"          , prevWS )
        , ("M-l"            , nextWS )
        , ("M-h"            , prevWS )
        , ("M-S-<R>"        , shiftToNext)
        , ("M-S-<L>"        , shiftToPrev)
        , ("M-S-l"          , shiftToNext)
        , ("M-S-h"          , shiftToPrev)
        , ("M-j"            , windows W.focusDown)
        , ("M-k"            , windows W.focusUp)
        , ("M-S-j"          , windows W.swapDown)
        , ("M-S-k"          , windows W.swapUp)
        , ("M-<Tab>"        , nextScreen)
        , ("M-C-<Space>"    , layoutScreens 2 (TwoPane 0.5 0.5))
        , ("M-C-S-<Space>"  , rescreen)

        ]
 
        `additionalKeysP`
        [ ("M-<Return>"             , spawn "urxvt")
        -- Browser Start-up
        , ("M-g"                    , spawn "google-chrome-stable")
        , ("M-v"                    , spawn "vivaldi-stable")
        -- Browser Seacret Mode
        , ("M-S-g"                  , spawn "google-chrome-stable --incognito")
        , ("M-S-v"                  , spawn "vivaldi-stable --incognito")
        -- Start-up TweetDeck only
        , ("M-d"                    , spawn "chromium --app-id=hbdpomandigafcibbmofojjchbcdagbl")
        , ("M-n"                    , spawn "nocturn")
        , ("M-p"                    , spawn "exe=`dmenu_run -fn 'Migu 1M:size=20'` && exec $exe")
        -- Take a screenshot
        , ("M-S-p"                  , spawn "deepin-screenshot")
        
        -- Volumekey Setting
        , ("<XF86AudioRaiseVolume>" , spawn "amixer -c 0 set Master 2dB+")
        , ("<XF86AudioLowerVolume>" , spawn "amixer -c 0 set Master 2dB-")
        -- Display Bright Key Setting
        , ("<XF86MonBrightnessUp>"  , spawn "xbacklight + 5 -time 100 -steps 1")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight - 5 -time 100 -steps 1")

        ]

myStartupHook = do
        spawn "gnome-settings-daemon"
        spawn "nm-applet"
        spawn "$HOME/.dropbox-dist/dropboxd"
        spawn "nitrogen --restore"
        spawn "stalonetray"
        spawn "fcitx"
        spawn "xmobar ~/.xmonad/.xmobarrc"
 
myLayout = spacing gapwidth $ gaps [(U, gwU),(D, gwD),(L, gwL),(R, gwR)]
            $ (ResizableTall 1 (1/204) (119/204) [])
                ||| (TwoPane (1/204) (119/204))
                ||| (TwoPane (1/204) (149/204))
                ||| Simplest
                ||| (dragPane Horizontal (1/10) (1/2))
                ||| (dragPane Vertical   (1/10) (1/2))
                ||| Circle

