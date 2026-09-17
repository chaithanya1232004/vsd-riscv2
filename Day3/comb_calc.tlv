\m4_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
\TLV
   $reset = *reset;

   // 1. Inputs using valid random inputs
   $val1[31:0] = {28'b0, $rand[3:0]};
   $val2[31:0] = {28'b0, $rand[7:4]};
   $op[1:0]    = $rand[9:8];

   // 2. Arithmetic Logic Operations
   $sum[31:0]  = $val1 + $val2;
   $diff[31:0] = $val1 - $val2;
   $prod[31:0] = $val1 * $val2;
   $quot[31:0] = $val1 / $val2;

   // 3. Mux Selection based on $op[1:0]
   $out[31:0]  = ($op[1:0] == 2'b00) ? $sum :
                 ($op[1:0] == 2'b01) ? $diff :
                 ($op[1:0] == 2'b10) ? $prod : $quot;

   // Silence unused signal warnings
   `BOGUS_USE($out $reset)

   // Assertions for testbench completion
   *passed = *cyc_cnt > 20;
   *failed = 1'b0;
\SV
   endmodule