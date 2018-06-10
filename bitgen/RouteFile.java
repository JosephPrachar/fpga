import javax.swing.*;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class RouteFile {
    List<Route> routes;

    public RouteFile(List<Route> routes) {
        this.routes = routes;
    }

    public int remapPins(String lc, int pin) {
        for (int i = 0; i < routes.size(); i++) {
            Route cur = routes.get(i);
            if (cur.sink.equals(lc) && cur.sink.track == pin) {
                return cur.path.get(1).track;
            }
        }
        return pin;
    }

    public static RouteFile parseRouteFile(String filename) {
        try {
            FileReader fileReader = new FileReader(filename);
            BufferedReader br = new BufferedReader(fileReader);

            RouteFile rf = new RouteFile(new ArrayList<>());
            Route toAdd = null;
            String curNet = null;
            String curLine;

            while ((curLine = br.readLine()) != null) {

                if (curLine.contains("Net")) {
                    curNet = curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(")"));
                } else if (curLine.contains("OPIN")) {
                    int x = Integer.parseInt(curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(",")));
                    int y = Integer.parseInt(curLine.substring(curLine.indexOf(",") + 1, curLine.indexOf(")")));
                    int subblk = -1;
                    toAdd = new Route(new ArrayList<>());
                    toAdd.name = curNet;
                    if (x == 0 || x == 3 || y == 0 || y == 3) {
                        subblk = Integer.parseInt(""+curLine.charAt(curLine.indexOf("Pad") + 5)) / 2;
                        toAdd.path.add(new InterconnectPoint(Block.IOBlockToBank(Block.posToName(x, y, subblk)), subblk));
                    } else {
                        subblk = Integer.parseInt(curLine.substring(curLine.indexOf("Pin") + 5, curLine.indexOf("Pin") + 7).replace(" ", ""));
                        if (subblk >= 10) subblk -= 10;
                        toAdd.path.add(new InterconnectPoint(Block.posToName(x, y, subblk), subblk));
                    }
                } else if (curLine.contains("CHANX") || curLine.contains("CHANY")) {
                    boolean vertical = curLine.contains("CHANY");
                    int x = Integer.parseInt(curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(",")));
                    int y = Integer.parseInt(curLine.substring(curLine.indexOf(",") + 1, curLine.indexOf(")")));
                    if (toAdd == null) {
                        toAdd = new Route(new ArrayList<>());
                        toAdd.name = curNet;
                        //toAdd.path.add(rf.routes.get(rf.routes.size() - 1).source);
                    }
                    toAdd.path.add(new Channel(x, y,vertical, Integer.parseInt(""+curLine.charAt(curLine.indexOf("Track") + 7))));
                } else if (curLine.contains("IPIN")) {
                    int x = Integer.parseInt(curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(",")));
                    int y = Integer.parseInt(curLine.substring(curLine.indexOf(",") + 1, curLine.indexOf(")")));
                    int subblk = -1;
                    int pin = -1;
                    if (x == 0 || x == 3 || y == 0 || y == 3) {
                        subblk = Integer.parseInt(""+curLine.charAt(curLine.indexOf("Pad") + 5)) / 2;
                        toAdd.path.add(new InterconnectPoint(Block.IOBlockToBank(Block.posToName(x, y, subblk)), subblk));
                    } else {
                        //pin = Integer.parseInt(curLine.substring(curLine.indexOf("Pin") + 5, curLine.indexOf("Pin") + 7).replace(" ", ""));
                        pin = toAdd.path.get(toAdd.path.size() - 1).track;
                        toAdd.path.add(new InterconnectPoint(Block.posToName(x, y, 0), pin));
                    }
                    toAdd.routeComplete();
                    rf.routes.add(toAdd);
                    toAdd = null;
                }
            }

            return rf;
        } catch (FileNotFoundException ex) {


        } catch (IOException ex) {

        }
        return null;
    }
}
