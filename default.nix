{ pkgs ? import ( fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-17.09.tar.gz ) {} }:
with pkgs;
let
  callPackage = lib.callPackageWith (pkgs // bigone);

  bigone = rec {
    go = ( pkgs.go_1_8.override { git = "-"; subversion="-"; mercurial="-"; bazaar="-"; } ) // rec {
      buildGoPackage = callPackage ./build-support/build-go-package.nix {};
      compile-protos = callPackage ./build-support/go-compile-protos { python = python3; protobuf = protobuf3_3; };

      grpc = callPackage ./go-modules/grpc {};
      protobuf = callPackage ./go-modules/protobuf {};
      genproto = callPackage ./go-modules/genproto {};
      cmux = callPackage ./go-modules/cmux {};
      logrus = callPackage ./go-modules/logrus {};
      grpc-middleware = callPackage ./go-modules/grpc-middleware {};
      dns = callPackage ./go-modules/dns {};
      aws-sdk = callPackage ./go-modules/aws-sdk {};
      golang-set = callPackage ./go-modules/golang-set {};
      envconfig = callPackage ./go-modules/envconfig {};
      cloud = callPackage ./go-modules/cloud {};
      glog = callPackage ./go-modules/glog {};
      httpstat = callPackage ./go-modules/httpstat {};
      mapstructure = callPackage ./go-modules/mapstructure {};
      golang-geo = callPackage ./go-modules/golang-geo {};
      testdb = callPackage ./go-modules/testdb {};
      gypsy = callPackage ./go-modules/gypsy {};
      pq = callPackage ./go-modules/pq {};
      mymysql = callPackage ./go-modules/mymysql {};
      arg = callPackage ./go-modules/arg {};
      zap = callPackage ./go-modules/zap {};

      x = {
        crypto = callPackage ./go-modules/x/crypto.nix {};
        oauth2 = callPackage ./go-modules/x/oauth2.nix {};
        net = callPackage ./go-modules/x/net.nix {};
        sys = callPackage ./go-modules/x/sys.nix {};
        text = callPackage ./go-modules/x/text.nix {};
        tools = callPackage ./go-modules/x/tools.nix {};
      };
    };

    goutils = callPackage ./goutils {};
    iris = callPackage ./iris {};
    iris-weather = callPackage ./iris-weather {};
    iris-music = callPackage ./iris-music {};
    hintapi = callPackage ./hintapi {};

    images = {
      iris = dockerTools.buildImage {
        name = "iris";

        contents = [ iris ];
      };
    };
  };

in bigone
