{ config, pkgs, lib, ... }:
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-full
      dvisvgm dvipng # for preview and export as html
      wrapfig amsmath ulem hyperref capt-of;
      #(setq org-latex-compiler "lualatex")
      #(setq org-preview-latex-default-process 'dvisvgm)
  });
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  home-manager.users.michi = {

    services.kdeconnect.enable = true;
    programs.zsh = {
	    enable = true;
	    # completionInit = "";
	    enableCompletion = true;
	    
	    syntaxHighlighting.enable = true;
        zplug = {
			enable = true;
		    plugins = [
		    	
      			{ name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
      			{ name = "zsh-users/zsh-syntax-highlighting"; }
      			{ name = "zsh-users/zsh-history-substring-search"; }
      			{ name = "joshskidmore/zsh-fzf-history-search"; }
			];
	    };


	    shellAliases = {
	        ls = "ls --color=auto";
			ll = "ls -lah --color=auto";
			edit = "sudo -e";
			update = "sudo nixos-rebuild switch";
			docker-compose="docker compose";
			cdn="cd ~/Documents/diamir/rudi-backend";
			cdu="cd ~/Documents/diamir/uniqa-rudi";
			cdp="cd ~/Documents/diamir/playbooks";
			cdk="cd ~/Documents/diamir/klz-backend/";
			cdd="cd ~/Documents/diamir/";
	    };

	    profileExtra = ''
	      setopt incappendhistory
	      setopt histfindnodups
	      setopt histreduceblanks
	      setopt histverify
	      setopt correct                                                  # Auto correct mistakes
	      setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
	      setopt nocaseglob                                               # Case insensitive globbing
	      setopt rcexpandparam                                            # Array expension with parameters
	      #setopt nocheckjobs                                              # Don't warn about running processes when exiting
	      setopt numericglobsort                                          # Sort filenames numerically when it makes sense
	      unsetopt nobeep                                                 # Enable beep
	      setopt appendhistory                                            # Immediately append history instead of overwriting
	      unsetopt histignorealldups                                      # If a new command is a duplicate, do not remove the older one
	      setopt interactivecomments
	      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
	      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
	      zstyle ':completion:*' rehash true                              # automatically find new executables in path
	      # Speed up completions
	      zstyle ':completion:*' accept-exact '*(N)'
	      zstyle ':completion:*' use-cache on
	      zstyle ':completion:*' menu select
	      WORDCHARS=''${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word
	      bindkey "^[[1;5C" forward-word # zsh ctrl right and left 
	      bindkey "^[[1;5D" backward-word
	    '';

		autocd = true;
	    history.size = 1000000;
	    history.ignoreAllDups = true;
	    history.path = "$HOME/.zsh_history";
	    history.ignorePatterns = ["rm *" "pkill *" "cp *"];
    };
    #wayland.windowManager.sway = {
    #  enable = true;
    #};
    programs.autojump = {
    	enable = true;
    	enableZshIntegration = true;
    };
    programs.git = {
        enable = true;
        userEmail = "michael.plattner@diamir.io";
        userName = "Michael Plattner";
        # signing = {
        #     signByDefault = true;
        # 	key = "~/.ssh/id_ed25519.pub";
        # };
        delta = {
        	enable = true;
        	options = {
        		
        	navigate = true;
        	light = false;

        	};
        };
        extraConfig = {
           init.defaultBranch = "main";

           
            commit.gpgsign = true;
        	gpg.format = "ssh";
        	user.signingkey = "~/.ssh/id_ed25519.pub";
           commit = {
           	verbose = true;
           };
           core = {
               autocrlf = "input";
               hooksPath = "/home/michi/.githooks";
           };
           branch = {
           	sort = "-committerdate";
           };
           push = {
           	default = "current";
           	autoSetupRemote = true;
           };
           column = {
           	ui = "auto";
           };
           merge = {
           	conflictstyle = "zdiff3";
           };
           rerere = {
           	enabled = true;
           	autoUpdate = true;
           };
        };
        ignores = [
           "*~"
           "*.swp"
           "*result*"
           "node_modules"
        ];
    };
    programs.starship = {
      enable = true;
      settings = {
      	  add_newline = false;
		  format = lib.concatStrings [
			  "[](color_orange)"
			  " (bg:color_orange fg:color_fg0)"
			  "$username"
			  "[ ](bg:color_yellow fg:color_orange)"
			  "$directory"
			  "[ ](fg:color_yellow bg:color_aqua)"
			  "$git_branch"
			  "$git_status"
			  "[ ](fg:color_aqua bg:color_blue)"
			  "$c"
			  "$rust"
			  "$golang"
			  "$nodejs"
			  "$php"
			  "$java"
			  "$kotlin"
			  "$haskell"
			  "$python"
			  "[ ](fg:color_blue bg:color_bg3)"
			  "$docker_context"
			  "$conda"
			  "[ ](fg:color_bg3 bg:color_bg1)"
			  "$time"
			  "[ ](fg:color_bg1)"
			  "$line_break$character"

		  ];
		  palette = "gruvbox_dark";
		  palettes = {
		  	gruvbox_dark = {
		  		color_fg0 = "\#fbf1c7";
		  		color_bg1 = "\#3c3836";
		  		color_bg3 = "\#665c54";
		  		color_blue = "\#458588";
		  		color_aqua = "\#689d6a";
		  		color_green = "\#98971a";
		  		color_orange = "\#d65d0e";
		  		color_purple = "\#b16286";
		  		color_red = "\#cc241d";
		  		color_yellow = "\#d79921";
		  	};
		  };
		  username = {
		  	show_always = true;
		  	style_user = "bg:color_orange fg:color_fg0";
		  	style_root = "bg:color_orange fg:color_fg0";
		  	format = "[ $user ]($style)";
		  };
		  directory = {
		  	style = "fg:color_fg0 bg:color_yellow";
		  	format = "[ $path ]($style)";
		  	truncation_length = 3;
		  	truncation_symbol = "…/";
		  };
		  git_branch = {
		    symbol = "";
		    style = "bg:color_aqua";
		    format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
		  };
		  git_status = {
		    style = "bg:color_aqua";
		    format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
		  };
		  golang = {
		  	symbol = "";
		  	style = "bg:color_blue";
		  	format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		  };
		  nodejs = {
		  	symbol = "";
		  	style = "bg:color_blue";
		  	format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		  };
		  python = {
		  	symbol = "";
		  	style = "bg:color_blue";
		  	format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		  };
		  docker_context = {
		  	symbol = "";
		  	style = "bg:color_bg3";
		  	format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
		  };
		  time = {
		  	disabled = false;
		  	time_format = "%R";
		  	style = "bg:color_bg1";
		  	format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
		  };
		  character = {
		  	disabled = false;
		  	success_symbol = "[](bold fg:color_green)";
		  	error_symbol = "[](bold fg:color_red)";
		  	vimcmd_symbol = "[](bold fg:color_green)";
		  	vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
		  	vimcmd_replace_symbol = "[](bold fg:color_purple)";
		  	vimcmd_visual_symbol = "[](bold fg:color_yellow)";
		  };
		  scan_timeout = 10;
      };
    };

    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
    
	home.packages = with pkgs; [
	  tex
	];
  };
  
   networking.firewall = rec {
   	
 		allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
 		allowedUDPPortRanges = allowedTCPPortRanges;
   };
}
