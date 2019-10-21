# Returns the nixpkgs set overridden and extended with DFINITY specific
# packages.
{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, overlays ? []
}:
let
  # The `common` repo provides code (mostly Nix) that is used in the
  # `infra`, `dfinity` and `sdk` repositories.
  #
  # To conveniently test changes to a local `common` repo you set the `COMMON`
  # environment variable to an absolute path of it. For example:
  #
  #   COMMON="$(realpath ../common)" nix-build -A rust-workspace
  commonSrc =
    let localCommonSrc = builtins.getEnv "COMMON"; in
    if localCommonSrc != ""
    then localCommonSrc
    else builtins.fetchGit {
      url = "ssh://git@github.com/dfinity-lab/common";
      rev = "be488df6b39363760b2952b907cc229f5c72d25f";
      ref = "nm-friday";
    };
in import commonSrc {
  inherit system crossSystem config;
  overlays = import ./overlays ++ overlays;
 }
