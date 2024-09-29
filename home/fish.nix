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
          echo -e ""

          set -g __prompt_count 0

          # User
          #
          set -l user (id -un $USER)
          __print_color red "$user"

          # Host
          #
          set -l host_name (hostname -s)
          set -l host_glyph "at"

          __print_color white "$host_glyph"
          __print_color yellow "$host_name"


          # Current working directory
          #
          set -l pwd_glyph "in"
          set -l pwd_string (echo $PWD | sed 's|^'$HOME'\(.*\)$|~\1|')

          __print_color white "$pwd_glyph"
          __print_color cyan "$pwd_string"

          # Git
          #
          if git_is_repo
              set -l branch_name (git_branch_name)
              set -l git_glyph "on"
              set -l git_branch_glyph

              __print_color white "$git_glyph"
              __print_color blue "$branch_name"

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

              __print_color cyan "$git_branch_glyph"

              if __git_upstream_configured
                  set -l git_ahead (command git rev-list --left-right --count HEAD...@"{u}" | awk '
                      $1 > 0 { printf("⇡") } # can push
                      $2 > 0 { printf("⇣") } # can pull
                  ')

                  if test ! -z "$git_ahead"
                      __print_color cyan "$git_ahead"
                  end
              end
          end

          __print_color red "\e[K\n❯"
        '';

        description = "Simple Fish Prompt";
      };

      fish_right_prompt = {
        body = ''
          set -l status_copy $status
          set -l status_color cyan

          if test "$status_copy" -ne 0
              set status_color red
          end

          if test "$CMD_DURATION" -gt 100
              set -l duration_copy $CMD_DURATION
              set -l duration (echo $CMD_DURATION | humanize_duration)

              echo -sn (set_color $status_color) "$duration" (set_color normal)
          end

          if set -l last_job_id (last_job_id -l)
              echo -sn (set_color $status_color) " %$last_job_id" (set_color normal)
          end

          echo -sn (set_color brgreen) ' ' (date "+%H:%M") (set_color normal)

          if test "$fish_key_bindings" = "fish_vi_key_bindings"
              switch $fish_bind_mode
                  case default
                      echo ' [n]'
                  case insert
                      echo ' [i]'
                  case replace-one
                      echo ' [r]'
                  case visual
                      echo ' [v]'
              end
          end
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

      last_job_id = {
        body = ''
          jobs $argv | command awk '/^[0-9]+\t/ { print status = $1 } END { exit !status }'
        '';
      };
    };

    interactiveShellInit = ''
      fish_vi_key_bindings
    '';

    plugins = [{
      name = "z";
      src = pkgs.fetchFromGitHub {
        owner = "jethrokuan";
        repo = "z";
        rev = "85f863f20f24faf675827fb00f3a4e15c7838d76";
        sha256 = "1797n91ka5smj1h2qq7kdhs22qjyrpd0gk18lhk0s3izl36r31sl";
      };
    }];
  };
}
