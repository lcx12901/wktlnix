let
  # if you do not have one, you can generate it by command:
  #     ssh-keygen -t ed25519
  wktl = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIlN8IQudQ66yPHkUa/UKjr9pfC0Sv6DWmX9OzYZ3nnI";
  users = [wktl];
in {
  "service/dae.age".publicKeys = users;
  "service/mihomo.age".publicKeys = users;

  "keys/cloudflare.age".publicKeys = users;

  "ssh/akari_rsa.age".publicKeys = users;
}
