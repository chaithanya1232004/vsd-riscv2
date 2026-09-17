\m4_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
\TLV
   $reset = *reset;
   $val1[31:0] = >>1$out[31:0];
   $val2[31:0] = {28'b0, $rand2[3:0]};
   
   $sum[31:0]  = $val1 + $val2;
   $diff[31:0] = $val1 - $val2;
   $prod[31:0] = $val1 * $val2;
   $quot[31:0] = $val1 / $val2;
   
   $out[31:0]  = $reset ? 32'b0 :
                 ($op[1:0] == 2'b00) ? $sum :
                 ($op[1:0] == 2'b01) ? $diff :
                 ($op[1:0] == 2'b10) ? $prod : $quot;
   *passed = *cyc_cnt > 20;
   *failed = 1'b0;
\SV
   endmodule
