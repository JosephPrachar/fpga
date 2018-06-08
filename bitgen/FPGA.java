public class FPGA extends Module {
    public FPGA(String name) {
        super("FPGA", name);
        this.subModules = new Module[41];
        for (int i = 0; i < 20; i++)
            this.subModules[i] = new IOBlock(name+".ioblock"+
                    ((Integer)(i)).toString());
        this.subModules[20] = new ConnectionBox(name+".west_input_cb", 8, 10,
                new Channel(0, 1,true), new InterconnectPoint("iobank3"));
        this.subModules[21] = new Switch(name+".west_switch", 10,
                null,                              new Channel(0, 2, true),
                new Channel(1, 1, false), new Channel(0, 1, true));
        this.subModules[22] = new ConnectionBox(name+".west_output_cb", 16, 5,
                new InterconnectPoint("iobank3"), new Channel(0, 2, true));
        this.subModules[23] = new ConnectionBox(name+".sw_cb", 8, 10,
                new Channel(0, 1, true) ,new InterconnectPoint("sw_logic"));
        this.subModules[24] = new ConnectionBox(name+".nw_cb", 8, 10,
                new Channel(0, 2, true), new InterconnectPoint("nw_logic"));
        this.subModules[25] = new LogicCluster(name+".nw_logic");
        this.subModules[26] = new LogicCluster(name+".sw_logic");
        this.subModules[27] = new ConnectionBox(name+".south_output_cb", 16, 5,
                new InterconnectPoint("iobank2"), new Channel(1, 0, false));
        this.subModules[28] = new ConnectionBox(name+".south_input_cb", 8, 10,
                new Channel(1, 0, false), new InterconnectPoint("iobank2"));
        this.subModules[29] = new ConnectionBox(name+".east_input_cb", 8, 10,
                new Channel(2, 1, true), new InterconnectPoint("iobank1"));
        this.subModules[30] = new ConnectionBox(name+".se_cb", 8, 10,
                new Channel(2, 1, true), new InterconnectPoint("se_logic"));
        this.subModules[31] = new LogicCluster(name+".se_logic");
        this.subModules[32] = new Switch(name+".south_switch", 10,
                new InterconnectPoint("sw_logic"), new Channel(1, 1, true),
                new InterconnectPoint("se_logic"), new Channel(1, 0, false));
        this.subModules[33] = new Switch(name+".central_switch", 10,
                new Channel(1, 1, false), new Channel(1, 2, true),
                new Channel(2, 1, false), new Channel(1, 1, true));
        this.subModules[34] = new Switch(name+".north_switch", 10,
                new InterconnectPoint("nw_logic"), new Channel(1, 2, false),
                new InterconnectPoint("ne_logic"), new Channel(1, 2, true));
        this.subModules[35] = new ConnectionBox(name+".north_output_cb", 16, 5,
                new InterconnectPoint("iobank0"), new Channel(1, 2, false));
        this.subModules[36] = new ConnectionBox(name+".north_input_cb", 8, 10,
                new Channel(1, 2, false), new InterconnectPoint("iobank0"));
        this.subModules[37] = new LogicCluster(name+".ne_logic");
        this.subModules[38] = new ConnectionBox(name+".ne_cb", 8, 10,
                new Channel(2, 2, true),new InterconnectPoint("ne_logic"));
        this.subModules[39] = new ConnectionBox(name+".east_output_cb", 16, 5,
                new InterconnectPoint("iobank1"), new Channel(2, 2, true));
        this.subModules[40] = new Switch(name+".east_switch", 10,
                new Channel(2, 1, false), new Channel(2,2, true),
                null, new Channel(2, 1, true));
    }
}
