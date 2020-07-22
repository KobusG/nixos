{ config, lib, ... }:

let
  cfg = config.primary-user;
in

{
  options.primary-user.email = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The primary user's email address.";
  };

  options.primary-user.fullname = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The primary user's \"full name\".";
  };

  options.primary-user.username = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
    description = "The primary user's account name (username).";
  };

  imports = [
    (lib.mkAliasOptionModule [ "primary-user" "description" ] [ "users" "users" cfg.username "description" ])
    (lib.mkAliasOptionModule [ "primary-user" "home" ] [ "users" "users" cfg.username "home" ])
    (lib.mkAliasOptionModule [ "primary-user" "home-manager" ] [ "home-manager" "users" cfg.username ])
    (lib.mkAliasOptionModule [ "primary-user" "shell" ] [ "users" "users" cfg.username "shell" ])
    (lib.mkAliasOptionModule [ "primary-user" "uid" ] [ "users" "users" cfg.username "uid" ])
  ];

  config = lib.mkIf (cfg.username != null) {
    primary-user = {
      uid = lib.mkDefault 1000;
    };
    users.users.${cfg.username}.name = cfg.username;
    nix = {
      # Run the garbage collector as the primary-user.
      gc.user = cfg.username;
      trustedUsers = [ "root" cfg.username "@admin" "@wheel" ];
    };
  };
}