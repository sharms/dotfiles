import System.IO
import System.Exit
import XMonad
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.ManageHook
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig (additionalKeys)
import Graphics.X11.ExtraTypes.XF86  

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ defaultConfig
    { terminal = myTerminal
    , modMask  = myModMask
    , borderWidth = myBorderWidth
    , manageHook = myManageHook <+> manageHook defaultConfig
    , workspaces = myWorkspaces
    , layoutHook = smartBorders $ myLayout
    , startupHook = setWMName "LG3D"
    , handleEventHook = fullscreenEventHook <+> docksEventHook
    , logHook = dynamicLogWithPP $ xmobarPP {
            ppOutput = hPutStrLn xmproc
          , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
          , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
          , ppSep = "   "}
    } `additionalKeys`
    [ ((mod4Mask .|. shiftMask, xK_z), spawn "gnome-screensaver-command --lock")
    , ((0, xK_Print), spawn "gnome-screenshot")
    , ((mod4Mask, xK_a), spawn "urxvt -title alsamixer -name alsamixer -e alsamixer")
    , ((mod4Mask, xK_i), spawn "urxvt -title irssi -name irssi -e irssi")
    , ((0, xF86XK_MonBrightnessUp), spawn "xbacklight +10")
    , ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -10")
    , ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master playback 5%+")
    , ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master playback 5%-")
    , ((0, xF86XK_AudioMute), spawn "amixer set Master toggle")
    ]

xmobarTitleColor = "#FFB6B0"
xmobarCurrentWorkspaceColor = "#CEFFAC"
myTerminal = "urxvt"
myModMask = mod4Mask
myBorderWidth = 1
myWorkspaces = ["1:term", "2:web", "3:code", "4:vm", "5:media"] ++ map show [6..9]

myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    tabbed shrinkText tabConfig |||
    Full |||
    spiral (6/7)) |||
    noBorders (fullscreenFull Full)

myManageHook = composeAll [ resource =? "dmenu" --> doFloat
                          , resource =? "steam" --> doFloat
                          , resource =? "wicd-client.py" --> doFloat
                          , resource =? "feh"   --> doIgnore
                          , resource =? "transmission" --> doShift(myWorkspaces !! 2)
                          , resource =? "thunar" --> doShift(myWorkspaces !! 2)
                          , resource =? "chromium" --> doShift(myWorkspaces !! 1)
                          , manageDocks]

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig = defaultTheme {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

