{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "x.tools";

  goPackagePath = "golang.org/x/tools";
  src = fetchFromGitHub {
    owner = "golang";
    repo = "tools";
    rev = "68e087e2a5786de2c035ed544b1c5a42e31f1933";
    sha256 = "1i0ix9w14fjbc7w7kdmzv16ys9nlrzyh2l85sdmwipi5mvhwijdm";
  };
}
