{ fetchFromGitHub, go }:
go.buildGoPackage {
  name = "dns";

  goPackagePath = "github.com/miekg/dns";
  src = fetchFromGitHub {
    owner = "miekg";
    repo = "dns";
    rev = "aade52d68e0bf400ae55afd3adadffce3b027043";
    sha256 = "0ibjp1xfirbjydssd6nxqi9ywpp6jzh8crrwnagx8v87mx8wdzh1";
  };
}

