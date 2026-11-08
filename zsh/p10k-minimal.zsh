# Compact Powerlevel10k layout layered over your local ~/.p10k.zsh.
# Keeps the current directory, Git state, exit status, and right-side time.
# This does not change Zsh or tmux keybindings.
typeset -ga POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs)
typeset -ga POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)
# Keep the right prompt snug to the terminal edge.
typeset -g ZLE_RPROMPT_INDENT=0
