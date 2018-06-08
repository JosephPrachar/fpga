import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class Switch extends Module implements Interconnect {
    List<InterconnectPoint> connections;
    @Override
    public boolean createConnection(InterconnectPoint from, InterconnectPoint to) {
        int i_from, i_to;
        if ((i_from = connections.indexOf(from)) != -1 &&
                (i_to = connections.indexOf(to)) != -1) {
            boolean res = this.SetValue(this.name + "." + Side.toString(i_to) + from.track.toString() + ".sel",
                    MuxSetting(i_to, i_from));
            if (!res) {
                return false;
            }
            return true;
        }
        return false;
    }

    private static class Side {
        public static final int Left = 0;
        public static final int Top  = 1;
        public static final int Right = 2;
        public static final int Bottom = 3;
        public static final int HighZ = 4;
        public static String toString(int num) {
            if (num == Left)
                return "left";
            else if (num == Top)
                return "top";
            else if (num == Right)
                return "right";
            else if (num == Bottom)
                return "bottom";
            else return "";
        }
    }
    int width;
    public Switch(String name, int width, InterconnectPoint left, InterconnectPoint top,
                  InterconnectPoint right, InterconnectPoint bottom) {
        super("Switch", name);
        InterconnectPoint[] temp = new InterconnectPoint[4];
        temp[Side.Left] = left;
        temp[Side.Top] = top;
        temp[Side.Right] = right;
        temp[Side.Bottom] = bottom;
        this.connections = Arrays.asList(temp);
        this.width = width;
        this.subModules = new Module[4 * width];
        for (int i = 0; i < width; i++) {
            this.subModules[i            ] = new ProgMux(name + ".left" + i, 2); // out = 0; in = 1
            this.subModules[i + width    ] = new ProgMux(name + ".top" + i, 2);
            this.subModules[i + width * 2] = new ProgMux(name + ".right" + i, 2);
            this.subModules[i + width * 3] = new ProgMux(name + ".bottom" + i, 2);
        }
    }

    private byte[] MuxSetting(int muxSide, int desiredConn) {
        if (desiredConn == Side.HighZ) {
            // Each prog mux is connected to high z for the 2'b11 setting
            return new byte[]{0, 0};
        }
        int diff = desiredConn - muxSide;
        if (diff == 0) {
            return null;
        }
        return new byte[] {(byte)(diff & 1),(byte)((diff & 2) >> 1)};
    }
    private int MuxSetting(int muxSide, ControlBits setting) {
        if (setting.values.length != 2) {
            return -1;
        } else if (setting.values[0] == 0 && setting.values[1] == 0) {
            return Side.HighZ;
        }
        int diff = setting.values[0] + 2 * setting.values[1];

        return diff + muxSide;
    }
    private boolean IsSwitchMuxValid(int muxSide, ControlBits setting) {
        if (setting.values.length != 2) {
            return false;
        }
        // Ensure only values 1 and 0 are in controlBits
        if ((setting.values[0] != 1 && setting.values[0] != 0) ||
            (setting.values[1] != 1 && setting.values[1] != 0)) {
            return false;
        }

        int curSetting = MuxSetting(muxSide, setting);
        return MuxSetting(muxSide, curSetting) != null;
    }

    public boolean IsValid() {
        for (int i = 0; i < this.subModules.length; i++) {
            int cur = i / 4;

            if (!IsSwitchMuxValid(cur, this.subModules[i].fields[0])) {
                return false;
            }
            int setting = MuxSetting(cur, this.subModules[i].fields[0]);
            if (setting != Side.HighZ) {
                // This mux is being used as an output; check to ensure that
                // it is not also being used as an input
                for (int j = 1; j < 4; j++) {
                    int set = MuxSetting((cur + j) % 4,
            this.subModules[(i + width * j) % this.subModules.length].fields[0]);
                    if (set == cur) {
                        // another io is trying to use this pin as its input
                        return false;
                    }
                }
            }
        }
        return true;
    }
}
