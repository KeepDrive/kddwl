{
  description = "dwl build flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; 
        dwlPkg = pkgs.stdenv.mkDerivation {
            name = "kddwl";
            src = self;
            buildInputs = with pkgs; [
              libinput
              wayland
              wayland-protocols
              wayland-scanner
              pixman
              wlroots_0_18
              libxkbcommon
              pkg-config

              # XWayland pkgs
              xorg.libxcb
              xorg.xcbutilwm
              xwayland
            ];
            makeFlags = [
              "PREFIX=$(out)"
            ];
          };
        in
        {
          apps.default = {
            type = "app";
            program = "${dwlPkg}/bin/dwl";
          };
          packages.default = dwlPkg;
        }
      );
}
