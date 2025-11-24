////////////////////////////////////////////////\\
// FSM.sv : Control FSM for runDetect block      \\
// that detects a run of numbers of length        \\
// 4 or greater that are all greater than          \\
// a threshold.                                     \\
//                                                  //
// Student 1 Name: << Xuming Huang >>      //
// Student 2 Name: << Roman Kouskov >> //
///////////////////////////////////////////////////
module FSM(
  input clk, 			// system clock
  input rst_n,			// active low asynch reset
  input strtCapCmp,		// initiate capture and compare
  input gt,				// current sig > threshold
  input run3,			// currently 3 prev values of sig > threshold
  output logic cap,		// capture sig value as threshold and clear N_abv
  output logic inc,		// inc N_abv counter
  output logic rst_run	// reset the run counter
);

  ///////////////////////////////////////////////////////////////////////
  // NOTE: you may need to modify this for different number of states //
  // The IDLE state has been named for you.  Give your other states  //
  // meaningful names.                                              //
  ///////////////////////////////////////////////////////////////////
  typedef enum reg[3:0] {IDLE=4'b0001, CapVal=4'b0010, Acc=4'b0100, Wait=4'b1000} state_t;
  
  ///////////////////////////////////////
  // Declare nxt_state of our state_t //
  /////////////////////////////////////
  state_t nxt_state;
  
  //////////////////////////////////
  // Declare any internal signsl //
  ////////////////////////////////
  logic [3:0] state;		// might have to change width depending on # of states
  
  //////////////////////////////////////////////////////////
  // Instantiate state flops                             //
  // NOTE: perhaps you need a state4_reg or different?? //
  ///////////////////////////////////////////////////////
  state4_reg iST(.clk(clk), .rst_n(rst_n), .nxt_state(nxt_state), .state(state));
  
  //////////////////////////////////////////////
  // State transitions and outputs specified //
  // next as combinational logic with case  //
  ///////////////////////////////////////////		
  always_comb begin
	/////////////////////////////////////////////////////////////
	// Default all SM outputs & nxt_state                     //
	// OK nxt_state is done for you.  You default SM outputs //
	//////////////////////////////////////////////////////////
	nxt_state = state_t'(state);

  cap = 1'b0;
  rst_run = 1'b0;
  inc = 1'b0;
	
	case (state)
	  IDLE: begin
      nxt_state = strtCapCmp ? CapVal : IDLE;
      cap = strtCapCmp;
      rst_run = strtCapCmp;
	  end
      
    CapVal: begin
      nxt_state = gt ? Acc : CapVal;
      rst_run = ~gt;
    end

    Acc: begin
      nxt_state = gt ? (run3 ? Wait : Acc) : CapVal;
      rst_run = gt ? (run3 ? 1'b1 : 1'b0) : 1'b1;
      inc = gt & run3; 
    end

    Wait: begin
      nxt_state = gt ? Wait : CapVal;
      rst_run = ~gt; 
    end

  default: begin
      nxt_state = IDLE;
    end
	endcase
  end
		
endmodule