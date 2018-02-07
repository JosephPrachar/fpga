public class LogicElement extends Module {
    public LogicElement(String name) {
        super("LogicElement", name);
        this.fields = new ControlBits[4];
        this.fields[0] = new ControlBits(name+".4-lut", 16);
        this.fields[1] = new ControlBits(name+".d_to_ff_en", 1);
        this.fields[2] = new ControlBits(name+".ff_out_to_a", 1);
        this.fields[3] = new ControlBits(name+".ff_out_to_out", 1);
    }

    public boolean IsValid() {
        return true;
    }
}
