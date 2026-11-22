{ pkgs, ... }:

{
  programs.java.enable = true;
  programs.ghidra.enable = true;

  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    jq
    difftastic

    zed-editor
    vscode
    helix

    distrobox

    python3
    nushell

    libqalculate
    speedcrunch

    nixfmt
    nixd

    visualvm
    keystore-explorer
    jdk8

    pnpm
    deno

    okteta
    imhex
    cutter
    cutterPlugins.rz-ghidra
    rizin
    rizinPlugins.rz-ghidra
  ];
}
