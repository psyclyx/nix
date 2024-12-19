{pkgs, ...}: let
  sketchybar = "${pkgs.sketchybar}/bin/sketchybar";
  borders = "${pkgs.jankyborders}/bin/borders";
in {
  home.file.".aerospace.toml".text = ''
        # Start AeroSpace at login
        start-at-login = true

    #    after-startup-command = ['exec-and-forget ${sketchybar}']
    #    exec-on-workspace-change = ['/bin/bash', '-c',
    #        '${sketchybar} --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE'
    #    ]

        # Normalization settings
        enable-normalization-flatten-containers = true
        enable-normalization-opposite-orientation-for-nested-containers = true

        # Accordion layout settings
        accordion-padding = 30

        # Default root container settings
        default-root-container-layout = 'tiles'
        default-root-container-orientation = 'auto'

        # Mouse follows focus settings
        on-focused-monitor-changed = ['move-mouse monitor-lazy-center']
        on-focus-changed = ['move-mouse window-lazy-center']

        # Automatically unhide macOS hidden apps
        automatically-unhide-macos-hidden-apps = true

        # Key mapping preset
        [key-mapping]
        preset = 'qwerty'

        # Gaps settings
        [gaps]
        inner.horizontal = 6
        inner.vertical =   6
        outer.left =       0
        outer.bottom =     0
        outer.top =        0
        outer.right =      0

        # Main mode bindings
        [mode.main.binding]
        # Launch applications
        alt-enter = 'exec-and-forget ${pkgs.kitty}/bin/kitty --single-instance -d ~'

        # Window management
        alt-shift-q = "close"
        alt-slash = 'layout tiles horizontal vertical'
        alt-comma = 'layout accordion horizontal vertical'
        alt-f = 'fullscreen'

        # Focus movement
        alt-h = 'focus left'
        alt-j = 'focus down'
        alt-k = 'focus up'
        alt-l = 'focus right'

        # Window movement
        alt-shift-h = 'move left'
        alt-shift-j = 'move down'
        alt-shift-k = 'move up'
        alt-shift-l = 'move right'

        # Resize windows
        alt-shift-minus = 'resize smart -50'
        alt-shift-equal = 'resize smart +50'

        # Workspace management
        alt-1 = 'workspace 1'
        alt-2 = 'workspace 2'
        alt-3 = 'workspace 3'
        alt-4 = 'workspace 4'
        alt-5 = 'workspace 5'
        alt-6 = 'workspace 6'
        alt-7 = 'workspace 7'
        alt-8 = 'workspace 8'
        alt-9 = 'workspace 9'

        # Move windows to workspaces
        alt-shift-1 = 'move-node-to-workspace 1'
        alt-shift-2 = 'move-node-to-workspace 2'
        alt-shift-3 = 'move-node-to-workspace 3'
        alt-shift-4 = 'move-node-to-workspace 4'
        alt-shift-5 = 'move-node-to-workspace 5'
        alt-shift-6 = 'move-node-to-workspace 6'
        alt-shift-7 = 'move-node-to-workspace 7'
        alt-shift-8 = 'move-node-to-workspace 8'
        alt-shift-9 = 'move-node-to-workspace 9'

        # Workspace navigation
        alt-tab = 'workspace-back-and-forth'
        alt-shift-tab = 'move-workspace-to-monitor --wrap-around next'

        # Enter service mode
        alt-shift-semicolon = 'mode service'

        # Service mode bindings
        [mode.service.binding]
        # Reload config and exit service mode
        esc = ['reload-config', 'mode main']

        # Reset layout
        r = ['flatten-workspace-tree', 'mode main']

        # Toggle floating/tiling layout
        f = ['layout floating tiling', 'mode main']

        # Close all windows but current
        backspace = ['close-all-windows-but-current', 'mode main']

        # Join with adjacent windows
        alt-shift-h = ['join-with left', 'mode main']
        alt-shift-j = ['join-with down', 'mode main']
        alt-shift-k = ['join-with up', 'mode main']
        alt-shift-l = ['join-with right', 'mode main']
  '';
}
