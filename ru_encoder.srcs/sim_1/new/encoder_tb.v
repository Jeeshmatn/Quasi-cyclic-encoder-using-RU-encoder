module encoder_tb;

  // Testbench signals
  reg [5:0] S;
  reg clk;
  reg rst;
  wire [11:0] encoded_data;

  // Instantiate the encoder module
  encoder uut (
    .S(S),
    .clk(clk),
    .rst(rst),
    .encoded_data(encoded_data)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10 time units period
  end

  // Test sequence
  initial begin
    // Initialize signals
    S = 6'b011010; // Example input vector
    rst = 1;
    
    // Reset the system
    #100;
    rst = 0;

    // Wait for computation
    #500;

    // Display results
    $display("Test results:");
    $display("Encoded Data: %b", encoded_data);

    // End simulation
    $finish;
  end

endmodule
