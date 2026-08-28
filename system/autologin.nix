{ pkgs, ... }:

let
  tuigreet = "${pkgs.tuigreet}/bin/tuigreet";
  session = "${pkgs.uwsm}/bin/uwsm start -e -D Hyprland hyprland.desktop";
in

{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "${session}";
        user = "edwin";
      };
      default_session = {
        command = "${tuigreet} --greeting 'Welcome to NixOS!' --asterisks --remember --remember-user-session --time --cmd '${session}'";
        user = "greeter";
      };
    };
  };
}
