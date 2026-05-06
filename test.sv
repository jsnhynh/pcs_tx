`ifndef TEST_SV
`define TEST_SV

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    virtual encoder_if vif;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);

        if (!uvm_config_db #(virtual encoder_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for test")
        end
    endfunction

    task apply_reset();
        vif.rst_n <= 1'b0;
        vif.tx_in <= {1'b1, PCS_TX_CMD_IDLE};
        vif.scenario_id <= 0;
        repeat (3) @(posedge vif.clk);
        vif.rst_n <= 1'b1;
        @(negedge vif.clk);
    endtask

    // single directed pass, then multiple random-only passes for wider coverage
    task run_phase(uvm_phase phase);
        my_sequence seq;

        phase.raise_objection(this);

        apply_reset();
        seq = my_sequence::type_id::create("seq");
        seq.start(e.agt.sqr);

        #100ns;

        phase.drop_objection(this);
    endtask

endclass

`endif
