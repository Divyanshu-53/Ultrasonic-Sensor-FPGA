module trial (
    input clk,              // 50MHz main clock
    input reset,            
    input echo,             // Echo pulse from sensor
    output reg trigger,        // Trigger pulse to sensor
    output [6:0] HEX0,      
    output [6:0] HEX1,      
    output [6:0] HEX2,      
    output [6:0] HEX3,      
    output reg [15:0] distance  // Calculated distance in cm
);

    // Parameters
    parameter CLK_FREQ = 50000000;  
    parameter TRIG_PULSE_CYCLES = 500;  
    parameter MEAS_INTERVAL = 50000000;  
    
    //  registers
    reg [31:0] meas_timer;
    reg [31:0] echo_cnt;
    reg echo_prev;
    reg [1:0] ps;
    
    // states
    localparam S_IDLE       = 2'b00,
               S_TRIGGER    = 2'b01,
               S_WAIT_ECHO  = 2'b10,
               S_MEASURE    = 2'b11;

    // FSM 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            trigger <= 0;
            echo_cnt <= 0;
            meas_timer <= 0;
            ps <= S_IDLE;
            echo_prev <= 0;
        end else begin
            echo_prev <= echo;
            
            case (ps)
                S_IDLE: begin
                    trigger <= 0;
                    if (meas_timer >= MEAS_INTERVAL - 1) begin
                        meas_timer <= 0;
                        ps <= S_TRIGGER;
                    end else begin
                        meas_timer <= meas_timer + 1;
                    end
                end
                
                S_TRIGGER: begin
                    trigger <= 1;
                    if (meas_timer < TRIG_PULSE_CYCLES - 1) begin
                        meas_timer <= meas_timer + 1;
                    end else begin
                        trigger <= 0;
                        meas_timer <= 0;
                        ps <= S_WAIT_ECHO;
                    end
                end
                
                S_WAIT_ECHO: begin
                    if (!echo_prev && echo) begin  //rising edge 
                        echo_cnt <= 0;
                        ps <= S_MEASURE;
                    end
                    else if (meas_timer > 5_000_000) begin
                        distance <= 16'hFFFF; 
                        ps <= S_IDLE;
                    end else begin
                        meas_timer <= meas_timer + 1;
                    end
                end
                
                S_MEASURE: begin
                    if (echo == 1'b1) begin
                        echo_cnt <= echo_cnt + 1;
                    end else begin
                        distance <= (echo_cnt * 343) / 1_000_000;
                        ps <= S_IDLE;
                    end
                end
            endcase
        end
    end
	 
	 reg [3:0] units, tens, hundreds, thousands;
    reg [6:0] seg0, seg1, seg2, seg3;

    always @(posedge clk) begin
        // Extract digits from distance value
        units <= distance % 10;
        tens <= (distance / 10) % 10;
        hundreds <= (distance / 100) % 10;
        thousands <= (distance / 1000) % 10;
    end


//
    always @(*) begin
        case (units)
            4'd0: seg0 = 7'b1000000;
            4'd1: seg0 = 7'b1111001;
            4'd2: seg0 = 7'b0100100;
            4'd3: seg0 = 7'b0110000;
            4'd4: seg0 = 7'b0011001;
            4'd5: seg0 = 7'b0010010;
            4'd6: seg0 = 7'b0000010;
            4'd7: seg0 = 7'b1111000;
            4'd8: seg0 = 7'b0000000;
            4'd9: seg0 = 7'b0010000;
            default: seg0 = 7'b1111111;
        endcase
    end

    always @(*) begin
        case (tens)
            4'd0: seg1 = 7'b1000000;
            4'd1: seg1 = 7'b1111001;
            4'd2: seg1 = 7'b0100100;
            4'd3: seg1 = 7'b0110000;
            4'd4: seg1 = 7'b0011001;
            4'd5: seg1 = 7'b0010010;
            4'd6: seg1 = 7'b0000010;
            4'd7: seg1 = 7'b1111000;
            4'd8: seg1 = 7'b0000000;
            4'd9: seg1 = 7'b0010000;
            default: seg1 = 7'b1111111;
        endcase
    end

    always @(*) begin
        case (hundreds)
            4'd0: seg2 = 7'b1000000;
            4'd1: seg2 = 7'b1111001;
            4'd2: seg2 = 7'b0100100;
            4'd3: seg2 = 7'b0110000;
            4'd4: seg2 = 7'b0011001;
            4'd5: seg2 = 7'b0010010;
            4'd6: seg2 = 7'b0000010;
            4'd7: seg2 = 7'b1111000;
            4'd8: seg2 = 7'b0000000;
            4'd9: seg2 = 7'b0010000;
            default: seg2 = 7'b1111111;
        endcase
    end

    always @(*) begin
        case (thousands)
            4'd0: seg3 = 7'b1000000;
            4'd1: seg3 = 7'b1111001;
            4'd2: seg3 = 7'b0100100;
            4'd3: seg3 = 7'b0110000;
            4'd4: seg3 = 7'b0011001;
            4'd5: seg3 = 7'b0010010;
            4'd6: seg3 = 7'b0000010;
            4'd7: seg3 = 7'b1111000;
            4'd8: seg3 = 7'b0000000;
            4'd9: seg3 = 7'b0010000;
            default: seg3 = 7'b1111111;
        endcase
    end

    assign HEX0 = seg0;
    assign HEX1 = seg1;
    assign HEX2 = seg2;
    assign HEX3 = seg3;

endmodule


// With reset

//module trial (
//    input clk,
//    input reset,
//    input echo,
//    output reg trigger,
//    output [6:0] HEX0,
//    output [6:0] HEX1,
//    output [6:0] HEX2,
//    output [6:0] HEX3,
//    output reg [15:0] distance,
//	 output reg [31:0] echo_counter
//);
//
//    parameter CLK_FREQ = 50000000;
//    parameter TRIGGER_TIME = 1000;
//
//    reg [15:0] trigger_counter;
//    //reg [31:0] echo_counter;
//    reg [1:0] state;
//    reg [3:0] units, tens, hundreds, thousands;
//    reg [6:0] seg0, seg1, seg2, seg3;
//    reg [31:0] echo_time;  // Store echo duration for distance calculation
//
//    localparam IDLE = 2'b00,
//               TRIGGER = 2'b01,
//               WAIT_ECHO = 2'b10,
//               MEASURE = 2'b11;
//
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            trigger <= 0;
//            trigger_counter <= 0;
//            echo_counter <= 0;
//            state <= IDLE;
//            echo_time <= 0;
//        end else begin
//            case (state)
//                IDLE: begin
//                    trigger <= 0;
//                    state <= TRIGGER; 
//                end
//                TRIGGER: begin
//                    trigger <= 1;
//                    if (trigger_counter < TRIGGER_TIME - 1) 
//                        trigger_counter <= trigger_counter + 1;
//                    else begin
//                        trigger <= 0;
//                        trigger_counter <= 0;
//                        state <= WAIT_ECHO;
//                    end
//                end
//                WAIT_ECHO: begin
//                    if (echo == 1) begin
//                        echo_counter <= 0;
//                        state <= MEASURE;
//                    end
//                end
//                MEASURE: begin
//                    if (echo == 1) 
//                        echo_counter <= echo_counter + 1;
//                    else begin
//                        echo_time <= echo_counter;  // Store final echo duration
//                        state <= IDLE;
//                    end
//                end
//            endcase
//        end
//    end
//
//    // ✅ **Fix 1: Move distance calculation outside FSM**
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            distance <= 0;
//        end else begin
//            distance <= ((echo_time * 100 * 343) / (2 * CLK_FREQ)); // ✅ Always updating
//        end
//    end
//
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            units <= 0;
//            tens <= 0;
//            hundreds <= 0;
//            thousands <= 0;
//        end else begin
//            units <= distance % 10;
//            tens <= (distance / 10) % 10;
//            hundreds <= (distance / 100) % 10;
//            thousands <= (distance / 1000) % 10;
//        end
//    end
//
//    always @(*) begin
//        case (units)
//            4'd0: seg0 = 7'b1000000;
//            4'd1: seg0 = 7'b1111001;
//            4'd2: seg0 = 7'b0100100;
//            4'd3: seg0 = 7'b0110000;
//            4'd4: seg0 = 7'b0011001;
//            4'd5: seg0 = 7'b0010010;
//            4'd6: seg0 = 7'b0000010;
//            4'd7: seg0 = 7'b1111000;
//            4'd8: seg0 = 7'b0000000;
//            4'd9: seg0 = 7'b0010000;
//            default: seg0 = 7'b1111111;
//        endcase
//    end
//
//    always @(*) begin
//        case (tens)
//            4'd0: seg1 = 7'b1000000;
//            4'd1: seg1 = 7'b1111001;
//            4'd2: seg1 = 7'b0100100;
//            4'd3: seg1 = 7'b0110000;
//            4'd4: seg1 = 7'b0011001;
//            4'd5: seg1 = 7'b0010010;
//            4'd6: seg1 = 7'b0000010;
//            4'd7: seg1 = 7'b1111000;
//            4'd8: seg1 = 7'b0000000;
//            4'd9: seg1 = 7'b0010000;
//            default: seg1 = 7'b1111111;
//        endcase
//    end
//
//    always @(*) begin
//        case (hundreds)
//            4'd0: seg2 = 7'b1000000;
//            4'd1: seg2 = 7'b1111001;
//            4'd2: seg2 = 7'b0100100;
//            4'd3: seg2 = 7'b0110000;
//            4'd4: seg2 = 7'b0011001;
//            4'd5: seg2 = 7'b0010010;
//            4'd6: seg2 = 7'b0000010;
//            4'd7: seg2 = 7'b1111000;
//            4'd8: seg2 = 7'b0000000;
//            4'd9: seg2 = 7'b0010000;
//            default: seg2 = 7'b1111111;
//        endcase
//    end
//
//    always @(*) begin
//        case (thousands)
//            4'd0: seg3 = 7'b1000000;
//            4'd1: seg3 = 7'b1111001;
//            4'd2: seg3 = 7'b0100100;
//            4'd3: seg3 = 7'b0110000;
//            4'd4: seg3 = 7'b0011001;
//            4'd5: seg3 = 7'b0010010;
//            4'd6: seg3 = 7'b0000010;
//            4'd7: seg3 = 7'b1111000;
//            4'd8: seg3 = 7'b0000000;
//            4'd9: seg3 = 7'b0010000;
//            default: seg3 = 7'b1111111;
//        endcase
//    end
//
//    assign HEX0 = seg0;
//    assign HEX1 = seg1;
//    assign HEX2 = seg2;
//    assign HEX3 = seg3;
//
//endmodule
