{
  description = "The https://flake.parts website";

  inputs = {
    # https://github.com/NixOS/nixpkgs/pull/300309
    nixpkgs.url = "github:NixOS/nixpkgs/640f2068a7b9d0034f376f6d10efb87a82d57f92";

    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
    agenix-shell.url = "github:aciceri/agenix-shell";
    agenix-shell.inputs.nixpkgs.follows = "nixpkgs";
    devenv.url = "github:hercules-ci/devenv/flake-module";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs"; # https://github.com/NixOS/nix/issues/7730
    dream2nix_legacy.inputs.pre-commit-hooks.follows = "git-hooks-nix";
    dream2nix_legacy.inputs.nixpkgs.follows = "nixpkgs";
    dream2nix_legacy.url = "github:nix-community/dream2nix/c9c8689f09aa95212e75f3108788862583a1cf5a";
    emanote.url = "github:srid/emanote";
    emanote.inputs.nixpkgs.follows = "nixpkgs";
    # This didn't work: "error: cannot find flake 'flake:ema' in the flake registries" (???)
    # emanote.inputs.ema.inputs.emanote.follows = "emanote";
    emanote.inputs.ema.follows = ""; # appears unneeded
    ez-configs.url = "github:ehllie/ez-configs";
    ez-configs.inputs.nixpkgs.follows = "nixpkgs";
    haskell-flake.url = "github:srid/haskell-flake";
    hercules-ci-effects.url = "github:hercules-ci/hercules-ci-effects";
    hercules-ci-effects.inputs.nixpkgs.follows = "nixpkgs";
    hercules-ci-effects.inputs.flake-parts.follows = "flake-parts";
    make-shell.url = "github:nicknovitski/make-shell";
    mission-control.url = "github:Platonic-Systems/mission-control";
    mkdocs-flake.url = "github:applicative-systems/mkdocs-flake";
    mkdocs-flake.inputs.nixpkgs.follows = "nixpkgs";
    nix-cargo-integration.url = "github:yusdacra/nix-cargo-integration";
    nix-cargo-integration.inputs.nixpkgs.follows = "nixpkgs";
    nix-cargo-integration.inputs.dream2nix.follows = "dream2nix_legacy";
    nix-topology.url = "github:oddlama/nix-topology";
    nix-topology.inputs.nixpkgs.follows = "nixpkgs";
    ocaml-flake.url = "github:9glenda/ocaml-flake";
    ocaml-flake.inputs.nixpkgs.follows = "nixpkgs";
    ocaml-flake.inputs.treefmt-nix.follows = "treefmt-nix";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";
    pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
    proc-flake.url = "github:srid/proc-flake";
    process-compose-flake.url = "github:Platonic-systems/process-compose-flake";
    pydev.url = "github:oceansprint/pydev";
    pydev.inputs.nixpkgs.follows = "nixpkgs";
    pydev.inputs.pre-commit-hooks-nix.follows = "git-hooks-nix";
    std.url = "github:divnix/std";
    std.inputs.nixpkgs.follows = "nixpkgs";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    let
      publishedModules = {
        empty-site = {
          imports = [
            ./render/render-module.nix
            ./site/site-module.nix
            ./core-modules.nix
          ];
          perSystem.render.officialFlakeInputs = inputs;
        };
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } ({ lib, ... }: {
      perSystem.render.inputs = {

        agenix-rekey = {
          title = "agenix-rekey";
          baseUrl = "https://github.com/oddlama/agenix-rekey/blob/main";
          attributePath = [ "flakeModule" ];
          intro = ''
            This is an extension for [agenix](https://github.com/ryantm/agenix) which allows you to get
            rid of maintaining a `secrets.nix` file by automatically re-encrypting secrets where needed.
            It also allows you to define versatile generators for secrets, so they can be bootstrapped
            automatically. This can be used alongside regular use of agenix.

            Please also refer to the upstream [installation section](https://github.com/oddlama/agenix-rekey?tab=readme-ov-file#installation)
            and [usage guide](https://github.com/oddlama/agenix-rekey?tab=readme-ov-file#usage) for
            information on how to access the wrapper utility in a devshell and how to setup your
            hosts to make use of agenix-rekey.
          '';
        };

        agenix-shell = {
          title = "agenix-shell";
          baseUrl = "https://github.com/aciceri/agenix-shell/blob/master";
          attributePath = [ "flakeModules" "default" ];
          intro = ''
            [agenix-shell](https://github.com/aciceri/agenix-shell) is the [agenix](https://github.com/ryantm/agenix) counterpart for `devShell`.
            It provides options used to define a `shellHook` that, when added to your `devShell`, automatically decrypts secrets and export them.

            [Here](https://github.com/aciceri/agenix-shell/blob/master/templates/basic/flake.nix)'s a template you can start from.
          '';
        };

        devenv = {
          title = "devenv";
          baseUrl = "https://github.com/cachix/devenv/blob/main";
          attributePath = [ "flakeModule" ];
          intro = ''
            [`devenv`](https://devenv.sh) provides a devShell with many options, and container packages.

            See also the [setup guide at devenv.sh](https://devenv.sh/guides/using-with-flake-parts/).
          '';
          fixupAnchorsBaseUrl = "https://devenv.sh/reference/options/";
        };

        devshell = {
          title = "devshell";
          baseUrl = "https://github.com/numtide/devshell/blob/main";
          intro = ''
            Simple per-project developer environments.

            Example:

            ```nix
            perSystem = { config, pkgs, ... }: {
              devshells.default = {
                env = [
                  {
                    name = "HTTP_PORT";
                    value = 8080;
                  }
                ];
                commands = [
                  {
                    help = "print hello";
                    name = "hello";
                    command = "echo hello";
                  }
                ];
                packages = [
                  pkgs.cowsay
                ];
              };
            };
            ```

            See also the [`devshell` project page](https://github.com/numtide/devshell)
          '';
        };

        dream2nix = {
          title = "dream2nix";
          baseUrl = "https://github.com/nix-community/dream2nix/blob/main";
          flakeRef = "github:nix-community/dream2nix";
          # FIXME all below
          intro = ''
            This page is a placeholder while dream2nix v2 is in the works.
            See [dream2nix_legacy](./dream2nix_legacy.html) for the previous API.
          '';
          installation = "";
          attributePath = [ "modules" "flake-parts" "all-modules" ];
          flake = { modules.flake-parts.all-modules = { }; outPath = "/x"; };
          isEmpty = true;
        };

        dream2nix_legacy = {
          title = "dream2nix legacy";
          baseUrl = "https://github.com/nix-community/dream2nix/blob/c9c8689f09aa95212e75f3108788862583a1cf5a";
          flakeRef = "github:nix-community/dream2nix/c9c8689f09aa95212e75f3108788862583a1cf5a";
          attributePath = [ "flakeModuleBeta" ];
          intro = ''
            [`dream2nix`](https://github.com/nix-community/dream2nix#readme) scans your flake files and turns them into packages.

            NOTE: a new version of dream2nix, v1, is in the works, and we're figuring out how best to use it.
          '';
        };

        emanote = {
          baseUrl = "https://github.com/srid/emanote/blob/master";
          intro = ''
            [`Emanote`](https://github.com/srid/emanote) renders your Markdown
            files as a nice static site with hot reload.

            Use `nix run` to run the live server, and `nix build` to build the
            static site.

            See
            [emanote-template](https://github.com/srid/emanote-template/blob/master/flake.nix)
            for an example `flake.nix`.
          '';
        };

        ez-configs = {
          baseUrl = "https://github.com/ehllie/ez-configs/blob/main";
          intro = ''
            [`ez-configs`](https://github.com/ehllie/ez-configs) lets you define multiple nixos,
            darwin, and home manager configurations, and reuse common modules using your flake directory structure.
          '';
        };

        "flake.parts-website" = {
          baseUrl = "https://github.com/hercules-ci/flake.parts-website/blob/main";
          intro = ''
            This module is used to build the flake.parts website.

            Refer to the [Generate Documentation guide](../generate-documentation.md) for more information.

            Its interface is subject to change but moves slowly and changes should be simple.
          '';
          flake = { _type = "flake"; outPath = throw "nope"; flakeModules = publishedModules; };
          attributePath = [ "flakeModules" "empty-site" ];
          getModules = _: [ publishedModules.empty-site ];
          sourcePath = builtins.path { name = "source"; path = ./.; };
        };

        git-hooks-nix = {
          baseUrl = "https://github.com/cachix/git-hooks.nix/blob/master";
          intro = ''
            Configure pre-commit hooks.

            Generates a configuration for [pre-commit](https://pre-commit.com),
            provides a script to activate it, and adds a [check](flake-parts.html#opt-perSystem.checks).

            Pre-defined hooks are maintained at [`cachix/git-hooks.nix`](https://github.com/cachix/git-hooks.nix).
          '';
        };

        haskell-flake = {
          baseUrl = "https://github.com/srid/haskell-flake/blob/master";
          intro = ''
            [`haskell-flake`](https://community.flake.parts/haskell-flake) scans your flake files for Haskell projects and
            turns them into packages using the Nixpkgs Haskell infrastructure.

            It also provides [`checks`](flake-parts.html#opt-perSystem.checks) and [`devShells`](flake-parts.html#opt-perSystem.devShells)

            Multiple projects can be declared to represent each package set, which is great for GHCJS frontends.
          '';
        };

        hercules-ci-effects = {
          baseUrl = "https://github.com/hercules-ci/hercules-ci-effects/blob/master";
          intro = ''
            This module provides
             - a mergeable `herculesCI` attribute; read by [Hercules CI](https://hercules-ci.com) and the [`hci`](https://docs.hercules-ci.com/hercules-ci-agent/hci/) command,
             - the [`hci-effects`](https://docs.hercules-ci.com/hercules-ci-effects/guide/import-or-pin/#_flakes_with_flake_parts) library as a module argument in `perSystem` / `withSystem`,
             - ready to go, configurable continuous deployment jobs
          '';
        };

        make-shell = {
          baseUrl = "https://github.com/nicknovitski/make-shell/blob/main";
          attributePath = [ "flakeModules" "default" ];
          intro = ''
            Modules for mkShell!  Set `make-shells.<name>` attributes to create `devShells.<name>` and `checks.<name>-devshell` flake outputs.  Import and merge complex or shared modules!  Create and share new options!

            For example:
            ```nix
            # aliases.nix
            {
              config,
              lib,
              pkgs,
              ...
            }: {
              options.aliases = lib.mkOption {
                type = lib.types.attrsOf lib.types.singleLineStr;
                default = {};
              };
              config.packages = let
                inherit (lib.attrsets) mapAttrsToList;
                alias = name: command: (pkgs.writeShellScriptBin name \'\'exec ''${command} "$@"\'\') // {meta.description = "alias for `''${command}`";};
              in
                mapAttrsToList alias config.aliases;
            }
            ```
            ```nix
            # flake.nix
            perSystem = {...}: {
              make-shells.default = {
                 imports = [./aliases.nix];
                 aliases = {
                   n = "nix";
                   g = "git";
                 };
               };
            };
            ```
          '';
        };

        mission-control = {
          baseUrl = "https://github.com/Platonic-Systems/mission-control/blob/main";
          intro = ''
            A flake-parts module for your Nix devshell scripts.

            Lets you configure commands that will be run in the repository root.

            Provides an informative "message of the day" when launching your shell.

            See the [Platonic-Systems/mission-control readme](https://github.com/Platonic-Systems/mission-control#readme).
          '';
        };

        mkdocs-flake = {
          title = "mkdocs-flake";
          baseUrl = "https://github.com/applicative-systems/mkdocs-flake/blob/main";
          intro = ''
            [mkdocs-flake](https://applicative-systems.github.io/mkdocs-flake/) adds documentation targets for your project [mkdocs](https://www.mkdocs.org/) documentation.
            The provided mkdocs distribution comes pre-packaged with the latest [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) and many useful plugins.

            After integration, run `nix build .#documentation` to build your documentation.
            To serve the documentation locally with live-rebuilds, run `nix run .#watch-documentation`

            Quick example how to integrate it into a flake:

            ```nix
            {
              description = "Description for the project";

              inputs = {
                flake-parts.url = "github:hercules-ci/flake-parts";
                nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

                # (1) add mkdocs-flake input
                mkdocs-flake.url = "github:applicative-systems/mkdocs-flake";
              };

              outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
                # (2) import mkdocs-flake module
                imports = [
                  inputs.mkdocs-flake.flakeModules.default
                ];
                systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
                perSystem = { config, self', inputs', pkgs, system, ... }: {
                  packages.default = pkgs.hello;

                  # (3) point mkdocs-flake to your mkdocs root folder
                  documentation.mkdocs-root = ./docs;

                  # (4) Build the docs:
                  #     `nix build .#documentation`
                  #     Run in watch mode for live-editing-rebuilding:
                  #     `nix run .#watch-documentation`
                };
              };
            }
            ```

            For more information, please refer to the [mkdocs-flake documentation: flake.parts integration](https://applicative-systems.github.io/mkdocs-flake/integration/flake-parts.html).
          '';
        };

        nix-cargo-integration = {
          title = "nix-cargo-integration";
          baseUrl = "https://github.com/yusdacra/nix-cargo-integration/blob/master";
          attributePath = [ "flakeModule" ];
          intro = ''
            Easily integrate your Rust projects into Nix.
          '';
          installation = ''
            ## Installation

            See the [readme](https://github.com/yusdacra/nix-cargo-integration#readme).
          '';
        };

        nix-topology = {
          title = "nix-topology";
          baseUrl = "https://github.com/oddlama/nix-topology/blob/main";
          attributePath = [ "flakeModule" ];
          intro = ''
            With nix-topology you can automatically generate infrastructure and network diagrams as SVGs
            directly from your NixOS configurations, and get something similar to the diagram [here](https://github.com/oddlama/nix-topology#readme).
            It defines a new global module system where you can specify what nodes and networks you have.
            Most of the work is done by the included NixOS module which automatically collects all the
            information from your hosts.

            After including this flake-parts module, you can build your diagram by running `nix build .#topology.<current-system>.config.output`.
          '';
        };

        ocaml-flake = {
          title = "ocaml-flake";
          baseUrl = "https://github.com/9glenda/ocaml-flake";
          attributePath = [ "flakeModule" ];
          intro = ''
            [`ocaml-flake`](https://github.com/9glenda/ocaml-flake) uses [`opam-nix`](https://github.com/tweag/opam-nix) to build ocaml packages. The module structure is inspired by [`haskell-flake`](https://community.flake.parts/haskell-flake).

            Since the flake is fairly new future versions may introduce breaking changes.
          '';
          installation = ''
            ## Installation
            To initialize a new dune project using `ocaml-flake` simply run:
            ```sh
            nix flake init -t github:9glenda/ocaml-flake#simple
            ```
            This will set up a devshell and package for you.
          '';
        };

        pkgs-by-name-for-flake-parts = {
          title = "pkgs-by-name-for-flake-parts";
          baseUrl = "https://github.com/drupol/pkgs-by-name-for-flake-parts/blob/main";
          # The installation instruction are already part of the example, which is nicer. (TODO @roberth: integrate this style)
          installation = "";
          intro = ''
            [pkgs-by-name-for-flake-parts](https://github.com/drupol/pkgs-by-name-for-flake-parts) is a flake-parts
            that can autoload Nix packages under a particular directory.

            It transform a directory tree containing package files suitable for callPackage into a matching nested attribute set of derivations.
            Find the documentation and example in the [manual](https://nixos.org/manual/nixpkgs/stable/index.html#function-library-lib.filesystem.packagesFromDirectoryRecursive).

            Quick example how to use it:

            ```nix
            {
              inputs = {
                flake-parts.url = "github:hercules-ci/flake-parts";
                nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

                # (1) add `pkgs-by-name-for-flake-parts` input
                pkgs-by-name-for-flake-parts.url = "github:drupol/pkgs-by-name-for-flake-parts";
              };

              outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } {
                systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];

                # (2) import pkgs-by-name-for-flake-parts module
                imports = [
                  inputs.pkgs-by-name-for-flake-parts.flakeModule
                ];

                perSystem = { config, self', inputs', pkgs, system, ... }: {
                  # (3) point to your directory containing Nix packages
                  pkgsDirectory = ./nix/pkgs-by-name;
                };
              };
            }
            ```
          '';
        };

        proc-flake = {
          baseUrl = "https://github.com/srid/proc-flake/blob/master";
          intro = ''
            A module for running multiple processes in a dev shell.

            [honcho](https://github.com/nickstenning/honcho) is used to launch the processes.

            See [proc-flake README](https://github.com/srid/proc-flake#readme)
          '';
        };

        process-compose-flake = {
          baseUrl = "https://github.com/Platonic-Systems/process-compose-flake/blob/main";
          intro = ''
            This flake-parts module allows you to declare one or more process-compose configurations using Nix attribute sets. It will generate corresponding packages that wrap the [process-compose](https://github.com/F1bonacc1/process-compose) binary with the given configuration.

            See [quick example](https://community.flake.parts/process-compose-flake#quick-example) to get started with [process-compose-flake](https://github.com/Platonic-Systems/process-compose-flake)
          '';
        };

        pydev = {
          title = "pydev";
          baseUrl = "https://github.com/oceansprint/pydev/blob/main";
          intro = ''
            [pydev](https://github.com/oceansprint/pydev) is an opinionated environment for developing Python packages.
          '';
        };

        std = {
          baseUrl = "https://github.com/divnix/std/blob/main";
          intro = ''
            Add definitions from the [Standard](https://github.com/divnix/std#readme) DevOps framework to your flake.

            It organizes and disciplines your Nix and thereby speeds you up.
            It also comes with great horizontal integrations of high quality
            vertical DevOps tooling crafted by the Nix Ecosystem.
          '';
          # FIXME?
          isEmpty = true;
        };

        treefmt-nix = {
          baseUrl = "https://github.com/numtide/treefmt-nix/blob/master";
          intro = ''
            When working on large code trees, it's common to have multiple code formatters run against it. And have one script that loops over all of them. `treefmt` makes that nicer.

             - A unified CLI and output
             - Run all the formatters in parallel.
             - Cache which files have changed for super fast re-formatting.
             - Just type treefmt in any folder and it reformats the whole code tree.

            This module is defined in [`numtide/treefmt-nix`](https://github.com/numtide/treefmt-nix). The `treefmt` repo is about the [tool](https://github.com/numtide/treefmt) itself.
          '';
        };

      };
      imports = [
        inputs.flake-parts.flakeModules.flakeModules
        publishedModules.empty-site
        ./dev-module.nix
        ./deploy-module.nix
        inputs.hercules-ci-effects.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];
      systems = [
        # Supported, see `ciSystems`
        "x86_64-linux"

        # Available, but may be broken by Nixpkgs updates sometimes
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      hercules-ci.flake-update = {
        enable = true;
        when = {
          hour = [ 8 20 ];
        };
        autoMergeMethod = "merge";
      };

      herculesCI = {
        ciSystems = [ "x86_64-linux" ];
      };

      flake.flakeModules = publishedModules;
      flake.templates = {
        private-site = {
          path = ./templates/private-site;
          description = "Reuse flake.parts-website to build your own documentation website";
        };
      };
    });
}
