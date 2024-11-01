{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    # # You can access packages and modules from different nixpkgs revs
    # # at the same time. Here's an working example:
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nurpkgs.url = github:nix-community/NUR;

     # Firefox style
    penguin-fox = {
      url = github:p3nguin-kun/penguinFox;
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , sops-nix
    , home-manager
    , firefox-addons
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      # debug var
      # debug = "Ok. ";
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        # "i686-linux"
        # "x86_64-linux"
        # "aarch64-darwin"
        # "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      mysystem = builtins.currentSystem;#"x86_64-linux";
      pkgs = import nixpkgs {inherit mysystem;};

      hLocalFile = builtins.path { path = "/etc/nixos/hostname.conf"; };
      hostnameFileContent = pkgs.runCommand "read-file" { inherit hLocalFile; } ''
        # echo $(cat ${hLocalFile} 2>/dev/null || echo nixamer) > $out
        cat ${hLocalFile} > $out
      '';
      uLocalFile = builtins.path { path = "/etc/nixos/username.conf"; };
      usernameFileContent = pkgs.runCommand "read-file" { inherit uLocalFile; } ''
        # echo $(cat ${uLocalFile} 2>/dev/null || echo nixamer) > $out
        cat ${uLocalFile} > $out
      '';
      sLocalFile = builtins.path { path = "/etc/nixos/sshusername.conf"; };
      sshusernameFileContent = pkgs.runCommand "read-file" { inherit sLocalFile; } ''
        # echo $(cat ${sLocalFile} 2>/dev/null || echo nixamer) > $out
        cat ${sLocalFile} > $out
      '';
      debug = "Ok.";

      # hostname = builtins.readFile hostnameFileContent;
      hostnameNotTrimmed = builtins.readFile hostnameFileContent;
      hostname = builtins.replaceStrings ["\n"] [""] hostnameNotTrimmed;

      usernameNotTrimmed = builtins.readFile usernameFileContent;
      username = builtins.replaceStrings ["\n"] [""] usernameNotTrimmed;

      sshusernameNotTrimmed = builtins.readFile sshusernameFileContent;
      sshusername = builtins.replaceStrings ["\n"] [""] sshusernameNotTrimmed;

      extraArgs = { hidpi }: {
        inherit hidpi;
        inherit (inputs) gh-md-toc penguin-fox;
        inherit (inputs.rycee-nurpkgs.lib.${mysystem}) buildFirefoxXpiAddon;
        # addons = nurpkgs.repos.rycee.firefox-addons; #pkgs.
      };
      addons = firefox-addons.packages.${mysystem};#rycee-nurpkgs. #nurpkgs.repos.rycee.firefox-addons; #pkgs.
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        # FIXME replace with your hostname
        "${hostname}" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs hostname username sshusername debug extraArgs addons; };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # NOTE : moved 
      homeConfigurations = {
        # FIXME replace with your username@hostname 
        "${username}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs hostname username sshusername debug extraArgs addons; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/home.nix
          ];
        };
        "${sshusername}@${hostname}" = home-manager.lib.homeManagerConfiguration {
          # pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          pkgs = nixpkgs.legacyPackages.aarch64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = { inherit inputs outputs hostname username sshusername debug extraArgs addons; };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/sshome.nix
          ];
        };
      };
    };
}
