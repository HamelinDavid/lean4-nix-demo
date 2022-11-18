{
  description = "Lean 4 demo with flake and lake";
    
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils = {
      url = "github:numtide/flake-utils";
    };

    lean4 = {
      url = "github:HamelinDavid/lean4";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    lake = {
      url = "github:leanprover/lake";
      inputs = {
        lean.follows = "lean4";
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  
  outputs = { self, nixpkgs, flake-utils, lean4, lake }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { 
        inherit system; 
        config.allowUnfree = true;
      };
      
      lakePkg = lake.outputs.defaultPackage.${system};
      
      leanPkgs = lean4.packages.${system};
      
      pkg = leanPkgs.buildLeanPackage {
        # There should be a file with the same name, containg a main function
        name = "Main"; 
        # List all your files here (without the .lean)
        roots = ["Main" "Demo"];
        src = ./.;
      };

      vscode-lean = with pkgs; (vscode-with-extensions.override {
        vscodeExtensions = vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "lean4";
            publisher = "leanprover";
            version = "0.0.97";
            sha256 = "sha256-uAXKN+6NWUsDV1KZ/4YjFlGy97BiuCm0NtHadpyO504=";
          }
        ];
      });
    in {

      devShell = pkgs.mkShell rec {
        buildInputs = with pkgs; [ leanPkgs.lean-all lakePkg vscode-lean ];
        
        shellHook = ''
          export PATH="${pkgs.lib.makeBinPath buildInputs}:$PATH"
        '';
      };


      packages = pkg // {
        inherit (leanPkgs) lean;
      };

      defaultPackage = pkg.modRoot;
    });
}
