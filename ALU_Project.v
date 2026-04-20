module ALU_Project ( 
input       
[15:0]   A, B, 
input                
input       
Cin, 
[4:0]    F, 
output reg  [15:0]  Result, 
output reg  [5:0]   Status 
); 
reg CF, ZF, NF, VF, PF, AF; 
reg  [4:0] AUX_Test; 
reg  [16:0] two_comp; 
always @ (*) begin 
Result = 16'b0; 
CF = 1'b0; 
ZF = 1'b0; 
NF = 1'b0; 
VF = 1'b0; 
PF = 1'b0; 
AF = 1'b0; 
// Arithmetic Block 
case (F) 
5'b00000:       
begin 
// NOP 
Result = 16'b0; 
end 
5'b00001:       
begin 
// INC A 
{CF , Result} = A + 1'b1; 
VF = (A[15] == 1'b0 && Result[15] == 1'b1); 
AF = A[0] && A[1] && A[2] && A[3]; 
end 
5'b00010:       
begin 
// CLEAR 
Result = 16'b0; 
end 
5'b00011:       
begin 
// DEC A 
{CF , Result} = A - 1'b1; 
VF = (A[15] == 1'b1 && Result == 1'b0); 
AF = ~( A[0] && A[1] && A[2] && A[3] ); 
end 
 
5'b00100:       // ADD A, B 
begin 
 {CF , Result} = A + B; 
 VF = (A[15] == B[15] && A[15] != Result[15]); 
 AUX_Test = A[3:0] + B[3:0]; 
 AF = AUX_Test[4]; 
end 
 
5'b00101:       // ADC A, B (Add with carry) 
begin 
 {CF , Result} = A + B + Cin; 
 VF = (A[15] == B[15] && A[15] != Result[15]); 
 AUX_Test = A[3:0] + B[3:0] + Cin; 
 AF = AUX_Test[4]; 
end 
 
5'b00110:       // SUB A, B 
begin 
 {CF , Result} = A - B; 
 two_comp = ~B + 1; 
 VF = (A[15] == two_comp[15] && A[15] != Result[15]); 
 AUX_Test = A[3:0] - B[3:0]; 
 AF = AUX_Test[4]; 
end 
 
5'b00111:       // SBB A, B (Subtract with borrow) 
begin 
 {CF , Result} = A - B - Cin; 
 two_comp = ~B + 1; 
 VF = (A[15] == two_comp[15] && A[15] != Result[15]); 
 AUX_Test = A[3:0] - B[3:0] - Cin; 
 AF = AUX_Test[4]; 
end 
 
// Logic Block 
 
5'b01000:       // AND A, B 
begin 
 Result = A & B; 
end 
 
5'b01001:       // OR A, B 
begin 
 Result = A | B; 
end 
 
5'b01010:       // XOR A, B 
begin 
 Result = A ^ B; 
end 
 
5'b01011:       // NOT A 
begin 
 Result = ~A; 
end 
 
// Shift & Rotate Block 
 
5'b10000:       // SHL (Logical left shift) 
begin 
 CF = A[15]; 
 Result = A << 1; 
end 
 
5'b10001:       // SHR (Logical right shift) 
begin 
 CF = A[0]; 
 Result = A >> 1; 
end 
 
5'b10010:       // SAL (Arithmetic left shift) 
begin 
 CF = A[15]; 
 Result = A <<< 1; 
end 
 
5'b10011:       // SAR (Arithmetic right shift) 
begin 
 CF = A[0]; 
 Result = $signed(A) >>> 1; 
end 
 
5'b10100:       // ROL (Rotate left) 
begin 
 CF = A[15]; 
 Result = {A[14:0] , A[15]}; 
end 
 
5'b10101:       // ROR (Rotate right) 
begin 
 CF = A[0]; 
 Result = {A[0] , A[15:1]}; 
end 
 
5'b10110:       // RCL (Rotate left through carry) 
begin 
Result = {A[14:0] , CF}; 
CF = A[15]; 
end 
5'b10111:       
begin 
// RCR (Rotate right through carry) 
Result = {CF , A[15:1]}; 
CF = A[0]; 
end 
default:        
begin 
// DEFAULT 
Result = 16'b0; 
end 
endcase 
ZF = ~|Result; 
PF = ~^Result; 
NF = Result[15]; 
Status = {CF, ZF, NF, VF, PF, AF}; 
end 
endmodule
