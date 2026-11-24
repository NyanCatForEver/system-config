{ pkgs, ... }:

{
  programs.java.enable = true;
  programs.ghidra.enable = true;
  programs.renderdoc.enable = true;

  environment.systemPackages = with pkgs; [
    ripgrep
    fd
    jq
    difftastic

    intellij-idea
    zed-editor
    vscode
    helix

    distrobox

    python3
    nushell

    libqalculate
    speedcrunch

    ruff
    ty

    nixfmt
    nixd

    visualvm
    keystore-explorer

    pnpm
    deno

    okteta
    imhex
    cutter
    cutterPlugins.rz-ghidra
    rizin
    rizinPlugins.rz-ghidra

    apitrace
  ];
}
