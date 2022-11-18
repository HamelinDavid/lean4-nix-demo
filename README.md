# Lean 4 Demo

This project shows a Lean 4 project with multiple files, which can be built using either lake or nix.

The `flake.nix` also provide a development environment with vscode and its lean4 extension.

You can enter the nix development environment using `nix develop` at the root of the project if you have enabled flakes.

If you haven't, just use  `nix develop --experimental-features 'nix-command flakes'` to temporarily enable flakes.

The development environment provides lean 4, lake and vscode.

Even though nix doesn't use lake to build the projcet, it is needed by the lean vscode extension to find which files are used by the project.



