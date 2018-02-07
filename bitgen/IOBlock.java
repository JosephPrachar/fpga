import java.util.ArrayList;
import java.util.List;

public class IOBlock extends Module {
    public IOBlock(String name) {
        super("IOBlock", name);
        this.fields = new ControlBits[3];
        this.fields[0] = new ControlBits(name+".dir", 1); // out = 0; in = 1
        this.fields[1] = new ControlBits(name+".pull-down", 1);
        this.fields[2] = new ControlBits(name+".pull-up", 1);
    }

    public boolean IsValid() {
        if (GetBitFieldValue("Dir") == 1) {
            // FPGA is using this as an input
            if (GetBitFieldValue("Pull-up") == 1 &&
                    GetBitFieldValue("Pull-down") == 1 ) {
                // Dont allow both resistors to be active at same time
                return false;
            }
        } else {
            // FPGA is driving output
            if (GetBitFieldValue("Pull-up") == 1 ||
                    GetBitFieldValue("Pull-down") == 1) {
                // Dont allow pull resistors when driving output
                return false;
            }
        }
        return true;
    }
}
