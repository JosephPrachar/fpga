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
            if (cur.sink.equals(lc) && cur.pin == pin) {
                return cur.track;
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
            String curLine;

            while ((curLine = br.readLine()) != null) {

                if (curLine.contains("OPIN")) {
                    int x = Integer.parseInt(curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(",")));
                    int y = Integer.parseInt(curLine.substring(curLine.indexOf(",") + 1, curLine.indexOf(")")));
                    int subblk = -1;
                    int pin = -1;
                    if (x == 0 || x == 3 || y == 0 || y == 3) {
                        subblk = Integer.parseInt(""+curLine.charAt(curLine.indexOf("Pad") + 5)) / 2;
                    }
                    toAdd = new Route(-1, -1, Block.posToName(x, y, subblk), null, new ArrayList<>());
                } else if (curLine.contains("CHANX")) {
                    int x = Integer.parseInt(curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(",")));
                    int y = Integer.parseInt(curLine.substring(curLine.indexOf(",") + 1, curLine.indexOf(")")));
                    toAdd.path.add(new Channel(x, y, false));
                    toAdd.track = Integer.parseInt(""+curLine.charAt(curLine.indexOf("Track") + 7));
                } else if (curLine.contains("CHANY")) {
                    int x = Integer.parseInt(curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(",")));
                    int y = Integer.parseInt(curLine.substring(curLine.indexOf(",") + 1, curLine.indexOf(")")));
                    toAdd.path.add(new Channel(x, y,true));
                    toAdd.track = Integer.parseInt(""+curLine.charAt(curLine.indexOf("Track") + 7));
                } else if (curLine.contains("IPIN")) {
                    int x = Integer.parseInt(curLine.substring(curLine.indexOf("(") + 1, curLine.indexOf(",")));
                    int y = Integer.parseInt(curLine.substring(curLine.indexOf(",") + 1, curLine.indexOf(")")));
                    int subblk = -1;
                    int pin = -1;
                    if (x == 0 || x == 3 || y == 0 || y == 3) {
                        subblk = Integer.parseInt(""+curLine.charAt(curLine.indexOf("Pad") + 5)) / 2;
                    } else {
                        pin = Integer.parseInt(""+curLine.charAt(curLine.indexOf("Pin") + 5));
                    }
                    toAdd.sink = Block.posToName(x, y, subblk);
                    toAdd.pin = pin;
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
