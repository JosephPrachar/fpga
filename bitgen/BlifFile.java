import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class BlifFile {
    private String model;
    private String[] inputs;
    private String[] outputs;
    List<String> latch_net;
    List<String> latch_name;
    private List<BlifNode> nodes;

    public BlifFile(String model, String[] inputs, String[] outputs, List<BlifNode> nodes,
                    List<String> latch_net, List<String> latch_name) {
        this.model = model;
        this.inputs = inputs;
        this.outputs = outputs;
        this.nodes = nodes;
        this.latch_net = latch_net;
        this.latch_name = latch_name;
    }
    private enum ParseState {
        NONE, MODEL, INPUTS, OUTPUTS, LATCH, NAMES, DONE
    }

    public String flipFlopToNet(String ff) {
        for (int i = 0; i < latch_name.size(); i++) {
            if (ff.equals(latch_name.get(i))) {
                return latch_net.get(i);
            }
        }
        return ff;
    }

    public static BlifFile parseBlifFile(String filename) {
        try {
            FileReader fileReader = new FileReader(filename);
            BufferedReader br = new BufferedReader(fileReader);

            String model = null;
            List<String> inputs = new ArrayList<>();
            List<String> outputs = new ArrayList<>();
            List<BlifNode> nodes = new ArrayList<>();
            List<String> latch_net = new ArrayList<>();
            List<String> latch_name = new ArrayList<>();
            String curLine, nextLine = br.readLine();
            ParseState curState = ParseState.NONE;
            List<String> linesToParse = new ArrayList<>();
            boolean doParse = false;

            while (curState != ParseState.DONE) {
                curLine = nextLine;
                if (curLine == null)
                    break;
                nextLine = br.readLine();


                // Ignore comments
                if (curLine.startsWith("#"))
                    continue;

                if (curState == ParseState.NONE) {
                    if (curLine.startsWith(".model"))
                        curState = ParseState.MODEL;
                    else if (curLine.startsWith(".inputs")) {
                        curState = ParseState.INPUTS;
                    } else if (curLine.startsWith(".outputs")) {
                        curState = ParseState.OUTPUTS;
                    } else if (curLine.startsWith(".names")) {
                        curState = ParseState.NAMES;
                    } else if (curLine.startsWith(".latch")) {
                        curState = ParseState.LATCH;
                    } else if (curLine.startsWith(".end")) {
                        curState = ParseState.DONE;
                    }
                }

                switch (curState) {
                case MODEL:
                    model = curLine.split(" ")[1];
                    curState = ParseState.NONE;
                    break;
                case INPUTS:
                    linesToParse.add(curLine);
                    if (!curLine.endsWith("\\")) {
                        // done with inputs section
                        for (String i : linesToParse)
                            for (String j : i.split(" "))
                                if (!j.equals(".inputs") && !j.equals("\\") && !j.isEmpty())
                                    inputs.add(j);
                        linesToParse.clear();
                        curState = ParseState.NONE;
                    }
                    break;
                case OUTPUTS:
                    linesToParse.add(curLine);
                    if (!curLine.endsWith("\\")) {
                        // done with outputs section
                        for (String i : linesToParse)
                            for (String j : i.split(" "))
                                if (!j.equals(".outputs") && !j.equals("\\") && !j.isEmpty())
                                    outputs.add(j);

                        linesToParse.clear();
                        curState = ParseState.NONE;
                    }
                    break;
                case LATCH:
                    latch_net.add(curLine.split(" ")[1]);
                    latch_name.add(curLine.split(" ")[2]);
                    curState = ParseState.NONE;
                    break;
                case NAMES:
                    linesToParse.add(curLine);
                    if (nextLine.startsWith(".")) {
                        nodes.add(BlifNode.parseBlifNode(linesToParse, latch_net, latch_name));
                        linesToParse.clear();
                        curState = ParseState.NONE;
                        break;
                    }
                    break;
                }
            }

            if (model == null || inputs.size() == 0 || outputs.size() == 0 || nodes.size() == 0) {
                return null;
            } else {
                return new BlifFile(model, inputs.toArray(new String[inputs.size()]),
                        outputs.toArray(new String[outputs.size()]), nodes, latch_net, latch_name);
            }

        } catch (FileNotFoundException ex) {


        } catch (IOException ex) {

        }
        return null;
    }

    public String getModel() {
        return model;
    }

    public String[] getInputs() {
        return inputs;
    }

    public String[] getOutputs() {
        return outputs;
    }

    public List<BlifNode> getNodes() {
        return nodes;
    }
}
