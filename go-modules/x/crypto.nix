{ fetchgit, go }:

go.buildGoPackage {
  name = "x.crypto";

  goPackagePath = "golang.org/x/crypto";
  src = fetchgit {
    url = "https://go.googlesource.com/crypto";
    rev = "a548aac93ed489257b9d959b40fe1e8c1e20778c";
    sha256 = "022vl9s6hf8qzdrxfivzd3dg1gsr1vns0j3a3xfdkgv5z9qyvy83";
  };

  goDeps = with go; [ x.net ];
}
