public class ConnectionBox extends Module implements Interconnect{
    InterconnectPoint drives;
    InterconnectPoint drivenBy;

    int inputs;
    int outputs;
    public ConnectionBox(String name, int inputs, int outputs, InterconnectPoint drives, InterconnectPoint drivenBy) {
        super("ConnectionBox", name);
        this.subModules = new Module[outputs];
        this.drives = drives;
        this.drivenBy = drivenBy;
        for (Integer i = 0; i < outputs; i++)
            this.subModules[i] = new ProgMux(name+".out"+ i.toString(), (int)Math.ceil(Math.pow(inputs, .5)));
    }

    @Override
    public boolean createConnection(InterconnectPoint from, InterconnectPoint to) {

        if (drives.equals(to) && drivenBy.equals(from)) {
            boolean res = SetValue(this.name + ".out" + to.track.toString() + ".sel", ((ProgMux)this.subModules[0]).getBits(from.track));
            if (!res) {
                res = SetValue(this.name + ".out" + to.track.toString(), ((ProgMux)this.subModules[0]).getBits(from.track));
                return false;
            }
            return true;
        }
        return false;
    }
}