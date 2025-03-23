module Uart8 #(
    parameter CLOCK_RATE = 100000000,
    parameter BAUD_RATE = 9600,
    parameter TURBO_FRAMES = 0
)(
    input wire clk,

    input wire rxEn,
    input wire rx,
    output wire rxBusy,
    output wire rxDone,
    output wire rxErr,
    output wire [7:0] out,

    input wire txEn,
    input wire txStart,
    input wire [7:0] in,
    output wire txBusy,
    output wire txDone,
    output wire tx
);

// UART Receiver Module
reg [7:0] rxReg;
reg [3:0] rxCnt;
reg [3:0] rxSampleCnt;
reg rxFrameErr;
reg rxOverRun;
reg rxEmpty;
reg rxD1;
reg rxD2;
reg _rxBusy; // Internal reg for rxBusy
reg _rxDone; // Internal reg for rxDone
reg _rxErr; // Internal reg for rxErr

assign rxBusy = _rxBusy; // Assign internal reg to output wire
assign rxDone = _rxDone;
assign rxErr = _rxErr;

always @(posedge clk or negedge rxEn) begin
    if (!rxEn) begin
        rxReg <= 0;
        rxCnt <= 0;
        rxSampleCnt <= 0;
        rxFrameErr <= 0;
        rxOverRun <= 0;
        rxEmpty <= 1;
        rxD1 <= 1;
        rxD2 <= 1;
        _rxBusy <= 0;
        _rxDone <= 0;
        _rxErr <= 0;
    end else if (rxEn) begin
        // Synchronize the asynchronous signal
        rxD1 <= rx;
        rxD2 <= rxD1;

        // Receive data only when rx is enabled
        if (!_rxBusy && !rxD2) begin
            _rxBusy <= 1;
            rxCnt <= 0;
        end else if (_rxBusy && (rxCnt == 8)) begin
            // Check for stop bit
            if (rxD2) begin
                rxReg <= rxReg;
                rxFrameErr <= 0;
            end else begin
                rxFrameErr <= 1;
            end
            _rxBusy <= 0;
            _rxDone <= 1;
            out <= rxReg;
            rxEmpty <= 0;
        end else if (_rxBusy) begin
            // Shift in data bits
            rxReg <= {rxD2, rxReg[7:1]};
            rxCnt <= rxCnt + 1;
        end
    end
end

// UART Transmitter Module
reg [7:0] txReg;
reg [3:0] txCnt;
reg txEmpty;
reg txOverRun;
reg _txBusy; // Internal reg for txBusy
reg _txDone; // Internal reg for txDone

assign txBusy = _txBusy; // Assign internal reg to output wire
assign txDone = _txDone;

always @(posedge clk) begin
    if (txStart) begin
        txReg <= in;
        txCnt <= 0;
        _txBusy <= 1;
    end else if (_txBusy) begin
        if (txCnt == 9) begin
            _txBusy <= 0;
            _txDone <= 1;
        end else if (txCnt == 8) begin
            // Send stop bit
            tx <= 1;
            txCnt <= txCnt + 1;
        end else if (txCnt > 0) begin
            // Send data bits
            tx <= txReg[0];
            txReg <= {1'b0, txReg[7:1]};
            txCnt <= txCnt + 1;
        end else if (txCnt == 0) begin
            // Send start bit
            tx <= 0;
            txCnt <= txCnt + 1;
        end
    end else begin
        tx <= 1; // Idle state
    end
end

// Baud Rate Generator
reg [23:0] baudCnt;
always @(posedge clk) begin
    if (baudCnt == (CLOCK_RATE / BAUD_RATE - 1)) begin
        baudCnt <= 0;
    end else begin
        baudCnt <= baudCnt + 1;
    end
end

endmodule