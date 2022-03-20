/*************************************************************************/
/* 74181 - A historic 4 bit ALU                                          */
/*************************************************************************/

module alu74181 (

`ifdef USE_POWER_PINS
	inout vccd1,
	inout vssd1,
`endif

  input [3:0] A, B, S,
  input CNb, M,
  output [3:0] F,
  output AEB, X, Y, CN4b,
  output [7:0] io_oeb
);

  assign io_oeb = 8'b0;

  top_alu74181 top_alu74181 (A, B, S, CNb, M, F, AEB, X, Y, CN4b);

endmodule

/*************************************************************************/

module top_alu74181 (

  input [3:0] A, B, S,
  input CNb, M,
  output [3:0] F,
  output AEB, X, Y, CN4b
);

  wire [3:0] E, D, C, Bb;

  e_module e_mod (A, B, S, E);
  d_module d_mod (A, B, S, D);
  cla_module cla_mod (E, D, CNb, C, X, Y, CN4b);
  sum_module sum_mod (E, D, C, M, F, AEB);

endmodule

/*************************************************************************/

module e_module (

  input [3:0] A, B, S,
  output [3:0] E
);

  wire [3:0]  ABS3, ABbS2;

  assign ABS3 = A&B&{4{S[3]}};
  assign ABbS2 = A&~B&{4{S[2]}};
  assign E = ~(ABS3|ABbS2);

endmodule

/*************************************************************************/

module d_module (

  input [3:0] A, B, S,
  output [3:0] D
);

  wire [3:0]  BbS1, BS0;

  assign BbS1 = ~B&{4{S[1]}};
  assign BS0 = B&{4{S[0]}};
  assign D = ~(BbS1|BS0|A);

endmodule

/*************************************************************************/

module cla_module (

  input [3:0] Gb, Pb,
  input CNb,
  output [3:0] C,
  output X, Y, CN4b
);

  assign C[0] = ~CNb;
  assign C[1] = ~(Pb[0]|(CNb&Gb[0]));
  assign C[2] = ~(Pb[1]|(Pb[0]&Gb[1])|(CNb&Gb[0]&Gb[1]));
  assign C[3] = ~(Pb[2]|(Pb[1]&Gb[2])|(Pb[0]&Gb[1]&Gb[2])|(CNb&Gb[0]&Gb[1]&Gb[2]));
  assign X = ~&Gb;
  assign Y = ~(Pb[3]|(Pb[2]&Gb[3])|(Pb[1]&Gb[2]&Gb[3])|(Pb[0]&Gb[1]&Gb[2]&Gb[3]));
  assign CN4b = ~(Y&~(&Gb&CNb));

endmodule

/*************************************************************************/

module sum_module (

  input [3:0] E, D, C,
  input M,
  output [3:0] F,
  output AEB
);

  assign F = (E ^ D) ^ (C|{4{M}});
  assign AEB = &F;

endmodule
