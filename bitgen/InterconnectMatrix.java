public class InterconnectMatrix extends Module{
    int inputs;
    int outputs;
    public InterconnectMatrix(String name, int inputs, int outputs) {
        super("ConnectionBox", name);
        this.subModules = new Module[outputs];
        for (int i = 0; i < outputs; i++)
            this.subModules[i] = new ProgMux(name+".ble"+
                    ((Integer)(i/4)).toString() + "in" +
                    ((Integer)(i%4)).toString(), (int)Math.ceil(Math.pow(inputs, .5)));
    }
}
