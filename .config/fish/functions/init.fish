function init
    set PATH $HOME/go/bin $HOME/.cargo/bin $HOME/.local/bin $HOME/.yarn/bin $HOME/.pub-cache/bin $HOME/flutter/bin $HOME/dev/go/bin $PATH
    set -g -x GOPATH $HOME/dev/go

    eval (luarocks path)

    set -g -x EDITOR nvim

    # For Java apps on Wayland to work do
    # export _JAVA_AWT_WM_NONREPARENTING=1

    set -g -x XDG_CONFIG_HOME "$HOME/.config"

    # For Chromium [-based] browsers
    set -g -x MESA_GLSL_CACHE_DISABLE true

    set -g -x ANDROID_HOME $HOME/.android-sdk

    python ~/dev/python/dailyverses/__init__.py
    set -g -x VERSEOFDAY (python ~/dev/python/dailyverses/read_verse.py)
end
