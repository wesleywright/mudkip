{ pkgs, ... }:

{
  programs.fish = {
    enable = true;

    functions = {
      __git_upstream_configured = {
        body = ''
          git rev-parse --abbrev-ref @"{u}" >/dev/null 2>&1
        '';
      };

      __print_color = {
        body = ''
          set -l color  $argv[1]
          set -l string $argv[2]

          set -l string_count (echo -n "$string" | wc -c)

          if test "$string_count" -eq 0
              return
          end

          set -l new_total (math "$string_count + $__prompt_count + 1")

          if test "$new_total" -ge "$COLUMNS"
              printf '\n'

              if test "$string_count" -ge "$COLUMNS"
                  set -l safe (math "$COLUMNS - 1")
                  set -l text (math "$safe - 3")
                  set string (echo $string | sed -E 's/(.{'"$text"'})(.{1,})$/\1.../')
                  set new_total "$safe"
              else
                  set new_total "$string_count"
              end
          end

          set_color "$color"
          printf "$string "
          set_color normal

          set -g __prompt_count "$new_total"
        '';
      };

      fish_mode_prompt = {
        # Disable the built-in mode prompt
        body = "";
      };

      fish_prompt = {
        body = ''
          set -l last_status "$status"
          set -l last_duration "$CMD_DURATION"

          set -l is_final (contains -- --final-rendering $argv; echo $status)
          function __print_color_latest --inherit-variable is_final
            if test "$is_final" -eq 0
              __print_color brgreen "$argv[2]"
            else
              __print_color $argv
            end
          end

          echo -e ""

          set -g __prompt_count 0

          # User
          #
          set -l user (id -un $USER)
          __print_color brblack "┌"
          __print_color_latest red "$user"

          # Current time
          #
          __print_color brblack "at"
          __print_color_latest brcyan (date --rfc-3339=seconds)

          # Host
          #
          set -l host_name (hostname -s)
          set -l host_glyph "on"

          __print_color brblack "$host_glyph"
          __print_color_latest yellow "$host_name"


          # Current working directory
          #
          set -l pwd_glyph "in"
          set -l pwd_string (echo $PWD | sed 's|^'$HOME'\(.*\)$|~\1|')

          __print_color brblack "$pwd_glyph"
          __print_color_latest cyan "$pwd_string"

          # Git
          #
          if git_is_repo
              set -l branch_name (git_branch_name)
              set -l git_glyph "on ref"
              set -l git_branch_glyph

              __print_color brblack "$git_glyph"
              __print_color_latest blue "$branch_name"

              if git_is_touched
                  if git_is_staged
                      if git_is_dirty
                          set git_branch_glyph "[±]"
                      else
                          set git_branch_glyph "[+]"
                      end
                  else
                      set git_branch_glyph "[?]"
                  end
              end

              __print_color_latest brgreen "$git_branch_glyph"

              if __git_upstream_configured
                  set -l git_ahead (command git rev-list --left-right --count HEAD...@"{u}" | awk '
                      $1 > 0 { printf("⇡") } # can push
                      $2 > 0 { printf("⇣") } # can pull
                  ')

                  if test ! -z "$git_ahead"
                      __print_color_latest brgreen "$git_ahead"
                  end
              end
          end

          if test '(' "$last_duration" -gt 5000 ')' -o '(' "$last_status" -ne 0 ')'
              set -l human_duration (echo "$last_duration" | humanize_duration)
              set -l brblue (set_color brblue)
              set -g __prompt_count 0
              __print_color brblack "\n│"
              __print_color_latest brblue "Last command exited with code"
              __print_color_latest brmagenta "$last_status"
              __print_color_latest brblue "after"
              __print_color_latest brmagenta "$human_duration$brblue."
          end

          __print_color brblack "\e[K\n└"
        '';
      };

      fish_right_prompt = {
        body = ''
          # Disabled
        '';
      };

      git_branch_name = {
        body = ''
          set -l branch_name (command git symbolic-ref --short HEAD 2>/dev/null)

          if test -z "$branch_name"
              set -l tag_name (command git describe --tags --exact-match HEAD 2>/dev/null)

              if test -z "$tag_name"
                  command git rev-parse --short HEAD 2>/dev/null
              else
                  printf "%s\n" "$tag_name"
              end
          else
              printf "%s\n" "$branch_name"
          end
        '';
      };

      git_is_dirty = {
        body = ''
          git_is_repo; and not command git diff --no-ext-diff --quiet --exit-code 2>/dev/null
        '';
      };

      git_is_repo = {
        body = ''
          if not command git rev-parse --git-dir > /dev/null 2>/dev/null
              return 1
          end
        '';

        description = "Test if the current directory is a Git repository";
      };

      git_is_staged = {
        body = ''
          git_is_repo; and not command git diff --cached --no-ext-diff --quiet --exit-code 2>/dev/null
        '';
      };

      git_is_touched = {
        body = ''
          git_is_staged; or git_is_dirty
        '';

        description = "Test if there are any chagnes in the workign tree";
      };

      humanize_duration = {
        body = ''
          command awk '
              function hmTime(time,   stamp) {
                  split("h:m:s:ms", units, ":")
                  for (i = 2; i >= -1; i--) {
                      if (t = int( i < 0 ? time % 1000 : time / (60 ^ i * 1000) % 60 )) {
                          stamp = stamp t units[sqrt((i - 2) ^ 2) + 1] " "
                      }
                  }
                  if (stamp ~ /^ *$/) {
                      return "0ms"
                  }
                  return substr(stamp, 1, length(stamp) - 1)
              }
              { 
                  print hmTime($0) 
              }
          '
        '';
      };
    };

    interactiveShellInit = ''
      # Re-renders the prompt immediately before running a command. Used here to ensure that
      # timestamps reflect the time when a command was actually run.
      set --global fish_transient_prompt 1

      fish_vi_key_bindings
    '';

    plugins = [
      {
        name = "z";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "z";
          rev = "d2f502f5575b18a32e1bee2f2b3f869a5053c159";
          sha256 = "4c9ScQVf55b2ANaR7Lp/oqLeuK+FxH/wKmSNLV+b/CE=";
        };
      }
    ];
  };
}
