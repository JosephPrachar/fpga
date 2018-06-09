import com.sun.xml.internal.ws.util.StringUtils;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class BlifNode {
    private String[] inputNets;
    private String outputNet;
    private byte[] lut4Settings;

    BlifNode(String[] inputNets, String outputNet, byte[] lut4Settings) {
        this.inputNets = inputNets;
        this.outputNet = outputNet;
        this.lut4Settings = lut4Settings;
    }

    /*
     * Takes the lines for a single .names blif section and parses it into a BlifNode obj
     */
    public static BlifNode parseBlifNode(List<String> lines) {
        // Check that there is a first line and that the first line is the start of
        // a .names blif section
        if (lines.size() == 0 || lines.get(0).startsWith(".names") == false)
            return null;

        String[] nets = lines.get(0).split(" ");
        // a valid .names line must have one input and one output net
        if (nets.length < 3)
            return null;

        String[] inputNets = Arrays.copyOfRange(nets, 1, nets.length - 1);
        String outputNet = nets[nets.length - 1];

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
        return new BlifNode(inputNets, outputNet, lut4Settings);
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
}
