{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "pq";

  goPackagePath = "github.com/lib/pq";
  src = fetchFromGitHub {
    owner = "lib";
    repo = "pq";
    rev = "b77235e3890a962fe8a6f8c4c7198679ca7814e7";
    sha256 = "1jd7x5nmbchg3i0nirb34v171s33y99iam306xa5v16hxc1acql6";
  };
}
