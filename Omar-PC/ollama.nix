{ config, pkgs, ... }:

{
  services.ollama = {
    enable = true;

    # Networking
    host = "192.168.1.14";
    port = 11434;
    openFirewall = true;

    # Acceleration: "cuda", "rocm", or "none"
    acceleration = "rocm";

    # Run as specific user/group (must exist or be created)
    user = "ollama";
    group = "ollama";
    home = "/mnt/nvme/ollama";

    # Automatically pull model on boot
    loadModels = [
      "deepseek-r1:1.5b"
    ];
  };
}