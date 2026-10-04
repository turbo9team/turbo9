`timescale 1ns/1ps
// Boot real TurbOS images against the RTL with Hyper9-compatible timer/terminal I/O.
module tb_turbos;
  parameter CPU_TYPE = 0;
  parameter DEV_IMAGE = 0;
  parameter QUEUE_SIZE = 6;
  parameter LATENCY = 1;
  parameter STALLS = 0;
  reg clk = 0, reset = 1;
  always #5 clk = ~clk;
  reg firq_n = 1, nmi_n = 1;
  reg [7:0] mem [0:65535];
  reg [7:0] status = 0, control = 0;
  wire irq_n = !(|(status[1:0] & control[1:0]));
  integer ticks = 0, output_count = 0, serviced_ticks = 0;
  integer prompts = 0, input_index = 0, terminal_irqs = 0;
  reg [7:0] rx_byte = 0;
  reg [47:0] command_bytes = {"mfree",8'h0d};
  reg [71:0] output_tail = 0;
  reg booted = 0, command_ran = 0;
  reg [4095:0] image;
  function [7:0] read_byte;
    input [15:0] address;
    begin
      case(address)
        16'hff01: read_byte = rx_byte;
        16'hff02: read_byte = status;
        16'hff03: read_byte = control;
        default: read_byte = mem[address];
      endcase
    end
  endfunction
  wire [15:0] pa, da, dw;
  wire pr, pw, dr, dwidth, we;
  reg [LATENCY-1:0] pack, dack, wack, pwidth, awidth;
  reg [15:0] pdata [0:LATENCY-1], ddata [0:LATENCY-1];
  integer cycles = 0, j;
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
  always @(posedge clk) begin
    cycles <= cycles + 1;
    if ($test$plusargs("trace") && cycles % 10000 == 0) $display("cycle=%0d pc=%h s=%h control=%h status=%h",cycles,`ra.pc_reg,`ra.s_reg,control,status);
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
      ddata[0] <= dwidth ? {8'b0,read_byte(da)} : {read_byte(da),read_byte(da+16'd1)};
      if (DEV_IMAGE && booted && input_index < 6 && !status[1] && cycles % 5000 == 0) begin
        rx_byte <= command_bytes[47:40];
        command_bytes <= {command_bytes[39:0],8'b0};
        input_index <= input_index+1;
        status[1] <= 1;
      end
      if (control[0] && cycles % 20000 == 0) begin status[0] <= 1; ticks <= ticks+1; end
      if (dr && !dbusy && we) begin
        if (dwidth) begin
          case(da)
            16'hff00: begin
              if ({output_tail[63:0],dw[7:0]} == "pages fre") command_ran <= 1;
              $write("%c",dw[7:0]); output_count <= output_count+1;
              output_tail <= {output_tail[63:0],dw[7:0]};
              if ((!DEV_IMAGE && {output_tail[63:0],dw[7:0]} == "TurbOS OK") ||
                  (DEV_IMAGE && {output_tail[23:0],dw[7:0]} == "TOS:")) begin
                booted <= 1;
                if (DEV_IMAGE) prompts <= prompts+1;
              end
            end
            16'hff02: begin
              status <= status & ~dw[7:0];
              if (dw[0] && status[0]) serviced_ticks <= serviced_ticks+1;
              if (dw[1] && status[1]) terminal_irqs <= terminal_irqs+1;
            end
            16'hff03: control <= dw[7:0];
            default: mem[da] <= dw[7:0];
          endcase
        end
        else begin mem[da] <= dw[15:8]; mem[(da+1)&16'hffff] <= dw[7:0]; end
      end
    end
  end

  initial begin
    if (!$value$plusargs("image=%s",image)) $fatal(1,"missing +image hex file");
    $readmemh(image,mem);
    repeat(5) @(negedge clk);
    reset = 0;
    repeat(DEV_IMAGE ? 600000 : 120000) @(negedge clk);
    if (!booted) $fatal(1,"TurbOS boot timeout pc=%h s=%h outputs=%0d ticks=%0d",`ra.pc_reg,`ra.s_reg,output_count,ticks);
    if (DEV_IMAGE && (prompts < 2 || terminal_irqs != 6 || !command_ran)) $fatal(1,"shell command failed prompts=%0d terminal IRQs=%0d",prompts,terminal_irqs);
    if (ticks < 5 || serviced_ticks < 4) $fatal(1,"timer did not run");
    $display("PASS TurbOS boot CPU=%0d ticks=%0d",CPU_TYPE,serviced_ticks);
    $finish;
  end
endmodule
