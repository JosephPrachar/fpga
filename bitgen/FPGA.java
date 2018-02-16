public class FPGA extends Module {
    public FPGA(String name) {
        super("FPGA", name);
        this.subModules = new Module[41];
        for (int i = 0; i < 20; i++)
            this.subModules[i] = new IOBlock(name+".ioblock"+
                    ((Integer)(i)).toString());
        this.subModules[20] = new ConnectionBox(name+".west_input_cb", 8, 10);
        this.subModules[21] = new Switch(name+".west_switch", 10);
        this.subModules[22] = new ConnectionBox(name+".west_output_cb", 16, 5);
        this.subModules[23] = new ConnectionBox(name+".sw_cb", 8, 10);
        this.subModules[24] = new ConnectionBox(name+".nw_cb", 8, 10);
        this.subModules[25] = new LogicCluster(name+".nw_logic");
        this.subModules[26] = new LogicCluster(name+".sw_logic");
        this.subModules[27] = new ConnectionBox(name+".south_output_cb", 16, 5);
        this.subModules[28] = new ConnectionBox(name+".south_input_cb", 8, 10);
        this.subModules[29] = new ConnectionBox(name+".east_input_cb", 8, 10);
        this.subModules[30] = new ConnectionBox(name+".se_cb", 8, 10);
        this.subModules[31] = new LogicCluster(name+".se_logic");
        this.subModules[32] = new Switch(name+".south_switch", 10);
        this.subModules[33] = new Switch(name+".central_switch", 10);
        this.subModules[34] = new Switch(name+".north_switch", 10);
        this.subModules[35] = new ConnectionBox(name+".north_output_cb", 16, 5);
        this.subModules[36] = new ConnectionBox(name+".north_input_cb", 8, 10);
        this.subModules[37] = new LogicCluster(name+".ne_logic");
        this.subModules[38] = new ConnectionBox(name+".ne_cb", 8, 10);
        this.subModules[39] = new ConnectionBox(name+".east_output_cb", 16, 5);
        this.subModules[40] = new Switch(name+".east_switch", 10);
    }
}
