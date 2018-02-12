import java.util.ArrayList;
import java.util.List;

public abstract class Module {
    protected Module[] subModules;
    protected ControlBits[] fields;
    protected String name;
    protected String type;

    public Module(String type, String name) {
        this.type = type;
        this.name = name;
        this.fields = new ControlBits[0];
        this.subModules = new Module[0];
    }

    public byte[] GetProgStream() {
        int cur_pos = 0;
        byte[] toReturn = new byte[GetSize()];

        // The old way of doing this was dumb... New convention is least significant bit is in
        // array position[0] and goes into the bitstream first
        for (int i = 0; i < subModules.length; i++) {
            byte[] recurseProgStream = subModules[i].GetProgStream();

            for (int j = 0; j < recurseProgStream.length; j++) {
                toReturn[cur_pos++] = recurseProgStream[j];
            }
        }
        for (int i = 0; i < fields.length; i++) {
            ControlBits cur = fields[i];
            for (int j = cur.values.length - 1; j >= 0; j--) {
                toReturn[cur_pos++] = cur.values[j];
            }
        }
        return toReturn;
    }
    public int GetSize() {
        int size = 0;
        for (Module i : subModules) {
            size += i.GetSize();
        }
        for (ControlBits i : fields) {
            size += i.values.length;
        }
        return size;
    }

    public ControlBits GetBitField(String name) {
        ControlBits field;
        for (Module i : subModules) {
            field = i.GetBitField(name);
            if (field != null)
                return field;
        }
        for (ControlBits i : fields) {
            if (i.name.equals(name)) {
                return i;
            }
        }
        return null;
    }

    public byte GetBitFieldValue(String name) {
        return GetBitFieldValue(name, 0);
    }

    public byte GetBitFieldValue(String name, int index) {
        ControlBits field = GetBitField(name);
        if (field == null)
            return 2;
        else
            return field.values[index];
    }

    public boolean SetValue(String name, int bitIndex, byte value) {
        ControlBits field = GetBitField(name);
        if (field == null)
            return false;
        field.values[bitIndex] = value;
        return true;
    }

    public boolean SetValue(String name, byte[] values) {
        ControlBits field = GetBitField(name);
        if (field == null)
            return false;
        field.values = values;
        return true;
    }

    public boolean IsValid() {
        for (Module i : subModules) {
            if (!i.IsValid())
                return false;
        }
        return true;
    }

    public String GetNames() {
        String names = "";
        for (int i = subModules.length - 1; i >= 0; i--) {
            names = names + subModules[i].GetNames();

        }
        for (int i = 0; i < fields.length; i++) {
            ControlBits cur = fields[i];
            //for (int j = 0; j < cur.values.length; j++) {
                names = names + cur.name + " " + ((Integer) cur.values.length).toString() + "\n";
            //}
        }
        return names;
    }

    @Override
    public String toString() {
        return name;
    }
}
