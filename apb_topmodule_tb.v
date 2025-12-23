module apb_topmodule_tb();

    reg pclk, presetn, read_write, transfer;
    reg [7:0] apb_write_paddr, apb_read_paddr, apb_write_data;
    wire pready, pslaverr;
    wire [7:0] prdata;

    apb_topmodule dut (
        .pclk(pclk),
        .presetn(presetn),
        .read_write(read_write),
        .transfer(transfer),
        .apb_write_paddr(apb_write_paddr),
        .apb_read_paddr(apb_read_paddr),
        .apb_write_data(apb_write_data),
        .pready(pready),
        .pslaverr(pslaverr),
        .prdata(prdata)
        //.fwdata(fwdata)
    );

    always #5 pclk = ~pclk;

    initial begin
        pclk = 0;
        presetn = 0;
        read_write = 0;
        apb_write_paddr = 0;
        apb_read_paddr = 0;
        apb_write_data = 0;
        transfer = 0;

        #10;
        presetn = 1;

        // Write
        read_write = 1;
        apb_write_paddr = 8'h15;
        apb_write_data = 8'hA5;
        transfer = 1;

        #25;
       // transfer = 0;
        // Read
        read_write = 0;
        apb_read_paddr = 8'h15;
        transfer = 1;

        #20;
       // transfer = 0;
  
        read_write = 1;
        apb_write_paddr = 8'h20;
        apb_write_data = 8'hb5;
        transfer = 1;

        #20;
        //transfer = 0;
        // Read
        read_write = 0;
        apb_read_paddr = 8'h20;
        transfer = 1;

        #20;
        //transfer = 0;
        read_write = 1;
        apb_write_paddr = 8'h30;
        apb_write_data = 8'h65;
        transfer = 1;

        #20;
      //  transfer = 0;
        // Read
        read_write = 0;
        apb_read_paddr = 8'h30;
        transfer = 1;

        #20;
        transfer = 0;

        #40;
        $finish;
    end
endmodule
