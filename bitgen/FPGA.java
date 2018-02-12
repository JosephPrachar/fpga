public class FPGA extends Module {
    public FPGA(String name) {
        super("FPGA", name);
        this.subModules = new Module[17];
        for (int i = 0; i < 16; i++)
            this.subModules[i] = new IOBlock(name+".ioblock"+
                    ((Integer)(i)).toString());
        this.subModules[16] = new LogicCluster(name+".lc");
    }
}
