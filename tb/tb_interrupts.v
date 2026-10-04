`timescale 1ns/1ps
// Directed architectural interrupt tests, independent of the instruction DV model.
module tb_interrupts;
  parameter CPU_TYPE = 0;
  parameter QUEUE_SIZE = 6;
  parameter LATENCY = 1;
  parameter STALLS = 0;
  reg clk = 0, reset = 1;
  always #5 clk = ~clk;
  reg irq_n = 1, firq_n = 1, nmi_n = 1;
  reg [7:0] mem [0:65535];
  wire [15:0] pa, da, dw;
  wire pr, pw, dr, dwidth, we;
  reg [LATENCY-1:0] pack, dack, wack, pwidth, awidth;
  reg [15:0] pdata [0:LATENCY-1], ddata [0:LATENCY-1];
  integer cycles = 0, i, j, cursor, vectors = 0, failures = 0;
  wire pbusy = STALLS && cycles % 5 == 0;
  wire dbusy = STALLS && cycles % 7 < 3;
  turbo9_pipeline #(.TURBO9_CPU_TYPE(CPU_TYPE), .TURBO9_CPU_QUEUE_SIZE(QUEUE_SIZE)) dut (
    .RST_I(reset), .CLK_I(clk), .IRQ_N_I(irq_n), .FIRQ_N_I(firq_n), .NMI_N_I(nmi_n),
    .PMEM_ADR_O(pa), .PMEM_DAT_I(pdata[LATENCY-1]), .PMEM_BUSY_I(pbusy),
    .PMEM_RD_REQ_O(pr), .PMEM_REQ_WIDTH_O(pw), .PMEM_RD_ACK_I(pack[LATENCY-1]),
    .PMEM_ACK_WIDTH_I(pwidth[LATENCY-1]),
    .DMEM_ADR_O(da), .DMEM_DAT_O(dw), .DMEM_DAT_I(ddata[LATENCY-1]),
    .DMEM_BUSY_I(dbusy), .DMEM_REQ_O(dr), .DMEM_REQ_WIDTH_O(dwidth), .DMEM_WE_O(we),
    .DMEM_RD_ACK_I(dack[LATENCY-1]), .DMEM_WR_ACK_I(wack[LATENCY-1]),
    .DMEM_ACK_WIDTH_I(awidth[LATENCY-1])
  );
  `define ra dut.I_turbo9_execute_stage.I_turbo9_register_array
  `define dec dut.I_turbo9_decode_stage
  `define cc dut.I_turbo9_execute_stage.ra_ccr_rd_data
  always @(posedge clk) begin
    cycles <= cycles + 1;
    if (reset) begin
      pack <= 0; dack <= 0; wack <= 0;
    end else begin
      for (j=LATENCY-1; j>0; j=j-1) begin
        pack[j] <= pack[j-1]; dack[j] <= dack[j-1]; wack[j] <= wack[j-1];
        pwidth[j] <= pwidth[j-1]; awidth[j] <= awidth[j-1];
        pdata[j] <= pdata[j-1]; ddata[j] <= ddata[j-1];
      end
      pack[0] <= pr && !pbusy;
      pwidth[0] <= pw;
      // Wide fetch queues take a single-byte reply from the high lane.
      // Replicate the byte so both 8-bit and 16-bit CPU interfaces see it.
      pdata[0] <= pw ? {mem[pa],mem[pa]} : {mem[pa],mem[(pa+1)&16'hffff]};
      dack[0] <= dr && !dbusy && !we;
      wack[0] <= dr && !dbusy && we;
      awidth[0] <= dwidth;
      ddata[0] <= dwidth ? {8'b0,mem[da]} : {mem[da],mem[(da+1)&16'hffff]};
      if (dr && !dbusy && we) begin
        if (dwidth) mem[da] <= dw[7:0];
        else begin mem[da] <= dw[15:8]; mem[(da+1)&16'hffff] <= dw[7:0]; end
      end
    end
  end

  reg [15:0] saved_pc, saved_s, saved_x, saved_y, saved_u;
  reg [7:0] saved_a, saved_b, saved_dp, saved_cc;
  reg [7:0] cwai_mask;
  reg interrupted_prebyte = 0;
  reg cwai_frame = 0;
  reg return_expected = 0;
  reg [7:0] return_cc;
  integer kind, frame_s, frame_len;
  task snapshot;
    begin
      saved_pc = `ra.pc_reg; saved_s = `ra.s_reg;
      saved_x = `ra.x_reg; saved_y = `ra.y_reg; saved_u = `ra.u_reg;
      saved_a = `ra.a_reg; saved_b = `ra.b_reg; saved_dp = `ra.dpr_reg;
      saved_cc = `cc;
    end
  endtask
  task check;
    input condition;
    input [511:0] message;
    begin
      if (condition !== 1'b1) begin
        $display("FAIL: %0s pc=%h micro=%h CC=%h S=%h",message,`ra.pc_reg,
                 `dec.I_turbo9_uop_generator.microcode_adr,`cc,`ra.s_reg);
        failures = failures + 1;
        $fatal(1);
      end
    end
  endtask
  // Capture architectural state after the retiring micro-op, before entry.
  always @(posedge clk) if (!reset && !dut.dec_exe_stall_microcycle && dut.dec_exe_next_instr_ack) begin
    if (`dec.inject_interrupt) begin
      interrupted_prebyte = `dec.page_sel_reg[1];
      if (`dec.wait_mode != 2) begin #1; snapshot; cwai_frame = 0; end
    end else if (`dec.FET_DEC_REG_QUEUE_D0_I == 8'h3f) begin
      #1; snapshot; cwai_frame = 0;
    end else if (!`dec.page_sel_reg[1] && `dec.FET_DEC_REG_QUEUE_D0_I == 8'h3c) begin
      #1; snapshot; saved_cc = saved_cc & cwai_mask; cwai_frame = 1;
    end
  end
  // Compare every byte of the frame before the handler executes.
  always @(posedge clk) if (!reset && dr && !dbusy && !we &&
                            (da == 16'hfff8 || da == 16'hfff6 || da == 16'hfffc ||
                             da == 16'hfffa || da == 16'hfff4 || da == 16'hfff2)) begin
    vectors = vectors + 1;
    kind = da == 16'hfff8 ? 1 : da == 16'hfff6 ? 2 : da == 16'hfffc ? 3 :
           da == 16'hfffa ? 4 : da == 16'hfff4 ? 5 : 6;
    frame_len = kind == 2 && !cwai_frame ? 3 : 12;
    frame_s = (saved_s-frame_len)&16'hffff;
    return_cc = frame_len == 3 ? saved_cc & 8'h7f : saved_cc | 8'h80;
    return_expected = 1;
    check(`ra.s_reg == frame_s, "interrupt frame size");
    check(mem[frame_s] == (frame_len == 3 ? saved_cc & 8'h7f : saved_cc | 8'h80), "stacked CC");
    check({mem[frame_s+frame_len-2],mem[frame_s+frame_len-1]} == saved_pc, "stacked return PC");
    if (frame_len == 12) begin
      check(mem[frame_s+1] == saved_a && mem[frame_s+2] == saved_b, "stacked A/B");
      check(mem[frame_s+3] == saved_dp, "stacked DP");
      check({mem[frame_s+4],mem[frame_s+5]} == saved_x, "stacked X");
      check({mem[frame_s+6],mem[frame_s+7]} == saved_y, "stacked Y");
      check({mem[frame_s+8],mem[frame_s+9]} == saved_u, "stacked U");
    end
    if (kind<=4)
      check(dut.interrupt_masks[0] && (kind == 1 || dut.interrupt_masks[1]), "live interrupt masks");
    else
      check(dut.interrupt_masks=={saved_cc[6],saved_cc[4]}, "SWI2/SWI3 preserve I/F masks");
  end
  always @(posedge clk) if (!reset && return_expected && dut.dec_exe_new_pc_wr_en &&
                            dut.dec_exe_new_pc == saved_pc) begin
    check(`cc == return_cc, "RTI restores every CC bit");
    check(`ra.s_reg == saved_s, "RTI consumes exactly the saved frame");
    return_expected = 0;
  end

  always @(negedge clk) if ($test$plusargs("trace") && !reset && vectors>0 && cycles<280)
    $display("cy=%0d pc=%h s=%h micro=%h st=%b A=%h W=%h addr=%h req=%b we=%b data=%h ack=%b",cycles,`ra.pc_reg,`ra.s_reg,`dec.I_turbo9_uop_generator.microcode_adr,dut.dec_exe_stall_microcycle,dut.dec_exe_uop_data_alu_a_sel,dut.dec_exe_uop_data_alu_wr_sel,da,dr,we,dw,dack[LATENCY-1]);
  task byte_out;
    input [7:0] value;
    begin mem[cursor] = value; cursor = cursor+1; end
  endtask
  reg [1:0] init_method = 0;
  integer method;
  reg delay_stack_init = 0;
  reg irq_from_reset = 0;
  reg [1:0] software_page = 0;
  reg irq_at_prebyte = 0;
  task setup;
    input [7:0] opcode, masks, wait_mask;
    begin
      @(negedge clk); reset = 1; irq_n = 1; firq_n = 1; nmi_n = 1;
      repeat (3) @(negedge clk);
      for (i=0; i<65536; i=i+1) mem[i] = 8'h12;
      mem[16'hfffe]=8'h10; mem[16'hffff]=0;
      mem[16'hfff8]=8'h20; mem[16'hfff9]=0;
      mem[16'hfff6]=8'h21; mem[16'hfff7]=0;
      mem[16'hfffc]=8'h22; mem[16'hfffd]=0;
      mem[16'hfffa]=8'h23; mem[16'hfffb]=0;
      mem[16'hfff4]=8'h24; mem[16'hfff5]=0;
      mem[16'hfff2]=8'h25; mem[16'hfff3]=0;
      for(i=0; i<6; i=i+1) mem[16'h4010+i]=0;
      for (i=0; i<6; i=i+1) begin
        cursor = 16'h2000 + i*256;
        byte_out(8'h7c); byte_out(8'h40); byte_out(8'h10+i); // INC count
        byte_out(8'h3b); // RTI
      end
      cwai_mask=wait_mask;
      cursor=16'h1000;
      if (delay_stack_init) begin
        byte_out(8'h20); byte_out(8'hfe); // Stay here until test releases us.
        cursor=16'h1010;
      end
      if (init_method==0) begin
        byte_out(8'h10); byte_out(8'hce); byte_out(8'h30); byte_out(0); // LDS
      end else begin
        byte_out(8'h8e); byte_out(8'h30); byte_out(0); // LDX #$3000
        case(init_method)
          1: begin byte_out(8'h32); byte_out(8'h84); end // LEAS ,X
          2: begin byte_out(8'h1f); byte_out(8'h14); end // TFR X,S
          3: begin byte_out(8'h1e); byte_out(8'h14); end // EXG X,S
        endcase
      end
      byte_out(8'hce); byte_out(8'h11); byte_out(8'h11); // LDU
      byte_out(8'h8e); byte_out(8'h22); byte_out(8'h22); // LDX
      byte_out(8'h10); byte_out(8'h8e); byte_out(8'h33); byte_out(8'h33); // LDY
      byte_out(8'h86); byte_out(8'h44); byte_out(8'hc6); byte_out(8'h55);
      byte_out(8'h1c); byte_out(0); // ANDCC: enable both masks
      byte_out(8'h1a); byte_out(masks); // ORCC: chosen masks
      if (software_page!=0) byte_out(software_page==2 ? 8'h10 : 8'h11);
      byte_out(opcode);
      if (opcode == 8'h3c) byte_out(wait_mask);
      // A prefixed instruction immediately after either wait must stay queued.
      byte_out(8'h10); byte_out(8'h8e); byte_out(8'h33); byte_out(8'h33);
      byte_out(8'h20); byte_out(8'hfe); // BRA to self
      vectors = 0; cwai_frame = 0; return_expected = 0; reset = 0;
      if (irq_from_reset) begin
        irq_n=0;
        wait(vectors==1); @(negedge clk); irq_n=1;
      end
      if (irq_at_prebyte) begin
        wait(`dec.page_sel_load && dut.fet_dec_nxt_pc==16'h1018);
        @(negedge clk); irq_n=0;
        wait(vectors==1); @(negedge clk); irq_n=1;
      end
      repeat (200) @(negedge clk);
    end
  endtask
  task settle;
    begin
      repeat (250) @(negedge clk);
      check(`ra.s_reg == 16'h3000, "RTI restores S");
      check(`ra.x_reg == 16'h2222 && `ra.y_reg == 16'h3333 && `ra.u_reg == 16'h1111, "RTI restores X/Y/U");
      check(`ra.a_reg == 8'h44 && `ra.b_reg == 8'h55 && `ra.dpr_reg == 0, "RTI restores A/B/DP");
    end
  endtask
  initial begin
    setup(8'h12,0,8'haf);
    irq_n=0; wait(vectors==1); @(negedge clk); irq_n=1; settle;
    check(mem[16'h4010]==1 && vectors==1, "IRQ handler executes once");
    firq_n=0; wait(vectors==2); @(negedge clk); firq_n=1; settle;
    check(mem[16'h4011]==1, "FIRQ handler");
    nmi_n=0; wait(vectors==3); settle;
    check(mem[16'h4012]==1 && vectors==3, "held NMI does not retrigger");
    nmi_n=1; repeat(6) @(negedge clk); nmi_n=0;
    wait(vectors==4); @(negedge clk); nmi_n=1; settle;
    check(mem[16'h4012]==2, "second NMI edge");

    setup(8'h13,0,8'haf);
    check(`dec.wait_mode==1 && mem[16'h4010]==0 && `dec.page_sel_reg==0, "SYNC waits without consuming a prebyte");
    irq_n=0; wait(vectors==1); @(negedge clk); irq_n=1; settle;
    check(mem[16'h4010]==1, "SYNC vectors enabled IRQ");

    setup(8'h3c,0,8'haf);
    check(`ra.s_reg==16'h2ff4 && vectors==0 && `dec.page_sel_reg==0, "CWAI pre-stacks once without consuming a prebyte");
    firq_n=0; wait(vectors==1); @(negedge clk); firq_n=1; settle;
    check(mem[16'h4011]==1, "CWAI FIRQ uses full saved frame");

    setup(8'h13,8'h10,8'haf);
    irq_n=0; repeat(30) @(negedge clk); irq_n=1;
    repeat(100) @(negedge clk);
    check(vectors==0 && `dec.wait_mode==0, "masked IRQ wakes SYNC without vectoring");


    setup(8'h3c,8'h40,8'hff);
    firq_n=0; repeat(100) @(negedge clk);
    check(vectors==0 && `ra.s_reg==16'h2ff4, "masked FIRQ cannot wake CWAI");
    firq_n=1;
    nmi_n=0; wait(vectors==1); @(negedge clk); nmi_n=1; settle;

    setup(8'h13,0,8'haf);
    irq_n=0; firq_n=0; nmi_n=0;
    wait(vectors==1); check(kind==3, "NMI has highest priority");
    @(negedge clk); nmi_n=1;
    wait(vectors==2); check(kind==2, "FIRQ before IRQ");
    @(negedge clk); firq_n=1;
    wait(vectors==3); check(kind==1, "IRQ after FIRQ");
    @(negedge clk); irq_n=1; settle;

    setup(8'h12,8'h50,8'haf);
    irq_n=0; firq_n=0; repeat(100) @(negedge clk);
    check(vectors==0, "I and F independently mask level requests");
    nmi_n=0; wait(vectors==1); @(negedge clk);
    irq_n=1; firq_n=1; nmi_n=1; settle;
    check(kind==3 && mem[16'h4012]==1, "NMI ignores I/F masks");

    setup(8'h12,0,8'haf);
    irq_n=0; wait(vectors==2); @(negedge clk); irq_n=1; settle;
    check(mem[16'h4010]==2 && vectors==2, "held IRQ retriggers after RTI");

    setup(8'h12,0,8'haf);
    irq_n=0;
    wait(dut.interrupt_type==1 && dut.dec_exe_uop_ccr_op==4'h7);
    @(negedge clk); nmi_n=0;
    repeat(4) @(negedge clk); nmi_n=1;
    wait(vectors==1); check(kind==1, "IRQ entry completes before nested NMI");
    @(negedge clk); irq_n=1;
    wait(vectors==2); check(kind==3, "short NMI pulse survives interrupt stacking");
    settle;
    check(mem[16'h4010]==1 && mem[16'h4012]==1, "nested handlers both return");

    irq_from_reset=1;
    setup(8'h12,8'h10,8'haf);
    check(vectors==1 && saved_pc==16'h1014, "ANDCC mask change is visible at retirement");
    settle; irq_from_reset=0;

    irq_at_prebyte=1;
    setup(8'h14,0,8'haf); // EMUL lets decode consume the following prebyte early.
    check(saved_pc==16'h1017 && interrupted_prebyte, "interrupt saves the prefixed instruction start");
    check(`ra.y_reg==16'h3333 && `ra.s_reg==16'h3000, "prefixed instruction executes after RTI");
    irq_at_prebyte=0;

    delay_stack_init=1;
    setup(8'h12,0,8'haf);
    check(!`dec.nmi_armed, "reset disarms NMI");
    nmi_n=0; repeat(40) @(negedge clk);
    check(vectors==0 && !`dec.nmi_pending, "NMI before S initialization is ignored");
    mem[16'h1001]=8'h0e; // Branch to LDS and the rest of the program.
    repeat(200) @(negedge clk);
    check(`dec.nmi_armed && vectors==0, "arming does not invent an NMI edge");
    nmi_n=1; repeat(6) @(negedge clk); nmi_n=0;
    wait(vectors==1); @(negedge clk); nmi_n=1; settle;
    delay_stack_init=0;

    setup(8'h3f,8'h40,8'haf); settle;
    check(vectors==1 && mem[16'h4013]==1, "SWI vector and full RTI");
    software_page=2; setup(8'h3f,8'h40,8'haf); settle;
    check(vectors==1 && mem[16'h4014]==1, "SWI2 vector and full RTI");
    software_page=3; setup(8'h3f,8'h10,8'haf); settle;
    check(vectors==1 && mem[16'h4015]==1, "SWI3 vector and full RTI");
    software_page=0;
    for(method=1; method<=3; method=method+1) begin
      init_method=method; setup(8'h12,0,8'haf);
      check(`dec.nmi_armed, "LEAS/TFR/EXG arm NMI through an explicit S write");
      nmi_n=0; wait(vectors==1); @(negedge clk); nmi_n=1; settle;
    end
    init_method=0;

    $display("PASS interrupts CPU=%0d queue=%0d latency=%0d stalls=%0d",CPU_TYPE,QUEUE_SIZE,LATENCY,STALLS);
    $finish;
  end
  initial begin #200000; $fatal(1,"interrupt test timeout pc=%h vectors=%0d",`ra.pc_reg,vectors); end
endmodule
