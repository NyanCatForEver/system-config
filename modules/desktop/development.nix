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
    gh
    python3
    nushell
    libqalculate
    speedcrunch
    okteta

    nixfmt
    nixd

    visualvm
    jdk8

    pnpm
    deno
  ];
}
