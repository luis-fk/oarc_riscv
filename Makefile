# Variáveis
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
OUTPUT = wave.vvp
VCD = wave.vcd
TESTBENCH = top/top_testbench.sv top/top.sv top/imem.sv top/dmem.sv \
            riscv/datapath/adder.sv riscv/datapath/alu.sv \
            riscv/datapath/datapath.sv riscv/datapath/extend.sv \
            riscv/datapath/flopenr.sv riscv/datapath/floprc.sv \
            riscv/datapath/flopr.sv riscv/datapath/mux2.sv \
            riscv/datapath/mux3.sv riscv/datapath/regfile.sv \
            riscv/datapath/hazard.sv riscv/datapath/flopenrc.sv \
            riscv/riscv.sv controller/controller.sv controller/maindec.sv \
            controller/aludec.sv

# Alvo padrão
all: $(VCD)

# Compila o código com iverilog
$(OUTPUT): $(TESTBENCH)
	$(IVERILOG) -g2012 -o $@ $^

# Executa o código compilado e gera o VCD
$(VCD): $(OUTPUT)
	$(VVP) $<

# Abre o gtkwave
wave: $(VCD)
	$(GTKWAVE) $<

# Limpa arquivos gerados
clean:
	rm -f $(OUTPUT) $(VCD)

# Faz tudo (compilar, executar e abrir gtkwave)
.PHONY: all clean wave
