public class Channel extends InterconnectPoint {
    public int x, y;
    public boolean vertical;

    public Channel(int x, int y, boolean vertical) {
        super("Channel");
        this.x = x;
        this.y = y;
        this.vertical = vertical;
    }
    public Channel(int x, int y, boolean vertical, Integer track) {
        super("Channel", track);
        this.x = x;
        this.y = y;
        this.vertical = vertical;
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) return true;

        if (o instanceof Channel) {
            Channel other = (Channel) o;
            return other.x == this.x &&
                    other.y == this.y &&
                    other.vertical == this.vertical;
        }
        return false;
    }
}
