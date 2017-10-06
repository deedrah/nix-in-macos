{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "golang-geo";

  goPackagePath = "github.com/kellydunn/golang-geo";
  src = fetchFromGitHub {
    owner = "kellydunn";
    repo = "golang-geo";
    rev = "6f16b0ccf2a6ebd1a234daacfb6199510fbd0db4";
    sha256 = "05c2mr422pci29cg2fv8mw84pibk7igzshnacx9i911p3pf1mbjd";
  };

  buildInputs = with go; [ testdb gypsy pq mymysql ];
}
