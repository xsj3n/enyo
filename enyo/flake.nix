{
  description = "Enyo dev env";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
   };

  outputs = { self , nixpkgs, ... }:
  let system = "x86_64-linux"; in
  {
    devShells."${system}".default =
    let
      libraries = with pkgs; [
        clang
        clang-tools 
        libgcc
       ];

      build_inp = with pkgs; [
        pkg-config
      ];

      pkgs = import nixpkgs { inherit system; } ;
      in pkgs.mkShell
      {
        packages = with pkgs; [
          bashInteractive
          android-studio
          pkg-config
          vscodium
          alsa-utils
        ];


        buildInputs = build_inp ++ libraries;

        shellHook = ''
          export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
          export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
        '';
    };
  };
}
