pragma circom 2.0.0;

include "../ed25519-circom/circuits/batchverify.circom";
include "../ed25519-circom/node_modules/circomlib/circuits/bitify.circom";

template Verify50_256() {
  signal input msg[2];

  signal input A[50][256];
  signal input R8[50][256];
  signal input S[50][255];

  signal input PointA[50][4][3];
  signal input PointR[50][4][3];

  signal output hash[2];
  signal output verified;

  component bitifyPart1 = Num2Bits(254);
  component bitifyPart2 = Num2Bits(254);
  component bv = BatchVerify(256, 50);

  var i;
  var j;
  var k;

  bitifyPart1.in <== msg[0];
  bitifyPart2.in <== msg[1];

  for(i=0; i<128; i++) {
    bv.msg[i] <== bitifyPart1.out[i];
    bv.msg[i+128] <== bitifyPart2.out[i];
  }
  for (i=128; i<254; i++) {
    bitifyPart1.out[i] === 0;
    bitifyPart2.out[i] === 0;
  }

  for (i=0; i<50; i++) {
    for (j=0; j<255; j++) {
      bv.A[i][j] <== A[i][j];
      bv.R8[i][j] <== R8[i][j];
      bv.S[i][j] <== S[i][j];
    }
    bv.A[i][255] <== A[i][255];
    bv.R8[i][255] <== R8[i][255];

    for (j=0; j<4; j++) {
      for (k=0; k<3; k++) {
        bv.PointA[i][j][k] <== PointA[i][j][k];
        bv.PointR[i][j][k] <== PointR[i][j][k];
      }
    }
  }
}

component main {public [msg]} = Verify50_256();