public class Block {
    String name;
    int x, y, subblk;
    Module settings;


    public Block(String name, int x, int y, int subblk) {
        this.name = name;
        this.x = x;
        this.y = y;
        this.subblk = subblk;
        if (x == 1 && y == 3) {
            settings = new IOBlock("ioblock" + ((Integer)subblk).toString());
        } else if (x == 3 && y == 1) {
            settings = new IOBlock("ioblock" + ((Integer)(subblk + 5)).toString());
        } else if (x == 1 && y == 0) {
            settings = new IOBlock("ioblock" + ((Integer)(subblk + 10)).toString());
        } else if (x == 0 && y == 1) {
            settings = new IOBlock("ioblock" + ((Integer)(subblk + 15)).toString());
        } else if (x == 1 && y == 1) {
            settings = new LogicCluster("sw_logic");
        } else if (x == 2 && y == 1) {
            settings = new LogicCluster("se_logic");
        } else if (x == 1 && y == 2) {
            settings = new LogicCluster("nw_logic");
        } else if (x == 2 && y == 2) {
            settings = new LogicCluster("ne_logic");
        }
    }
    public Block(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public static String posToName(int x, int y, int subblk) {
        if (x == 1 && y == 3) {
            return "ioblock" + ((Integer)subblk).toString();
        } else if ((x == 3 && y == 1) || (x == 3 && y == 2)) {
            return "ioblock" + ((Integer)(subblk + 5)).toString();
        } else if (x == 1 && y == 0) {
            return "ioblock" + ((Integer)(subblk + 10)).toString();
        } else if ((x == 0 && y == 1) || (x == 0 && y == 2)) {
            return "ioblock" + ((Integer)(subblk + 15)).toString();
        } else if (x == 1 && y == 1) {
            return "sw_logic";
        } else if (x == 2 && y == 1) {
            return "se_logic";
        } else if (x == 1 && y == 2) {
            return "nw_logic";
        } else if (x == 2 && y == 2) {
            return "ne_logic";
        }
        return null;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        } else if (o instanceof String) {
            return this.name.equals(o);
        } else if (o instanceof Block) {
            Block o_blk = (Block) o;
            return this.name.equals(o_blk.name);
        }
        return false;
    }

    @Override
    public int hashCode() {
        return this.name.hashCode();
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }

    public int getSubblk() {
        return subblk;
    }

    public void setSubblk(int subblk) {
        this.subblk = subblk;
    }

    public Module getSettings() {
        return settings;
    }

    public void setSettings(Module settings) {
        this.settings = settings;
    }
}
