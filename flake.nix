{
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      python = pkgs.python311.withPackages (ps: with ps; [
        (
          buildPythonPackage rec {
            pname = "webpreview";
            version = "1.7.2";
            src = fetchPypi {
              inherit pname version;
              sha256 = "sha256-2+wq1e3cAgLRmJqk21kxebB1pg2AL1DhK0t9OpLC4jI=";
            };
            doCheck = false;
            propagatedBuildInputs = [
              # Specify dependencies
              pkgs.python311Packages.beautifulsoup4
              pkgs.python311Packages.requests
            ];
          }
        )
      ]);
    in {
       devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.ripgrep
          pkgs.curl
          pkgs.jq
          python
        ];
      };
    };
}

