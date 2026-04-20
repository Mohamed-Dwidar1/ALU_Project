`timescale 1ns/1ps 
module ALU_TB; 
 
reg  [15:0] A; 
reg  [15:0] B; 
reg         Cin; 
reg  [4:0]  F; 
 
wire [15:0] Result; 
wire [5:0]  Status; 
 
integer f; 
 
ALU_Project uut ( 
    .A(A), 
    .B(B), 
    .Cin(Cin), 
    .F(F), 
    .Result(Result), 
    .Status(Status) 
); 
 
initial begin 
    $display("One-pass full-opcode random operands test"); 
    $display("Each opcode F=0..31 is exercised once with random A,B,Cin"); 
    $display("Time  F   A     B     Cin  Result   Status(C Z N V P A)"); 
    $display("----  --  ----  ----  ----  -------- -----------------"); 
 
 
    for (f = 0; f < 32; f = f + 1) begin 
        F = f[4:0]; 
 
        // random operands for this single test of opcode F 
        A   = $urandom; 
        B   = $urandom; 
        Cin = $urandom & 1; 
 
        #2; // let outputs settle 
 
        $display("%4dns  %2d  %04h  %04h   %b   %04h    %b %b %b %b %b %b", 
                 $time, 
                 F, 
                 A, 
                 B, 
                 Cin, 
                 Result, 
                 Status[5], // CF 
                 Status[4], // ZF 
                 Status[3], // NF 
                 Status[2], // VF 
                 Status[1], // PF 
                 Status[0]  // AF 
                ); 
    end 
 
    $display("Finished one-pass test for all 32 opcodes."); 
    $finish; 
end 
 
endmodule
