
# Defining a custom flake output attribute

## Should I do this?

You should generally stick to the schema suggested by the Nix CLI, NixOS, etc. If your module is about making certain things easier to express, you probably only need to declare regular options that aren't exposed in the flake outputs.

If you are building your own tool that needs a special kind of input from a flake, you may want to expose an option as a flake output, and flake-parts is here to support that.

## `perSystem` first

Integrating with `perSystem` is highly recommended, because that's where users expect things like packages to be defined. You can bring things that are defined in `perSystem` to the flake outputs in the same way [`packages.nix`](https://github.com/hercules-ci/flake-parts/blob/main/modules/packages.nix) does it.

If your application doesn't follow the same pattern, but you want users to define things in [`perSystem`](options/flake-parts.html#opt-perSystem), you may read the top level `config.allSystems` (internal) option. You can read it in the definition for a new option in the [`flake`](options/flake-parts.html#opt-flake) submodule so that its value is added to the flake outputs.

## `config.flake`

[flake](options/flake-parts.html#opt-flake) is an RFC42-style module, which means that it both has options and it allows arbitrary attributes to be defined in the config, without having to declare an option first.
Declaring an option is recommended though, for the purposes of documentation, type checking, and allowing multiple config definitions to be merged into a single output value, if applicable.

## Get Help

This is an advanced use case. Feel free to ask questions in [#hercules-ci:matrix.org](https://matrix.to/#/#hercules-ci:matrix.org).
