public class LogicCluster extends Module {
    public LogicCluster(String name) {
        super("LogicCluster", name);
        this.subModules = new Module[6];
        this.subModules[0] = new ConnectionBox(name+".ic", 16, 20);
        for (int i = 1; i < 6; i++)
            this.subModules[i] = new LogicElement(name+".ble"+
                                        ((Integer)i).toString());

    }
}
