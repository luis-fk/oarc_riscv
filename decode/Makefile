# Variáveis
IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave
OUTPUT = wave.vvp
TESTBENCH = decode_tb.v ExtendImm.v decode.v flopenrc.v \
            ./BancoRegistradores/BancoRegistradores.v \
            ./BancoRegistradores/Codificador.v \
            ./BancoRegistradores/Mux32x64bits.v \
            ./BancoRegistradores/RegistradorZero.v \
            ./BancoRegistradores/Registrador.v

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
