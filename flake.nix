{
  description = "Yet Another Monochrome Icon Set For KDE Plasma";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          yet-another-monochrome-icon-set = pkgs.stdenvNoCC.mkDerivation {
            pname = "yet-another-monochrome-icon-set";
            version = "1.4.2";

            src = ./.;

            nativeBuildInputs = [ pkgs.gtk3 ];

            dontBuild = true;

            installPhase = ''
              runHook preInstall

              mkdir -p $out/share/icons/yet-another-monochrome-icon-set
              cp -a actions apps categories devices emblems index.theme mimetypes places preferences status $out/share/icons/yet-another-monochrome-icon-set/

              runHook postInstall
            '';

            meta = with pkgs.lib; {
              description = "Yet Another Monochrome Icon Set For KDE Plasma";
              license = licenses.gpl3Only;
              platforms = platforms.all;
            };
          };

          default = self.packages.${system}.yet-another-monochrome-icon-set;
        });
    };
}
