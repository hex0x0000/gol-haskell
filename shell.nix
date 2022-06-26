{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell rec {
    packages = with pkgs; [
      stack
      haskell-language-server
    ];
}
