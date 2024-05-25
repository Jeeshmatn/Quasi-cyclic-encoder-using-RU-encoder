module encoder (
    input [5:0] S,
    input clk,
    input rst,
    output reg [11:0] encoded_data
);

  // Parameters
  parameter N = 2; // Rows in F | Columns of B | Columns of R1 | Rows of R1_T
  parameter M = 4; // Columns in F and Rows in C and Row of B
  parameter P = 4; // Columns in matrix C | Rows in matrix A
  parameter Q = 6; // Columns in matrix A and columns in S (Rows in S_T)
  parameter T = 1; // Rows of S (Columns of S1_T) | Rows of R1 | Colums of R1_T

  // Inputs (Use wire for constants instead of reg)
  wire [N*M-1:0] F = 8'b01110010; // 2x4 matrix
  wire [M*P-1:0] C = 16'b0001100011011110; // 4x4 matrix
  wire [P*Q-1:0] A = 24'b110011111001000110001101; // 4x6 matrix
  wire [M*2-1:0] B = 8'b01100100; // 4x2 matrix
  wire [N*T-1:0] R1; // Result of (F * C) * A * S_T (stores R1_T : 2 x 1 matrix) // Also R1: 1 x 2 matrix 
  // Outputs
  wire [N*P-1:0] FC; // Result of F * C
  wire [N*Q-1:0] FCA; // Result of (F * C) * A
  //wire [N*T-1:0] FCAS_T; // Result of (F * C) * A * S_T
  wire [P*T-1:0] AS_T; //Result of A * S_T
  wire [M*T-1:0] CAS_T; //Result of C * A * S_T
  wire [M*T-1:0] BR1_T; //Result of C * A * S_T
  wire [P*T-1:0] R2; // Result of bitwise OR between FCAS_T and BR1_T // Stores R2_T : 4x1 matrix | R2: 1x4 Matrix

  integer i, j;

  // Instantiate matrix_mult modules
  matrix_mult #(N, M, P) multFC (
    .clk(clk),
    .rst(rst),
    .M1(F),
    .M2(C),
    .result(FC)
  );

  matrix_mult #(N, P, Q) multFCA (
    .clk(clk),
    .rst(rst),
    .M1(FC),
    .M2(A),
    .result(FCA)
  );
  
  matrix_mult #(N, Q, T) multFCAS_T (
    .clk(clk),
    .rst(rst),
    .M1(FCA),
    .M2(S),
    .result(R1)
  );
 
  matrix_mult #(P, Q, T) multAS_T (
  .clk(clk),
  .rst(rst),
  .M1(A),
  .M2(S),
  .result(AS_T)
  );

  matrix_mult #(M, M, T) multCAS_T (
  .clk(clk),
  .rst(rst),
  .M1(C),
  .M2(AS_T),
  .result(CAS_T)
  );

  matrix_mult #(M, N, T) multBR1_T (
  .clk(clk),
  .rst(rst),
  .M1(B),
  .M2(R1),
  .result(BR1_T)
  );
  
  // Bitwise OR operation between FCAS_T and BRT
  assign R2 = CAS_T | BR1_T;
  // Display results
  
    // Sequential block
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      encoded_data <= 12'b0;
    end else begin
      encoded_data <= {S, R1, R2};
    end
  end
  initial begin
    // Wait for a few clock cycles
    #50;
    
    // Release reset
    // rst = 0; // You should handle reset outside of the initial block

    // Wait for a few clock cycles to allow computation
    #200;
    
    $display("Result of F * C:");
    for (i = N-1; i >= 0; i = i - 1) begin
      for (j = P-1; j >= 0; j = j - 1) begin
        $write("%b ", FC[i*P + j]);
      end
      $display("");
    end
    
    $display("Result of (F * C) * A:");
    for (i = N-1; i >= 0; i = i - 1) begin
      for (j = Q-1; j >= 0; j = j - 1) begin
        $write("%b ", FCA[i*Q + j]);
      end
      $display("");
    end
    
    $display("Result of R1_T:");
    for (i = N-1; i >= 0; i = i - 1) begin
      for (j = T-1; j >= 0; j = j - 1) begin
        $write("%b ", R1[i*T + j]);
      end
      $display("");
    end
    
    $display("Result of A * S_T:");
    for (i = P-1; i >= 0; i = i - 1) begin
      for (j = T-1; j >= 0; j = j - 1) begin
        $write("%b ", AS_T[i*T + j]);
      end
      $display("");
    end
    
    $display("Result of C * A * S_T:");
    for (i = M-1; i >= 0; i = i - 1) begin
      for (j = T-1; j >= 0; j = j - 1) begin
        $write("%b ", CAS_T[i*T + j]);
      end
      $display("");
    end
    
    $display("Result R2_T:");
    for (i = P-1; i >= 0; i = i - 1) begin
      for (j = T-1; j >= 0; j = j - 1) begin
        $write("%b ", R2[i*T + j]);
      end
      $display("");
    end
    
     //encoded_data <= {S, R1, R2};
  end
  
endmodule
