$env.config.show_banner = false
$env.config.buffer_editor = "code"
$env.PROMPT_COMMAND_RIGHT = ""
# Opening a tab in the same directory in Windows Terminal
$env.config.hooks.env_change = ($env.config.hooks.env_change | upsert PWD {|config|
    let val = $config.PWD? | default []

    $val | append {|_, after|
        mut val = $after

        if not ($env.IS_WSL? | is-empty) {
            $val = (wslpath -w $val)
        }

        print -n $"(ansi -o '9;9;')($val)(ansi "st")"
    }
})
