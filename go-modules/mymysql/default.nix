{ fetchFromGitHub, go }:

go.buildGoPackage {
  name = "mymysql";

  goPackagePath = "github.com/ziutek/mymysql";
  src = fetchFromGitHub {
    owner = "ziutek";
    repo = "mymysql";
    rev = "1d19cbf98d83564cc561192ae7d7183d795f7ac7";
    sha256 = "11fhqx5kpzcygz68c6hk64rvhz8r6ch5dj1jvff97hygiqvmvv11";
  };
}
