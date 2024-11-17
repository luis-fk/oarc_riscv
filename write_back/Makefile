# Variáveis
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
OUTPUT = wave.vvp
TESTBENCH = flopr.v write_back.v write_back_tb.v mux3.v

# Alvo padrão
all: wave

# Compila o código com iverilog
$(OUTPUT): $(TESTBENCH)
	$(IVERILOG) -o $@ $^

# Executa o código compilado
run: $(OUTPUT)
	$(VVP) $<

# Abre o gtkwave
wave: run
	$(GTKWAVE) wave.vcd

# Limpa arquivos gerados
clean:
	rm -f $(OUTPUT) wave.vcd
