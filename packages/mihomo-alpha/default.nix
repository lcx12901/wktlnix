{
  lib,
  buildGoModule,
  _sources,
  ...
}:
buildGoModule rec {
  inherit (_sources.mihomo-alpha) pname version src;

  vendorHash = "sha256-/YW3IRdDHcOrwUkXt/ORhN3OrwwV5H63WP6ioTFDR+c=";

  # Do not build testing suit
  excludedPackages = [ "./test" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/metacubex/mihomo/constant.Version=alpha-${lib.substring 0 7 version}"
  ];

  tags = [
    "with_gvisor"
  ];

  # Network required
  doCheck = false;

  postInstall = ''
    mv $out/bin/mihomo $out/bin/mihomo-alpha
  '';

  meta = with lib; {
    description = "A rule-based tunnel in Go";
    homepage = "https://github.com/MetaCubeX/mihomo/tree/Alpha";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ lcx12901 ];
    mainProgram = pname;
  };
}
