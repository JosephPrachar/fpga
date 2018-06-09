import java.util.*;

public class ControlBits {
    public String name;
    public byte[] values;

    public ControlBits(String name, int size) {
        this(name, new byte[size]);
    }
    public ControlBits(String name, byte[] values) {
        this.name = name;
        this.values = values;
    }

    @Override
    public String toString() {
        String toRet = "";
        for (int i = 0; i < values.length; i++) {
            toRet = ((Byte)values[i]).toString() + toRet;
        }
        return toRet;
    }
}
