module tb();

    reg[3:0] A, B, S;
    reg CN, M;

    wire[3:0] F;
    wire AEB, X, Y, CN4;

    // Operands
    reg[3:0] F_expected;

    // instantiate unit under test
    alu74181 uut(
      .S(S),
      .A(A),
      .B(B),
      .M(M),
      .CNb(CN),
      .F(F),
      .X(X),
      .Y(Y),
      .CN4b(CN4),
      .AEB(AEB)
    );

    initial
    begin
      $dumpfile("alu74181.vcd");
      $dumpvars(0,tb);
      $display("Start testing");
      #10;
      {S, A, B, M, CN} = 14'b10011111000000;
      #10;
      $display("Results");
      $display("F=%b", F);
      $display("C=%b", CN4);
      $display("X=%b", X);
      $display("Y=%b", Y);
    end

    // check results on falling edge of clk
endmodule
