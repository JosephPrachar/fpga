import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class PlaceFile {
    List<Block> blocks;


    public PlaceFile(List<Block> blocks) {
        this.blocks = blocks;
    }

    public static PlaceFile parsePlaceFile(String filename) {
        try {
            FileReader fileReader = new FileReader(filename);
            BufferedReader br = new BufferedReader(fileReader);

            List<Block> blocks = new LinkedList<>();
            String line = null;

            while ((line = br.readLine()) != null) {
                // ignore metadata lines
                if (line.startsWith("#") || line.startsWith("Netlist_File:") || line.startsWith("Array size:"))
                    continue;

                String[] split = line.split("\\s+");
                if (split.length > 1) {
                    blocks.add(new Block(split[0], Integer.parseInt(split[1]), Integer.parseInt(split[2]),
                            Integer.parseInt(split[3])));
                }
            }
            return new PlaceFile(blocks);
        } catch (FileNotFoundException ex) {


        } catch (IOException ex) {

        }
        return null;
    }
}
