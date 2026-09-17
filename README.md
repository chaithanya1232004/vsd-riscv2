# RISC-V Based MYTH (Microprocessor for You in Thirty Hours) Workshop

This repository contains all the code, lab work, terminal logs, and documentation for the 5-day RISC-V workshop.

---

## Day 1: Introduction to RISC-V ISA and GNU Compiler Toolchain

### 1. C Program Compilation (Native GCC)
**Command:**
```bash
cd Day1
gcc sum1ton.c
./a.out


Expected output:

```text
Sum from 1 to 9 is 45
```


### 2. RISC-V Cross-Compilation & Spike Simulation
Command:

riscv64-unknown-elf-gcc -Ofast -mabi=lp64 -march=rv64i -o sum1ton.o sum1ton.c
spike pk sum1ton.o

Expected output:

```
bbl loader
Sum from 1 to 9 is 45
```

### 3. Compiler Optimization Comparison (-O0 vs -Ofast)
Command:
riscv64-unknown-elf-objdump -d sum1ton.o | less

Expected output:

```
00000000000100b0 <main>:
   100b0:	00021537          	lui	a0,0x21
   100b4:	ff010113          	addi	sp,sp,-16
   100b8:	02d00613          	li	a2,45
   100bc:	00900593          	li	a1,9
```
Observation: Pre-computes loop result (45) directly at compile time into register a2.

Command (-O0):
riscv64-unknown-elf-gcc -O0 -mabi=lp64 -march=rv64i -o sum1ton_O0.o sum1ton.c
riscv64-unknown-elf-objdump -d sum1ton_O0.o | less

Observation: Generates full loop control instructions (bge, sw, lw, addi) and stack operations.

---

---
## Day 2: Introduction to ABI and C-Assembly Integration
### 1. C-Assembly Function Call (1ton_custom.c + load.S)
Command:
cd ../Day2
riscv64-unknown-elf-gcc -O1 -mabi=lp64 -march=rv64i -o 1ton_custom.o 1ton_custom.c load.S
spike pk 1ton_custom.o

Expected output:

```
bbl loader
Sum of number from 1 to 2 is 3
```

### 2. Disassembly Verification of ABI Registers
Command:
riscv64-unknown-elf-objdump -d 1ton_custom.o | less

Expected Output:
```
0000000000010184 <main>:
   10184:	ff010113          	addi	sp,sp,-16
   10188:	00113423          	sd	   ra,8(sp)
   1018c:	00300593          	li	   a1,3
   10190:	00000513          	li	   a0,0
   10194:	028000ef          	jal	ra,101bc <load>
   ```
Observation: Confirms argument passing via registers a0 (0x0) and a1 (3) prior to calling load.

### 3. PicoRV32 Core Testbench RTL Simulation
Command:
cd ../riscv_workshop_collaterals/labs
chmod +x rv32im.sh
./rv32im.sh

Expected Output:
```
Sum of number from 1 to 2 is 3
TRAP
```
Observation: Verifies C-assembly firmware execution on the PicoRV32 Verilog RTL model via iverilog testbench simulation.
---

---
## Day 3: Digital Logic with TL-Verilog and Makerchip

### 1. Combinational Logic (Inverter)
Designed a basic 4-bit inverter circuit in Makerchip IDE using TL-Verilog syntax.

**Code(`combinational.tlv`):**
\m4_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
\TLV
   $reset = *reset;
   
   // Combinatorial Inverter Logic
   $out[3:0] = ~ $in[3:0];

   *passed = *cyc_cnt > 20;
   *failed = 1'b0;
\SV
   endmodule

Simulation Output / Waveform Analysis:
Cycles: 0 to 20
$in :  0   5   d   5   2   0   3   4   7   5 ...
$out:  f   a   2   a   d   f   c   b   8   a ...

Observation: Confirms 1's complement bitwise inversion (e.g., input 0x0 outputs 0xF).

### 2. Sequential Logic (4-Bit Counter)
Implemented a sequential counter utilizing the cycle delay operator (`>>1`).

**Code(counter.tlv):**

\m4_TLV_version 1d: tl-x.org
\SV
   m5_makerchip_module
\TLV
   $reset = *reset;

   // 4-bit Sequential Counter
   $num[3:0] = $reset ? 4'b0 : >>1$num + 4'b1;

   *passed = *cyc_cnt > 20;
   *failed = 1'b0;
\SV
   endmodule

Simulation Output / Waveform Analysis:
Cycles: 0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 ...
$reset: 1  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0  0 ...$num  : 0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f  0 ...

Observation: Output $num resets to 0 when $reset is active, then increments on every clock cycle, rolling over after reaching 0xF.

*Observation:* The counter resets to `0` when `$reset` is high and increments by `1` on every positive clock edge when reset goes low.

---