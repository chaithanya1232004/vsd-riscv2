\m4_TLV_version 1d: tl-x.org
\SV
   `include "sqrt32.v";
   m5_makerchip_module
\TLV
   |calc
      // Pythagoras's Theorem Example
      @1
         $aa_sq[7:0] = $aa[3:0] * $aa[3:0];
         $bb_sq[7:0] = $bb[3:0] * $bb[3:0];
      @2
         $cc_sq[8:0] = $aa_sq + $bb_sq;
      @3
         $cc[4:0]    = sqrt($cc_sq);

   // Stop simulation after 40 cycles
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
