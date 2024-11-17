# Variáveis
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
OUTPUT = wave.vvp
VCD = wave.vcd
TESTBENCH = fetch_tb.v fetch.v flopenr.v instruction_memory.v mux2.v

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
	$(GTKWAVE) $(VCD)

# Limpa arquivos gerados
clean:
	rm -f $(OUTPUT) $(VCD)
