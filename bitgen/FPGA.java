public class FPGA extends Module {
    public FPGA(String name) {
        super("FPGA", name);
        this.subModules = new Module[21];
        this.subModules[0] = new LogicCluster(name+".lc");
        for (int i = 1; i < 21; i++)
            this.subModules[i] = new IOBlock(name+".ioblock"+
                    ((Integer)(i-1)).toString());
    }
}
