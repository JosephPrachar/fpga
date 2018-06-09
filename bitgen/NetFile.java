import com.sun.org.apache.xerces.internal.dom.ElementDefinitionImpl;
import com.sun.xml.internal.ws.policy.privateutil.PolicyUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Dictionary;
import java.util.List;

public class NetFile {

    public static FPGA parseNetFile(String filename, BlifFile blif, PlaceFile place, RouteFile route) {
        File file = new File(filename);
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        DocumentBuilder db = null;
        try {
            db = dbf.newDocumentBuilder();
        } catch (ParserConfigurationException e) {
            e.printStackTrace();
        }
        Document doc = null;
        try {
            doc = db.parse(file);
        } catch (SAXException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        String[] inputs = doc.getElementsByTagName("inputs").item(0).getTextContent().split(" ");
        String[] outputs = doc.getElementsByTagName("outputs").item(0).getTextContent().split(" ");
        FPGA fpga = new FPGA("fpga");

        NodeList blks = doc.getElementsByTagName("block");
        for (int i = 0; i < blks.getLength(); i++) {
            Element blk = (Element) blks.item(i);
            if (blk.getAttribute("instance").contains("clb") ||
                    blk.getAttribute("instance").contains("io")) {
                Block place_blk = place.blocks.get(place.blocks.indexOf(new Block(blk.getAttribute("name"))));
                if (place_blk.settings instanceof IOBlock) {
                    if (blk.getAttribute("mode").equals("outpad")) {
                        fpga.SetValue("fpga." + place_blk.getSettings().name + ".dir", new byte[] {0});
                    } else if (blk.getAttribute("mode").equals("inpad")) {
                        fpga.SetValue("fpga." + place_blk.getSettings().name + ".dir", new byte[] {1});
                    }
                } else if (place_blk.settings instanceof LogicCluster) {
                    List<String> clb_inputs = Arrays.asList(((Element) blk.getElementsByTagName("inputs").item(0)).getElementsByTagName("port").item(0).getTextContent().split(" "));
                    String[] clb_outputs = ((Element)blk.getElementsByTagName("outputs").item(0))
                            .getElementsByTagName("port").item(0).getTextContent().split(" ");
                    Integer[] clb_inputs_pins = new Integer[clb_inputs.size()];
                    Integer[] clb_outputs_pins = new Integer[clb_outputs.length];
                    for (int b = 0; b < clb_outputs.length; b++) {
                        if (clb_outputs[b].equals("open")) {
                            clb_outputs_pins[b] = -1;
                        } else {
                            clb_outputs_pins[b] = -1;
                            for (Route r : route.routes) {
                                if (r.name.equals(clb_outputs[b])) {
                                    clb_outputs_pins[b] = r.source.track;
                                }
                            }
                        }
                    }
                    for (int b = 0; b < clb_inputs.size(); b++) {
                        if (clb_inputs.get(b).equals("open")) {
                            clb_inputs_pins[b] = -1;
                        } else {
                            clb_inputs_pins[b] = -1;
                            for (Route r : route.routes) {
                                if (r.name.equals(clb_inputs.get(b))) {
                                    clb_inputs_pins[b] = r.path.get(1).track;
                                }
                            }
                        }
                    }


                    NodeList bles = blk.getElementsByTagName("block");
                    Integer ble_count = 0;
                    for (int ii = 0; ii < bles.getLength(); ii++) {
                        Element ble = (Element) bles.item(ii);
                        if (!ble.getAttribute("name").equals("open")) {
                            String[] ble_inputs = ((Element)ble.getElementsByTagName("inputs").item(0))
                                    .getElementsByTagName("port").item(0).getTextContent().split(" ");
                            String[] rot_map = ble.getElementsByTagName("port_rotation_map").item(0).getTextContent().split(" ");
                            Integer[] ble_in_settings = new Integer[4];
                            Integer[] rot_map_int_a = new Integer[4];
                            for (int a = 0; a < 4; a++) {
                                ble_in_settings[a] = ble_inputs[a].equals("open") ? -1 :
                                        Integer.parseInt(ble_inputs[a].substring(ble_inputs[a].indexOf("[") + 1,
                                                                                 ble_inputs[a].indexOf("]")));
                                ble_in_settings[a] = route.remapPins(place_blk.settings.name, ble_in_settings[a]);
                                // handle routeback paths mux setting
                                ble_in_settings[a] += ble_inputs[a].contains("ble") ? 10 : 0;
                                rot_map_int_a[a] = rot_map[a].equals("open") ? -1 : Integer.parseInt(rot_map[a]);
                            }
                            List<Integer> rot_map_int = Arrays.asList(rot_map_int_a);
                            String toBlif = ble.getAttribute("name");
                            BlifNode node = blif.getNodes().get(blif.getNodes().indexOf(new BlifNode(null, toBlif, false,null)));
                            for (Integer a = node.getInputNets().length - 1, b = 0; a >= 0; a--, b++) {
                                String netToConnect = node.getInputNets()[a];
                                int internal = clb_inputs.indexOf(netToConnect);
                                if (internal == -1) {
                                    // routeback
                                    int routeback_pin = ble_in_settings[rot_map_int.indexOf(a)];
                                    fpga.SetValue("fpga." + place_blk.getSettings().name + ".ic.ble" +
                                                    ble_count.toString() + "in" + b.toString() + ".sel",
                                            toByteArray(routeback_pin + 1, 4));
                                } else {
                                    int external_track = clb_inputs_pins[internal];
                                    fpga.SetValue("fpga." + place_blk.getSettings().name + ".ic.ble" +
                                                    ble_count.toString() + "in" + b.toString() + ".sel",
                                            toByteArray(external_track + 1, 4));
                                }

                            }

                            fpga.SetValue("fpga." + place_blk.getSettings().name + ".ble" +
                                    ble_count.toString() + ".4-lut", node.getLut4Settings());

                            fpga.SetValue("fpga." + place_blk.getSettings().name + ".ble" +
                                    ble_count.toString() + ".ff_out_to_out", node.getFlipFlopSetting());

                            String ff_output = ((Element)ble.getElementsByTagName("outputs").item(3))
                                    .getElementsByTagName("port").item(0).getTextContent();
                            for (Route r : route.routes) {
                                if (node.getFlipFlopSetting()[0] == 0) {
                                    if (r.name.equals(ble.getAttribute("name"))) {
                                        r.source.track = ble_count;
                                    }
                                } else {
                                    if (r.name.equals(ff_output)) {
                                        r.source.track = ble_count;
                                    }
                                }
                            }

                            ii += 3; // ignore sublocks
                        }
                        ble_count++;
                    }
                }
            }

        }

        for (int i = 0; i < route.routes.size(); i++) {
            Route r = route.routes.get(i);
            for (int a = 0; a < r.path.size() - 1; a++) {
                boolean routed = false;
                for (Module mod : fpga.subModules) {
                    if (mod instanceof Interconnect) {
                        Interconnect conn = (Interconnect) mod;
                        if (conn.createConnection(r.path.get(a), r.path.get(a+1))) {
                            conn.createConnection(r.path.get(a), r.path.get(a+1));
                            routed = true;
                            break;
                        }
                    }
                }
                if (!routed)
                    return null;
            }
        }


        return fpga;
    }

    public static byte[] toByteArray(int toConvert, int len) {
        byte[] toRet = new byte[len];
        int mask = 0x01;
        for (int i = 0; i < len; i++) {
            toRet[i] = (byte) ((toConvert & mask) == 0 ? 0 : 1);
            mask = mask << 1;
        }
        return toRet;
    }
}
