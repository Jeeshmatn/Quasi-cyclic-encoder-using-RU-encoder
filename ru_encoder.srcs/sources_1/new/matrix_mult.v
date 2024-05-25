//N: Number of rows in matrix1 and result matrix. 4
//M: Number of columns in matrix1 and rows in matrix2. 2
//P: Number of columns in matrix2 and result matrix. 1
module matrix_mult #(parameter N=3, parameter M=3, parameter P=3)(
    input clk,       // Clock input
    input rst,       // Reset input
    input [N*M-1:0] M1, // Input matrix 1 (single dimension)
    input [M*P-1:0] M2, // Input matrix 2 (single dimension)
    output reg [N*P-1:0] result // Result matrix (single dimension)
);

integer i, j, k;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset the result matrix
        result <= 0;
    end else begin
        // Iterate through each element of the result matrix
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < P; j = j + 1) begin
                // Initialize result element to 0
                result[i*P + j] = 0;
                // Compute result element using bitwise XOR and AND operations
                for (k = 0; k < M; k = k + 1) begin
                    result[i*P + j] = result[i*P + j] ^ (M1[i*M + k] & M2[k*P + j]);
                end
            end
        end
    end
end

endmodule

