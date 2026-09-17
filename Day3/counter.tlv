\m4_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
\TLV
   $reset = *reset;
   $num[3:0] = $reset ? 4'b0 : >>1$num + 4'b1;
   *passed = *cyc_cnt > 20;
   *failed = 1'b0;
\SV
   endmodule
