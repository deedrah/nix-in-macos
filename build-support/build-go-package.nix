{ go, govers, parallel, lib, fetchgit, fetchhg, rsync, removeReferencesTo }:

{ name, buildInputs ? [], nativeBuildInputs ? [], passthru ? {}, preFixup ? ""

# We want parallel builds by default
, enableParallelBuilding ? true

# Disabled flag
, disabled ? false

# Go import path of the package
, goPackagePath

# Go package aliases
, goPackageAliases ? [ ]

# Extra sources to include in the gopath
, extraSrcs ? [ ]

# Extra gopaths containing src subfolder
# with sources to include in the gopath
, extraSrcPaths ? [ ]

# go2nix dependency file
, goDeps ? null

, dontRenameImports ? false

# Do not enable this without good reason
# IE: programs coupled with the compiler
, allowGoReference ? false

, compileProtos ? false

, meta ? {}, ... } @ args':

if disabled then throw "${name} not supported for go ${go.meta.branch}" else

with builtins;

let
  args = lib.filterAttrs (name: _: name != "extraSrcs") args';

  removeReferences = [ ] ++ lib.optional (!allowGoReference) go;

  removeExpr = refs: ''remove-references-to ${lib.concatMapStrings (ref: " -t ${ref}") refs}'';

  #dep2src = goDeps;
  # goDep:
  #  {
  #    inherit (goDep) goPackagePath;
  #    src = if goDep.fetch.type == "git" then
  #      fetchgit {
  #        inherit (goDep.fetch) url rev sha256;
  #      }
  #    else if goDep.fetch.type == "hg" then
  #      fetchhg {
  #        inherit (goDep.fetch) url rev sha256;
  #      }
  #    else abort "Unrecognized package fetch type";
  #  };

  #importGodeps = { depsFile }:
  #  map dep2src (import depsFile);

  goPath = if goDeps != null then goDeps ++ extraSrcs
                             else extraSrcs;
in

go.stdenv.mkDerivation (
  (builtins.removeAttrs args [ "goPackageAliases" "disabled" "goDeps" ]) // {

  inherit name;
  nativeBuildInputs = [ removeReferencesTo go parallel ]
    ++ (lib.optional (!dontRenameImports) govers) ++ nativeBuildInputs;
  buildInputs = [ go ] ++ buildInputs;

  goSourcePackages =
    let
      goPackagePathList = lib.optionals compileProtos [ goPackagePath ];
      goDepsPathlist = lib.optionals ( goDeps != null )
        ( map ( val: val.goPackagePath )
              ( filter ( val: if val ? compileProtos then val.compileProtos else false ) goDeps )
        );
    in
      lib.concatStringsSep ":" ( goPackagePathList ++ goDepsPathlist );

  configurePhase = args.configurePhase or ''
    runHook preConfigure

    # Extract the source
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/$(dirname "$goPackagePath")"
    mv "$sourceRoot" "go/src/$goPackagePath"

  '' + lib.flip lib.concatMapStrings goPath ({ src, goPackagePath, ... }: ''
    mkdir goPath
    (cd goPath; unpackFile "${src}")
    mkdir -p "go/src/$(dirname "${goPackagePath}")"
    chmod -R u+w goPath/*
    mv goPath/* "go/src/${goPackagePath}"
    rmdir goPath

  '') + (lib.optionalString (extraSrcPaths != []) ''
    ${rsync}/bin/rsync -a ${lib.concatMapStrings (p: "${p}/src") extraSrcPaths} go

  '') + ''
    export GOPATH=$NIX_BUILD_TOP/go:$GOPATH

    runHook postConfigure
  '';

  renameImports = args.renameImports or (
    let
      inputsWithAliases = lib.filter (x: x ? goPackageAliases)
        (buildInputs ++ (args.propagatedBuildInputs or [ ]));
      rename = to: from: "echo Renaming '${from}' to '${to}'; govers -d -m ${from} ${to}";
      renames = p: lib.concatMapStringsSep "\n" (rename p.goPackagePath) p.goPackageAliases;
    in lib.concatMapStringsSep "\n" renames inputsWithAliases);

  NIX_NO_SELF_RPATH = true;

  buildPhase = args.buildPhase or ''
    runHook preBuild

    runHook renameImports

    buildGoDir() {
      local d; local cmd;
      cmd="$1"
      d="$2"
      . $TMPDIR/buildFlagsArray
      echo "$d" | grep -q "\(/_\|examples\|Godeps\)" && return 0
      [ -n "$excludedPackages" ] && echo "$d" | grep -q "$excludedPackages" && return 0
      local OUT
      if ! OUT="$(go $cmd $buildFlags "''${buildFlagsArray[@]}" -v $d 2>&1)"; then
        if ! echo "$OUT" | grep -qE '(no( buildable| non-test)?|build constraints exclude all) Go (source )?files'; then
          echo "$OUT" >&2
          return 1
        fi
      fi
      if [ -n "$OUT" ]; then
        echo "$OUT" >&2
      fi
      return 0
    }

    getGoDirs() {
      local type;
      type="$1"
      if [ -n "$subPackages" ]; then
        echo "$subPackages" | sed "s,\(^\| \),\1$goPackagePath/,g"
      else
        pushd go/src >/dev/null
        find "$goPackagePath" -type f -name \*$type.go -exec dirname {} \; | grep -v "/vendor/" | sort | uniq
        popd >/dev/null
      fi
    }

    if [ ''${#buildFlagsArray[@]} -ne 0 ]; then
      declare -p buildFlagsArray > $TMPDIR/buildFlagsArray
    else
      touch $TMPDIR/buildFlagsArray
    fi
    export -f buildGoDir # parallel needs to see the function
    if [ -z "$enableParallelBuilding" ]; then
        export NIX_BUILD_CORES=1
    fi
    getGoDirs "" | parallel -j $NIX_BUILD_CORES buildGoDir install

    runHook postBuild
  '';

  checkPhase = args.checkPhase or ''
    runHook preCheck

    getGoDirs test | parallel -j $NIX_BUILD_CORES buildGoDir test

    runHook postCheck
  '';

  installPhase = args.installPhase or ''
    runHook preInstall

    mkdir -p $out
    pushd "$NIX_BUILD_TOP/go"
    while read f; do
      echo "$f" | grep -q '^./\(src\|pkg/[^/]*\)/${goPackagePath}' || continue
      mkdir -p "$(dirname "$out/share/go/$f")"
      cp "$NIX_BUILD_TOP/go/$f" "$out/share/go/$f"
    done < <(find . -type f)
    popd

    mkdir -p $bin
    dir="$NIX_BUILD_TOP/go/bin"
    [ -e "$dir" ] && cp -r $dir $bin
  '' + ( lib.optionalString ( go.stdenv.isDarwin ) ''
    for binary in $bin/bin/*; do
      otool -l $binary || true
      #local OUT
      #if ! OUT="$(install_name_tool -delete_rpath $out/lib $binary 2>&1)"; then
      #  if ! echo "$OUT" | grep -qE 'no LC_RPATH load command with path'; then
      #    echo "$OUT" >&2
      #    return 1
      #  fi
      #fi
    done
  '' ) + ''
    runHook postInstall
  '';

  preFixup = preFixup + ''
    find $bin/bin -type f -exec ${removeExpr removeReferences} '{}' + || true
  '';

  shellHook = ''
    d=$(mktemp -d "--suffix=-$name")
  '' + toString ( map ( dep: ''
    mkdir -p "$d/src/$(dirname "${dep.goPackagePath}")"
    ln -s "${toString dep.src}" "$d/src/${dep.goPackagePath}"
  '' ) goPath ) + ''
  '' + toString ( map ( dep: if dep ? goPackagePath then ''
    mkdir -p "$d/src/$(dirname "${dep.goPackagePath}")"
    ln -s "${toString dep.out}/share/go/src/${dep.goPackagePath}" "$d/src/${dep.goPackagePath}"
    mkdir -p "$d/pkg/linux_amd64/$(dirname "${dep.goPackagePath}")"
    if [ -d "${dep.out}/share/go/pkg/linux_amd64/${dep.goPackagePath}" ]; then
        ln -s "${dep.out}/share/go/pkg/linux_amd64/${dep.goPackagePath}" "$d/pkg/linux_amd64/${dep.goPackagePath}"
    fi
    if [ -f "${dep.out}/share/go/pkg/linux_amd64/${dep.goPackagePath}.a" ]; then
        ln -s "${dep.out}/share/go/pkg/linux_amd64/${dep.goPackagePath}.a" "$d/pkg/linux_amd64/${dep.goPackagePath}.a"
    fi
  '' else "" ) buildInputs ) + ''
    mkdir -p "$d/src/$(dirname "${goPackagePath}")"
    ln -s "${toString args.src}" "$d/src/${goPackagePath}"

    for input in $nativeBuildInputs; do
        if [ -d "$input/share/go" ]; then
            echo $input
        fi
    done

    mkdir -p src
    ${rsync}/bin/rsync -a --delete-after $d/src .
    mkdir -p pkg
    ${rsync}/bin/rsync -a $d/pkg .
    export GOPATH="$PWD"
    export GOBIN="$PWD/bin"
    #export PATH="$PATH:$GOBIN"
    #cd $(dirname src/$goPackagePath)
  '';

  disallowedReferences = lib.optional (!allowGoReference) go
    ++ lib.optional (!dontRenameImports) govers;

  passthru = passthru //
    { inherit go; } //
    lib.optionalAttrs (goPackageAliases != []) { inherit goPackageAliases; };

  enableParallelBuilding = enableParallelBuilding;

  # I prefer to call this dev but propagatedBuildInputs expects $out to exist
  outputs = args.outputs or [ "bin" "out" ];

  meta = {
    # Add default meta information
    platforms = go.meta.platforms or lib.platforms.all;
  } // meta // {
    # add an extra maintainer to every package
    maintainers = (meta.maintainers or []) ++
                  [ lib.maintainers.ehmry lib.maintainers.lethalman ];
  };
})
