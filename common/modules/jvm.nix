{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.programs.java.symlink;
in
{
  options.programs.java.symlink = {
    enable = lib.mkEnableOption "symlinking JVM packages";
    path = lib.mkOption {
      type = lib.types.path;
      default = "/opt/java";
    };
    packages = lib.mkOption {
      type = with lib.types; attrsOf pathInStore;
      default = { };
      example = {
        openjdk-8 = "${pkgs.openjdk8}/lib/openjdk";
        openjdk-25 = "${pkgs.openjdk25}/lib/openjdk";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.runCommand "jvm" { } ''
        mkdir -p $out/lib/jvm
        ${lib.concatMapAttrsStringSep "\n" (name: path: "ln -s ${path} $out/lib/jvm/${name}") cfg.packages}
      '')
    ];
    systemd.tmpfiles.rules = [
      "L+ ${cfg.path} - - - - /run/current-system/sw/lib/jvm"
    ];
    environment.pathsToLink = [ "/lib/jvm" ];
  };
}
