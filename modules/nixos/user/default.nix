{
  config,
  lib,
  pkgs,
  namespace,
  ...
}: let
  inherit (lib.types) str listOf attrs;
  inherit (lib.${namespace}) mkOpt enabled;

  cfg = config.${namespace}.user;
in {
  options.${namespace}.user = {
    email = mkOpt str "wktl1991504424@gmail.com" "The email of the user.";
    extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    extraOptions = mkOpt attrs {} "Extra options passed to <option>users.users.<name></option>.";
    fullName = mkOpt str "Chengxu Lin" "The full name of the user.";
    name = mkOpt str "wktl" "The name to use for the user account.";
  };

  config = {
    environment.systemPackages = with pkgs; [
      fortune
      lolcat
    ];

    programs.fish = enabled;

    users.mutableUsers = false;

    users.users.${cfg.name} =
      {
        inherit (cfg) name;

        extraGroups =
          [
            "wheel"
            "systemd-journal"
            "mpd"
            "audio"
            "video"
            "input"
            "plugdev"
            "lp"
            "tss"
            "power"
            "nix"
          ]
          ++ cfg.extraGroups;

        group = "users";
        home = "/home/${cfg.name}";
        createHome = true;
        isNormalUser = true;
        shell = pkgs.fish;
        uid = 1000;

        hashedPassword = "$6$XXUp9uRF41kC5YHm$lsOLgDuECYb9CbDHBRpsPashoBzB794KoLWI2NCpOl5cB9puDosikhJwGXNxuLf/mW6nJ0SdYkasIAIHfd99/0";

        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDORhqXAJXf4DYM4A2ghCqGT6dp6vI6K0gbOBpBjTFUBaY9/vdU+TQ9452f/Yo8Vm2/D9CLnv35SDB2UlQSY0/aCpigL9yzDP8g8EU7wSDjE7zvqMp7QV/Ynw8bs/LK62E7PBYBSLbYUaprc3NLVlNsZPcW3xN2NFI5LDD97tCH5sZuEaxi3V8LpMicvHWi8qWqwFaQQlK6EeMkvXTo35noVKzoYdMHxAmCZ0UbuhyT6O7Xf1ijWyd6zMBhEhYIL6KReLo4LW7eQA8Bx9/gfYo6d/wD8qp83WpCgkXGwN7YmT5GW+86HBZdeY5s7Nf2No/82htvjiWNLbkspo9EpWQzVWzl6ZFBYf1YM15Pf5do9MTqmk6UEp3vuFbYuSS8l89sg3IUNtMfJA2c1WqwtGLYmE4Fm8Na8HbUFFucD1UMK4QnXjhJK7q3cm9tHNjA8hJHvw5rpGBuvPSgGMDyhWpNQtqylEqA3mRbJmN3mHTl9yQvnGkRHGEGWhUJ9aLnWhDgruQ7kkSehpq+Or8uLgVK6FNXV1LiAV4SZA/1ltHEhr8koyTqGtqFO32sM49nZpFHCSVNZQlNgYzDD73GHsKWq0Nq0L9KSV9rmpFQvLNb3XRPuWuXJd5Eu/b2qvbGR7IqdytXaODXFdijEdmCUff7NSyVQVIaTE6JzWFSwabeQ=="
        ];
      }
      // cfg.extraOptions;

    users.users.root.hashedPassword = "*"; # lock root account
  };
}
