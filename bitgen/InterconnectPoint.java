public class InterconnectPoint {
    public String name;
    public Integer track;

    public InterconnectPoint(String name, Integer track) {
        this.name = name;
        this.track = track;
    }
    public InterconnectPoint(String name) {
        this.name = name;
        this.track = -1;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) return true;

        if (o instanceof String) {
            return this.name.equals((String) o);
        } else if (o instanceof InterconnectPoint) {

            return this.name.equals(((InterconnectPoint)o).name);
        }
        return false;
    }
}
