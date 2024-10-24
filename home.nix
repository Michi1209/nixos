{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  home-manager.users.michi = {
    programs.zsh = {
	    enable = true;
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
    programs.starship = {
      enable = true;
    };
    /* The home.stateVersion option does not have a default and must be set */
    home.stateVersion = "24.05";
    /* Here goes the rest of your home-manager config, e.g. home.packages = [ pkgs.foo ]; */
  };
}
