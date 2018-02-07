public class ProgMux extends Module {
    /* TODO: Create multi size progmux */
    public ProgMux(String name, int selBits) {
        super("ProgMux", name);
        this.fields = new ControlBits[1];
        this.fields[0] = new ControlBits(name+".sel", selBits); // out = 0; in = 1
    }

    public boolean IsValid() {
        return true;
    }
}
