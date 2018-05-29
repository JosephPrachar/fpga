# Verilog-to-Routing Readme

This folder contains the FPGA architecture described in the VTR .xml specification
language and multiple benchmarks that can run on the architecture using the VTR tool.

This file will contain a barebones description of common commands when using VTR.
When this documentation fails to answer questions, it is best to fall back on the
[complete VTR documentation](https://docs.verilogtorouting.org/en/latest/).

### Install

First clone and build the VTR project.

```bash
git clone https://github.com/verilog-to-routing/vtr-verilog-to-routing.git
cd vtr-verilog-to-routing/
make -j 12
```

The rest of this file will depend on the environment variable VTR_HOME to be set
to this directory. This should be added to your `.bashrc` file so that it is always
available. (with your actual path, of course)

```bash
export VTR_HOME=/home/jprachar/projects/vtr-verilog-to-routing
```

### Use

##### run_vtr_flow.pl

The first step of the flow is to execute the run_vtr_flow.pl script in order to
generate the .blif file which appears inside the temp/ directory. This step can
go wrong in many ways as this script actually calls three different tools.
Additional information in case of a failure can be learned from the files in temp/.
In the case that the script actually crashed before dumping output from the currently
running program (a somewhat common occurrence) it will be necessary to run the tools
(abc, odin, vpr) manually from the command line in order to get a better idea of what
is going wrong. Examples for how do this can be seen in some of the output log files.

```bash
$VTR_HOME/vtr_flow/scripts/run_vtr_flow.pl adder_4bit.v basic.xml
```

##### vpr

The next step of the flow is to do the place and route with the vpr tool. This also
leads to the production of the semi-interactive graphics tool which displays the
architecture with the specified circuit projected onto it.

The important files that are produced from this tool are the .place, .route, and .net
in addition to the .pre-vpr.blif file from the run_vtr_flow.pl. These files will be
used by the bitgen tool to create a bitstream that can be used to actually program
the device.

```bash
$VTR_HOME/vpr/vpr basic.xml temp/adder_4bit.pre-vpr.blif --disp on --route_chan_width 10
```

