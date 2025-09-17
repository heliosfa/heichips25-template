module shader_two (
    input  logic        clk,
    input  logic        reset,

    input  logic [9:0]  video_x,
    input  logic [9:0]  video_y,

    input  logic        disp_active,
    input  logic        frame_end,
    input  logic        line_end,

    output logic [7:0]  r,
    output logic [7:0]  g,
    output logic [7:0]  b
);

    // 32-bit free-running frame counter
    int unsigned time_cnt;

    always_ff @(posedge clk) begin
        if (reset) begin
            time_cnt <= 0;
        end else if (frame_end) begin
            time_cnt <= time_cnt + 1;
        end
    end

    always_comb begin
        int unsigned tmp_x, h_x, h_y, q_x, q_y;
        int rv, gv, bv;
        int rv9, hv9, qv9;

        tmp_x = 0;
        h_x = 0;
        h_y = 0;
        q_x = 0;
        q_y = 0;
        rv = 0;
        gv = 0;
        bv = 0;
        rv9 = 0;
        hv9 = 0;
        qv9 = 0;

        // defaults (avoid latches)
        r = 8'd0;
        g = 8'd0;
        b = 8'd0;

        if (disp_active) begin
            // Extend inputs to 32 bits before mixing with int
            tmp_x = {22'b0, video_x} + time_cnt;

            h_x = tmp_x >> 1;
            h_y = {22'b0, video_y} >> 1;
            q_x = tmp_x >> 2;
            q_y = {22'b0, video_y} >> 2;

            rv9 = ((tmp_x ^ {22'b0, video_y}) % 9);
            hv9 = ((h_x   ^ h_y) % 9);
            qv9 = ((q_x   ^ q_y) % 9);

            rv = (rv9 & hv9 & qv9) << 5;

            gv = (({22'b0, video_y} + time_cnt) % 8);
            bv = gv;

            if ((rv > 40) && (rv < 70)) begin
                bv = time_cnt;
            end

            if (rv == 0) begin
                bv = 30;
            end

            // only use low 8 bits for outputs
            r = rv[7:0];
            g = gv[7:0];
            b = bv[7:0];
        end
    end

endmodule
