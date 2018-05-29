# LaTeX Report Readme

This folder of the project contains all text and picture files to compile my
entire report via LaTeX.

Operating System: Ubuntu 16.04 LTS  
LaTeX: pdfTeX (TeX Live)

### Install

```bash
sudo apt-get install texlive-latex-base  
sudo apt-get install texlive-latex-recommended
sudo apt-get install texlive-latex-extra
```

### Compile

Run this command twice (in order to produce the table of contents)

```bash
pdflatex fpga_report.tex
```

This will produce the report file `fpga_report.pdf`.
