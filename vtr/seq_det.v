// The sequence being detected is "1011"001010 or One Zero One One 
module Sequence_Detector_MOORE_Verilog(
input clock,
input reset, // reset input
input sequence_in, // binary input
    output reg [6:0] LED_out

    );
parameter
  _0              = 4'b0000,
  _1              = 4'b0001,
  _10             = 4'b0010,
  _101            = 4'b0011,
  _1011           = 4'b0100,
  _10110          = 4'b0101,
  _101100         = 4'b0110,
  _1011001        = 4'b0111,
  _10110010       = 4'b1000,
  _101100101      = 4'b1001;
reg [3:0] current_state, next_state; // current state and next state
// sequential memory of the Moore FSM
always @(posedge clock, posedge reset)
begin
 if(reset==1) 
 current_state <= _0;// when reset=1, reset the state of the FSM to "Zero" State
 else
 current_state <= next_state; // otherwise, next state
end 
// combinational logic of the Moore FSM
// to determine next state 
always @(current_state,sequence_in)
begin
 case(current_state) 
 _0:begin
  if(sequence_in==1)
   next_state <= _1;
  else
   next_state <= _0;
 end
 _1:begin
  if(sequence_in==0)
   next_state <= _10;
  else
   next_state <= _1;
 end
 _10:begin
  if(sequence_in==0)
   next_state <= _0;
  else
   next_state <= _101;
 end 
 _101:begin
  if(sequence_in==0)
   next_state <= _10;
  else
   next_state <= _1011;
 end
 _1011:begin
  if(sequence_in==0)
   next_state <= _10110;
  else
   next_state <= _1;
 end
 _10110:begin
  if(sequence_in==0)
   next_state <= _101100;
  else
   next_state <= _101;
 end
 _101100:begin
  if(sequence_in==0)
   next_state <= _0;
  else
   next_state <= _1011001;
 end
 _1011001:begin
  if(sequence_in==0)
   next_state <= _10110010;
  else
   next_state <= _1;
 end
 _10110010:begin
  if(sequence_in==0)
   next_state <= _101100101;
  else
   next_state <= _1;
 end
 _101100101:begin
  if(sequence_in==0)
   next_state <= _10;
  else
   next_state <= _1011;
 end
 default:next_state <= _0;
 endcase
end
// combinational logic to determine the output
// of the Moore FSM, output only depends on current state
always @(current_state)
begin 
        case(current_state)
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9" 
        default: LED_out = 0;
        endcase
end 
endmodule
