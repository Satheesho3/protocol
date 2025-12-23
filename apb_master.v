module apb_master(
    input  wire pclk,
    input  wire presetn,
    input  wire read_write,
    input  wire [7:0] apb_write_paddr,
    input  wire [7:0] apb_read_paddr,
    input  wire [7:0] apb_write_data,
    input  wire [7:0] prdata,
    input  wire pready,
    input  wire transfer,
    output reg [7:0] paddr,
    output reg [7:0] pwdata,
    output reg [7:0] apb_read_data_out,
    output reg pwrite,
    output reg penable,
    output reg pselx,
    output reg pslaverr
);

    parameter IDLE = 2'b00,
              SETUP = 2'b01,
              ACCESS = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge pclk or negedge presetn) begin
        if (!presetn)
            state <= IDLE;
        else
            state <= next_state;
    end

    always @(*) begin
        pselx   = 0;
        penable = 0;
        pwrite  = 0;
        paddr   = 8'd0;
        pwdata  = 8'd0;
        pslaverr= 0;
        next_state = state;

        case (state)
            IDLE: begin
                if (transfer)
                    next_state = SETUP;
            end

            SETUP: begin
                pselx   = 1;
                pwrite  = read_write;
                paddr   = (read_write) ? apb_write_paddr : apb_read_paddr;
                pwdata  = apb_write_data;
                next_state = ACCESS;
            end

            ACCESS: begin
                pselx   = 1;
                penable = 1;
                pwrite  = read_write;
                paddr   = (read_write) ? apb_write_paddr : apb_read_paddr;
                pwdata  = apb_write_data;

                if (pready) begin
                    if (!read_write)
                        apb_read_data_out = prdata;
                    next_state = (transfer) ? SETUP : IDLE;
                end else begin
                    next_state = ACCESS;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule
