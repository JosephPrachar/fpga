public class Block {
    String name;
    int x, y, subblk;

    public Block(String name, int x, int y, int subblk) {
        this.name = name;
        this.x = x;
        this.y = y;
        this.subblk = subblk;
    }

    public String getName() {
        return name;
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
}
