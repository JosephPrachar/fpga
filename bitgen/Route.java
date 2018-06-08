import java.util.List;

public class Route {
    public List<InterconnectPoint> path;
    public InterconnectPoint source;
    public InterconnectPoint sink;

    public Route(List<InterconnectPoint> path) {
        this.path = path;
    }

    public void routeComplete() {
        this.source = path.get(0);
        this.sink = path.get(path.size() - 1);
    }
}
