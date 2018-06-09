import com.sun.xml.internal.ws.util.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class BlifNode {
    private String[] inputNets;
    private String outputNet;
    private boolean flip_flop;
    private byte[] lut4Settings;

    BlifNode(String[] inputNets, String outputNet, boolean flip_flop, byte[] lut4Settings) {
        this.inputNets = inputNets;
        this.outputNet = outputNet;
        this.flip_flop = flip_flop;
        this.lut4Settings = lut4Settings;
    }

    /*
     * Takes the lines for a single .names blif section and parses it into a BlifNode obj
     */
    public static BlifNode parseBlifNode(List<String> lines, List<String> latch_nets, List<String> latch_name) {
        // Check that there is a first line and that the first line is the start of
        // a .names blif section
        if (lines.size() == 0 || lines.get(0).startsWith(".names") == false)
            return null;

        List<String> inputs = new ArrayList<>();
        int line = 0;
        do {
            for (String j : lines.get(line).split(" ")) {
                int index;
                if ((index = latch_name.indexOf(j)) != -1) {
                    inputs.add(latch_nets.get(index));
                } else if (!j.equals(".names")){
                    inputs.add(j);
                }
            }
            line++;
        } while (lines.get(line).charAt(0) == ' ');
        String[] nets = inputs.toArray(new String[inputs.size()]);
        // a valid .names line must have one input and one output net
        if (nets.length < 2)
            return null;

        String[] inputNets = Arrays.copyOfRange(nets, 0, nets.length - 1);
        String outputNet = nets[nets.length - 1];
        boolean ff = (latch_nets.indexOf(outputNet) != -1);

        byte[] lut4Settings = new byte[16];
        for (int i = 1; i < lines.size(); i++) {
            String indexStr = lines.get(i).split(" ")[0];
            indexStr = "----".substring(0, 4 - indexStr.length()) + indexStr;
            int iDontCare;

            // account for don't care bits
            if ((iDontCare = indexStr.indexOf("-")) == -1) {
                lut4Settings[Integer.parseInt(indexStr, 2)] = 1;
            } else {
                lines.add(indexStr.replaceFirst("-", "0"));
                lines.add(indexStr.replaceFirst("-", "1"));
            }
        }
        return new BlifNode(inputNets, outputNet, ff, lut4Settings);
    }

    @Override
    public boolean equals(Object o) {
        if (o == this)
            return true;
        else if (o instanceof BlifNode) {
            return this.outputNet.equals(((BlifNode)o).outputNet);
        }
        return false;
    }

    public String[] getInputNets() {
        return inputNets;
    }

    public String getOutputNet() {
        return outputNet;
    }

    public byte[] getLut4Settings() {
        return this.lut4Settings;
    }

    public byte[] getFlipFlopSetting() {
        byte[] toRet = new byte[1];
        toRet[0] = (byte) (this.flip_flop ? 1 : 0);
        return toRet;
    }
}
