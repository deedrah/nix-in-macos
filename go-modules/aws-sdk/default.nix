{ go, fetchFromGitHub }:
go.buildGoPackage {
  name = "aws-sdk";

  goPackagePath = "github.com/aws/aws-sdk-go";
  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-sdk-go";
    rev = "9350193373dc6d4bb4d6af55675c11ca7fc4230c";
    sha256 = "0n9b1szwf69mjmf7dgl1b2hv3aqjhih2pvfcjxnv1xgbigm821w2";
  };
}
