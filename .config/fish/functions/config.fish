# Command to easily update (and see diffs of) dotfiles (in ~/.cfg)
function config
    git --git-dir=$HOME/.cfg/ --work-tree=$HOME $argv
end

