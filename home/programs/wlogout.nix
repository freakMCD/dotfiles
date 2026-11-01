{ pkgs, ... }:
{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "suspend";
        action = "${pkgs.systemd}/bin/systemctl suspend";
        text = "Suspend";
      }
      {
        label = "reboot";
        action = "${pkgs.systemd}/bin/systemctl reboot";
        text = "Restart";
      }
      {
        label = "shutdown";
        action = "${pkgs.systemd}/bin/systemctl poweroff";
        text = "Shutdown";
      }
    ];

    style = ''
      * {
        font-family: monospace;
        font-size: 15px;
        background-image: none;
        box-shadow: none;
        text-shadow: none;
        transition: none;
      }

      window {
        background-color: #000000;
      }

      button {
        color: #aaaaaa;
        background-color: #080808;
        border: 1px solid #292929;
        border-radius: 0;
        margin: 6px;
        padding: 20px 12px;
        outline-style: none;
      }

      button:hover {
        color: #ffffff;
        background-color: #121212;
        border-color: #777777;
      }

      button:focus {
        color: #ee6677;
        background-color: #100a0b;
        border-color: #aa3344;
      }

      button:active {
        color: #ffffff;
        background-color: #301017;
        border-color: #ee6677;
      }
    '';
  };
}
