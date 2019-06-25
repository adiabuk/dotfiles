_ssh()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | grep -v '[?*]' | cut -d ' ' -f 2-)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}
complete -F _ssh ssh

complete -W "$(cat ~/.hosts|awk {'print $2'})" ssh
complete -W "$(cat ~/.hosts|awk {'print $2'})" scp
complete -W "$(cat ~/.hosts|awk {'print $2'})" ping
complete -W "$(cat ~/.hosts|awk {'print $2'})" aws_lookup
