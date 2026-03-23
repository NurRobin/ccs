# bash completion for ccs — Claude Code Session manager

_ccs() {
    local cur prev words cword
    _init_completion || return

    local commands="new ls a attach kill gc schedule log help"
    local schedule_cmds="add ls rm log"
    local data_dir="${CCS_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/ccs}"
    local socket="${CCS_SOCKET:-ccs}"

    # Determine subcommand position
    local subcmd=""
    if (( cword >= 1 )); then
        subcmd="${words[1]}"
    fi

    case "$cword" in
        1)
            COMPREPLY=($(compgen -W "$commands --version --help -v -h" -- "$cur"))
            return ;;
    esac

    case "$subcmd" in
        a|attach|kill)
            local sessions
            sessions=$(tmux -L "$socket" list-sessions -F '#{session_name}' 2>/dev/null)
            COMPREPLY=($(compgen -W "$sessions" -- "$cur"))
            ;;
        schedule)
            if (( cword == 2 )); then
                COMPREPLY=($(compgen -W "$schedule_cmds" -- "$cur"))
            elif (( cword == 3 )) && [[ "${words[2]}" == "rm" ]]; then
                local schedules
                schedules=$(awk -F'|' '{print $1}' "$data_dir/schedules.meta" 2>/dev/null)
                COMPREPLY=($(compgen -W "$schedules" -- "$cur"))
            fi
            ;;
    esac
}

complete -F _ccs ccs
