
--
-- XMonad 
--
-- The file. The config. The wm.
--

import XMonad

import qualified Data.Map as M

import XMonad.Config.Desktop
import XMonad.Config.Xfce

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops

import XMonad.Actions.PhysicalScreens
import XMonad.Actions.Plane

import XMonad.Layout.IndependentScreens
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace

import XMonad.ManageHook

import qualified XMonad.StackSet as W


myWorkspaces = ["1","2","3","4","5","6","7","8","9","0"]

myKeys (XConfig {XMonad.modMask = modm}) = M.fromList $
  [
   ((modm .|. mask, key), f sc) | (key, sc) <- zip [xK_e, xK_w, xK_q] [0..],
   (f, mask) <- [(viewScreen, 0), (sendToScreen, shiftMask)]
  ]
  ++
  [
   ((m .|. modm, k), windows $ onCurrentScreen f i) | (i, k) <- zip myWorkspaces [xK_1 .. xK_9],
   (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
  ]
  ++
  [
   ((0,xK_F10), spawn "pactl -- set-sink-mute 1 toggle"),
   ((0,xK_F11), spawn "pactl -- set-sink-volume 1 -5%"),
   ((0,xK_F12), spawn "pactl -- set-sink-volume 1 +5%")
  ]


myManageHook = composeAll
  [
    className =? "Xfce4-notifyd" --> doF W.focusDown,
    manageDocks
  ]


myConfig = xfceConfig {
  terminal     = "urxvt",
  workspaces   = withScreens 3 myWorkspaces,
  keys         = myKeys <+> keys desktopConfig
}


main = xmonad myConfig {
  manageHook   = myManageHook <+> manageHook defaultConfig,
  logHook      = ewmhDesktopsLogHook,
  layoutHook   = avoidStruts $ layoutHook defaultConfig,
  startupHook  = ewmhDesktopsStartup
}

