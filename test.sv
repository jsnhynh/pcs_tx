`ifndef TEST_SV
`define TEST_SV

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    virtual pcs_tx_mon_if vif;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);

        if (!uvm_config_db #(virtual pcs_tx_mon_if)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "virtual interface not set for test")
        end
    endfunction

    task apply_reset(input logic cfg);
        vif.rst      <= 1'b1;
        vif.config_i <= cfg;
        vif.scenario_id <= 0;
        repeat (3) @(posedge vif.clk);
        vif.rst <= 1'b0;
        @(negedge vif.clk);
    endtask

    task run_phase(uvm_phase phase);
        comprehensive_sequence seq;

        phase.raise_objection(this);

        // run 1: master
        apply_reset(1'b1);
        seq = comprehensive_sequence::type_id::create("seq");
        seq.start(e.agt.sqr);

        // run 2: master
        apply_reset(1'b1);
        seq = comprehensive_sequence::type_id::create("seq");
        seq.start(e.agt.sqr);

        // run 3: slave
        apply_reset(1'b0);
        seq = comprehensive_sequence::type_id::create("seq");
        seq.start(e.agt.sqr);

        // run 4: quick reset
        vif.scenario_id <= 0;
        vif.rst <= 1'b1;
        @(posedge vif.clk);
        vif.rst <= 1'b0;
        @(negedge vif.clk);

        seq = comprehensive_sequence::type_id::create("seq");
        seq.start(e.agt.sqr);

        #100ns;

        phase.drop_objection(this);
    endtask

endclass

`endif
