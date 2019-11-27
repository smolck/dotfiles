###### Previous Prompt
# function fish_prompt --description 'Write out the prompt'
# 	set -l last_status $status
#     set -l normal (set_color normal)
#
#     # Hack; fish_config only copies the fish_prompt function (see #736)
#     if not set -q -g __fish_classic_git_functions_defined
#         set -g __fish_classic_git_functions_defined
#
#         function __fish_repaint_user --on-variable fish_color_user --description "Event handler, repaint when fish_color_user changes"
#             if status --is-interactive
#                 commandline -f repaint 2>/dev/null
#             end
#         end
#
#         function __fish_repaint_host --on-variable fish_color_host --description "Event handler, repaint when fish_color_host changes"
#             if status --is-interactive
#                 commandline -f repaint 2>/dev/null
#             end
#         end
#
#         function __fish_repaint_status --on-variable fish_color_status --description "Event handler; repaint when fish_color_status changes"
#             if status --is-interactive
#                 commandline -f repaint 2>/dev/null
#             end
#         end
#
#         function __fish_repaint_bind_mode --on-variable fish_key_bindings --description "Event handler; repaint when fish_key_bindings changes"
#             if status --is-interactive
#                 commandline -f repaint 2>/dev/null
#             end
#         end
#
#         # initialize our new variables
#         if not set -q __fish_classic_git_prompt_initialized
#             set -qU fish_color_user
#             or set -U fish_color_user -o green
#             set -qU fish_color_host
#             or set -U fish_color_host -o cyan
#             set -qU fish_color_status
#             or set -U fish_color_status red
#             set -U __fish_classic_git_prompt_initialized
#         end
#     end
#
#     set -l color_cwd
#     set -l prefix
#     set -l suffix
#     switch "$USER"
#         case root toor
#             if set -q fish_color_cwd_root
#                 set color_cwd $fish_color_cwd_root
#             else
#                 set color_cwd $fish_color_cwd
#             end
#             set suffix '#'
#         case '*'
#             set color_cwd $fish_color_cwd
#             set suffix '>'
#     end
#
#     set -l prompt_status
#     if test $last_status -ne 0
#         set prompt_status ' ' (set_color $fish_color_status) "[$last_status]" "$normal"
#     end
#
#     echo -n -s (set_color $fish_color_user) "$USER" $normal @ (set_color $fish_color_host) (prompt_hostname) $normal ' ' (set_color $color_cwd) (prompt_pwd) $normal (__fish_vcs_prompt) $normal $prompt_status $suffix " "
# end
######################

# Pure Prompt from https://github.com/brandonweiss/pure.fish
set fish_prompt_pwd_dir_length 0

# Git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch 242
set __fish_git_prompt_color_dirtystate FCBC47
set __fish_git_prompt_color_stagedstate green
set __fish_git_prompt_color_upstream cyan

# Git Characters
set __fish_git_prompt_char_dirtystate '*'
set __fish_git_prompt_char_stagedstate '⇢'
set __fish_git_prompt_char_upstream_prefix ' '
set __fish_git_prompt_char_upstream_equal ''
set __fish_git_prompt_char_upstream_ahead '⇡'
set __fish_git_prompt_char_upstream_behind '⇣'
set __fish_git_prompt_char_upstream_diverged '⇡⇣'

function _print_in_color
  set -l string $argv[1]
  set -l color  $argv[2]

  set_color $color
  printf $string
  set_color normal
end

function _prompt_color_for_status
  if test $argv[1] -eq 0
    echo magenta
  else
    echo red
  end
end

function fish_prompt
  set -l last_status $status

  _print_in_color "\n"(prompt_pwd) blue

  __fish_git_prompt " %s"

  _print_in_color "\n❯ " (_prompt_color_for_status $last_status)
end
