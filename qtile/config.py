import os
from os import path
from collections.abc import Callable
import libqtile.resources
from libqtile import bar, layout, qtile, widget, hook
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Output, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import json
import subprocess

qtile_path = path.join(path.expanduser('~'), ".config", "qtile")
bg = path.join(qtile_path, "bg_main.jpg")
theme_file = path.join(qtile_path, "themes", "noahs-arch.json")

with open(theme_file, "r") as f:
    colors = json.load(f)

## FUNCTIONS 
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call(home)

mod = "mod4"
terminal = guess_terminal()

##BINDINGS
keys = [

    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),

    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "shift"], "Return", lazy.spawn("rofi -show drun"), desc="Launch Rofi DRun"),
    Key([mod, "control"], "Return", lazy.spawn("rofi -show run"), desc="Launch Rofi Run"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "Tab", lazy.prev_layout(), desc="Toggle between layouts"),

    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="Toggle fullscreen on the focused window",
    ),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating on the focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    
    ##GROUP KEYPAD BIND
    Key([mod], "ampersand", lazy.group["1"].toscreen()),
    Key([mod], "eacute", lazy.group["2"].toscreen()),
    Key([mod], "quotedbl", lazy.group["3"].toscreen()),
    Key([mod], "apostrophe", lazy.group["4"].toscreen()),
    Key([mod], "parenleft", lazy.group["5"].toscreen()),
    
    Key([mod, "Shift"], "ampersand", lazy.window.togroup("1")),
    Key([mod, "Shift"], "eacute", lazy.window.togroup("2")),
    Key([mod, "Shift"], "quotedbl", lazy.window.togroup("3")),
    Key([mod, "Shift"], "apostrophe", lazy.window.togroup("4")),
    Key([mod, "Shift"], "parenleft", lazy.window.togroup("5")),

    ##CHORD
    #KeyChord([mod, "Shift"], "a", [
    #    ],
    #    mode=True,
    #    name="Group navigation"
    #),

    #user defined
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "q", lazy.spawn("firefox-esr"), desc="Launch Firefox"),
    Key([mod], "c", lazy.spawn("alacritty -e mc"), desc="Launch Midnight Commander"),
    Key([mod], "s", lazy.spawn("sh /usr/sbin/rofipowermenu.sh"), desc="Script Rofi Power Menu"),
    Key([mod], "n", lazy.spawn("sh /usr/sbin/rofinotes.sh"), desc="Script Rofi Notes"),
    Key([mod, "control"], "p", lazy.spawn("sh /usr/sbin/rofimusicplayer.sh"), desc="Script Rofi MPC Music player"),
    Key([mod, "shift"], "p", lazy.spawn("alacritty -e rmpc"), desc="Launch Rmpc"),
    Key([mod], "p", lazy.spawn("sh /usr/sbin/rofimpchud.sh"), desc="Script Rofi rmpc HUD"),
    Key([mod], "a", lazy.spawn("rofi -show window"), desc="Launch Rofi Window"),
]

##LAYOUTS

layout_conf = {
    'border_focus': colors['color1'][0],
    'border_width': 2,
    'margin': 0,
}

layouts = [
    layout.RatioTile(**layout_conf),
    layout.Columns(**layout_conf),
    layout.Max(),
    layout.Tile(**layout_conf),
]

##WIDGETS
widget_defaults = dict(
    font="sans",
    fontsize=14,
    padding=8,
    foreground=colors['text'][0],
)
extension_defaults = widget_defaults.copy()

widget_list = [
    widget.CurrentLayout(
		background=colors['color3'][0],),
    widget.Prompt(
		background=colors['color2'][0],),
    widget.GroupBox(
        background=colors['active'][0],
        foreground=colors['color1'][0],
        inactive=colors['dark'][0],
        active=colors['text'][0],
        highlight_method='text',),
	widget.GenPollCommand(
		background=colors['inactive'][0],
		cmd='song="$(mpc current)"; if [ "$song" ]; then echo "$song"; else echo No Song; fi',
		fmt="> {}",
		shell=True,
		update_interval=2,),
    widget.Chord(

        chords_colors={
            "launch": (colors['dark'][0], colors['text'][0]),
        },
        background=colors['color1'][0],
    ),
    widget.WindowName(
	    background=colors['dark'][0],),
	widget.Clipboard(
		background=colors['color2'][0],),
    widget.TextBox(
		"la seine", 
		name="noah", 
		background=colors['color1'][0],),
    widget.Systray(background=colors['color3'][0]),
    widget.Clock(
		format="%Y-%m-%d %a %I:%M %p",
		background=colors['inactive'][0]),
    widget.QuickExit(
		background=colors['active'][0],
		default_text='[X]'),
]

##GROUPS

groups = [
    Group(name='1'),
    Group(name='2'),
    Group(name='3'),
    Group(name='4'),
    Group(name='5'),
]

##SCREENS
screens = [
    Screen(
        top=bar.Bar(
            widget_list,
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        background=colors['grey'][0],
        wallpaper=bg,
        wallpaper_mode="center",
    ),
]

##OPTIONS
# Instead of screens, you can define a function here to specify which Screen
# should correspond to which Output.
fake_screens: list[Screen] | None = None

# Instead of screens or fake screens, you can define a function here that
# returns a list of Screen objects based on the list of Outputs; that way you
# can decide based on e.g. the number of screens, or which ports are plugged
# in exactly what do render in each bar for each screen.
generate_screens: Callable[[list[Output]], list[Screen]] | None = None

##FLOATING LAYOUT BEHAVIOUR
# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

##GENERAL
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
floats_kept_above = True
cursor_warp = True
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="Qalculate!"),
        Match(title="LocalSend"),
    ]
)

auto_fullscreen = True
focus_on_window_activation = "smart"
focus_previous_on_window_remove = False
reconfigure_screens = True
# How long (in seconds) to wait after a screen change event before firing the
# screen_change hook, coalescing bursts of events into a single one.
screen_change_debounce_timeout = 1
# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True
# xcursor theme (string or None) and size (integer) for Wayland backend
wl_xcursor_theme = None
wl_xcursor_size = 24

idle_timers = []  # type: list
idle_inhibitors = []  # type: list
wmname = "LG3D"
