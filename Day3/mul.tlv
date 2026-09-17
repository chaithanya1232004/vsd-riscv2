\m4_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
\TLV
   $reset = *reset;
   $out[3:0] = ~$in[3:0];
   *passed = *cyc_cnt > 20;
   *failed = 1'b0;
\SV
   endmodule
