import java.util.List;

public class Route {
    public int track;
    public int pin;
    public String source;
    public String sink;
    public List<Channel> path;

    public Route(int track, int pin, String source, String sink, List<Channel> path) {
        this.track = track;
        this.pin = pin;
        this.source = source;
        this.sink = sink;
        this.path = path;
    }
}

