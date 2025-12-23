module apb_topmodule(
    input pclk,
    input presetn,
    input read_write,
    input transfer,
    input [7:0] apb_write_paddr,
    input [7:0] apb_read_paddr,
    input [7:0] apb_write_data,
    output wire pready,
    output wire pslaverr,
    output wire [7:0] prdata
    //output wire [7:0] fwdata
);

    wire [7:0] paddr_internal;
    wire [7:0] pwdata_internal;
    wire [7:0] apb_read_data_out;
    wire pwrite_internal;
    wire penable_internal;
    wire pselx_internal;

    apb_master master (
        .pclk(pclk),
        .presetn(presetn),
        .read_write(read_write),
        .apb_write_paddr(apb_write_paddr),
        .apb_read_paddr(apb_read_paddr),
        .apb_write_data(apb_write_data),
        .prdata(prdata),
        .pready(pready),
        .transfer(transfer),
        .paddr(paddr_internal),
        .pwdata(pwdata_internal),
        .apb_read_data_out(apb_read_data_out),
        .pwrite(pwrite_internal),
        .penable(penable_internal),
        .pselx(pselx_internal),
        .pslaverr(pslaverr)
    );

    apb_slave_1 slave (
        .pclk(pclk),
        .presetn(presetn),
        .pwrite(pwrite_internal),
        .pselx(pselx_internal),
        .penable(penable_internal),
        .paddr(paddr_internal),
        .pwdata(pwdata_internal),
        .prdata(prdata),
        .pready(pready)
    );

    //assign prdata = apb_read_data_out;

endmodule
