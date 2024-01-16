{
  description = ''
    Trivial C project template
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        
        llvm = pkgs.llvmPackages_latest;

        # simple script which replaces the functionality of make
        # it works with <math.h> and includes debugging symbols by default
        # it will be updated as per needs

        # arguments: outfile
        # basic usage example: mk main [flags]
        mymake = pkgs.writeShellScriptBin "mk" ''
          if [ -f "$1.c" ]; then
            i="$1.c"
            c=$CC
          else
            i="$1.cpp"
            c=$CXX
          fi
          o=$1
          shift
          $c -ggdb $i -o $o -lm -Wall $@
        '';
      in
      {
        defaultPackage =
          # rec used so we can refer to field inside phases
          pkgs.clangStdenv.mkDerivation rec {
            name = "my-app";
            execName = pkgs.lib.stringAsChars (x: if x == "-" then "_" else x) name;
            src = self;
            nativeBuildInputs = [ mymake ];
            buildPhase = "mk src/main -o ${execName}";
            installPhase = ''
              mkdir -p $out/bin
              install -t $out/bin ${execName}
              chmod +x $out/bin/${execName}
            '';
          };

        nativeBuildInputs = [
          mymake
        ];
      
        devShell = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } rec {
          packages = with pkgs; [
            # builder
            gnumake
            cmake
            bear

            # debugger
            llvm.lldb
            gdb

            # fix headers not found
            clang-tools

            # LSP and compiler
            llvm.libstdcxxClang

            # other tools
            cppcheck
            llvm.libllvm
            valgrind
            mymake

            # stdlib for cpp
            llvm.libcxx
              
            # libs
          ];
          name = "C";
        };
      }
    );
}
