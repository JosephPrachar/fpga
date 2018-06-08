public class ProgMux extends Module {
    public ProgMux(String name, int selBits) {
        super("ProgMux", name);
        this.fields = new ControlBits[1];
        this.fields[0] = new ControlBits(name+".sel", selBits); // out = 0; in = 1
    }

    public byte[] getBits(int setting) {
        byte[] toRet = new byte[this.fields[0].values.length];
        int mask = 1;
        for (int i = 0; i < toRet.length; i++) {
            toRet[i] = (byte)((mask & setting) == 0 ? 0 : 1);
            mask <<= 1;
        }
        return toRet;
    }
    public boolean IsValid() {
        return true;
    }
}
