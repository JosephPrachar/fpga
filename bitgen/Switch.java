public class Switch extends Module {
    private static class Side {
        public static final int Left = 0;
        public static final int Top  = 1;
        public static final int Right = 2;
        public static final int Bottom = 3;
        public static final int HighZ = 4;
    }
    int width;
    public Switch(String name, int width) {
        super("Switch", name);
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
        return new byte[] {(byte)(diff & 1),(byte)(diff & 2)};
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
