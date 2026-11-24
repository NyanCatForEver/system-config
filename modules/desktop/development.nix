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

    nushell

    libqalculate
    speedcrunch

    python3
    uv
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
