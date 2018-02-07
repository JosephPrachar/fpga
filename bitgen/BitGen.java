import java.io.*;
import java.util.Scanner;

public class BitGen {
    public static void main(String[] args) throws FileNotFoundException {
        Scanner scanner;
        System.out.println(args.length);
        if (args.length == 0) {
            scanner = new Scanner(System.in);
        } else if (args.length == 1) {
            File file = new File(args[0]);
            if (file == null) {
                return;
            }
            scanner = new Scanner(file);
        } else {
            return;
        }
        Module mod = null;
        boolean done = false;

        while (!done && scanner.hasNextLine()) {
            if (args.length != 1) System.out.print("Bit Gen> ");
            String in = scanner.nextLine();
            if (in.isEmpty() || in.charAt(0) == '#') continue;
            if (args.length == 1) {
                System.out.print("BitGen> ");
                System.out.println(in);
            }
            String[] in_args = in.split(" ", 0);

            if (in_args[0].equals("createmodule")) {
                if (in_args.length != 2) {
                    System.out.println("Usage: createmodule <fpga|logiccluster|interconnectmatrix|ble|progmux|ioblock>");
                    continue;
                }

                if (in_args[1].equals("fpga")) {
                    mod = new FPGA("fpga");
                } else if (in_args[1].equals("logiccluster")) {
                    mod = new LogicCluster("lc");
                } else if (in_args[1].equals("interconnectmatrix")) {
                    mod = new ConnectionBox("ic", 5, 10);
                } else if (in_args[1].equals("ble")) {
                    mod = new LogicElement("ble");
                } else if (in_args[1].equals("progmux")) {
                    mod = new ProgMux("progmux", 4);
                } else if (in_args[1].equals("ioblock")) {
                    mod = new IOBlock("ioblock");
                } else if (in_args[1].equals("switch")) {
                    mod = new Switch("switch", 3);
                } else {
                    System.out.println("Usage: createmodule <fpga|logiccluster|interconnectmatrix|ble|progmux|ioblock>");
                }

            } else if (in_args[0].equals("setvalue")) {
                if (mod == null) {
                    System.out.println("Must call createmodule before values can be set");
                    continue;
                }
                if (in_args.length != 4 && in_args.length != 3) {
                    System.out.println("Usage: setvalue name [length] value");
                    continue;
                }
                int length = -1;
                String to_parse = null;
                if (in_args.length == 4) {
                    length = Integer.parseInt(in_args[2]);
                    to_parse = in_args[3];
                } else {
                    length = in_args[2].length();
                    to_parse = in_args[2];
                }
                int success = 0, fail = 0;
                for (int i = 0; i < length; i++) {
                    if (mod.SetValue(in_args[1], i, (byte)(to_parse.charAt(i) == '0' ? 0 : 1))) {
                        success++;
                    } else {
                        fail++;
                    }
                }
                System.out.println("Bit fields set: " + success + " (out of " + length + ")");
            } else if (in_args[0].equals("printbitstream")) {
                if (mod == null) {
                    System.out.println("Must call createmodule before bitstream can be printed");
                    continue;
                }
                if (!mod.IsValid()) {
                    System.out.println("Setup not valid");
                    continue;
                }
                byte[] data = mod.GetProgStream();
                if (in_args.length == 1) {
                    // ideal for copy/paste into verilog test bench
                    PrintDataStream(data);
                } else if (in_args.length == 2) {
                    BufferedWriter out = null;
                    try
                    {
                        FileWriter fstream = new FileWriter(in_args[1], false);
                        out = new BufferedWriter(fstream);
                        // reversed so the bitstream can just be read into the device straight from the file
                        for (int i = data.length - 1; i >= 0; i--) {
                            out.write(data[i]);
                        }
                        out.close();
                    }
                    catch (IOException e)
                    {
                        System.err.println("Error: " + e.getMessage());
                    }
                }
            } else if (in_args[0].equals("printnames")) {
                if (mod == null) {
                    System.out.println("Must call createmodule before names can be printed");
                    continue;
                }
                System.out.print(mod.GetNames());
            } else if (in_args[0].equals("quit")) {
                done = true;
            } else {
                System.out.println("Not one of the following recognized commands\n" +
                        "createmodule\nsetvalue\nprintbitstream\nprintnames\nquit");
            }
        }
    }

    public static void PrintDataStream(byte[] data) {
        System.out.println("Length: " + data.length);
        for (int i = 0; i < data.length; i++) {
            System.out.print(data[i]);
        }
        System.out.println();
    }
}
