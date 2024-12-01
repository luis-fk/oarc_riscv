# Nome do arquivo de saída do iverilog
OUTPUT = wave.vvp

# Lista de fontes
SOURCES = pipelined_riscv_tb.v pipelined_riscv.v pipelined_riscv_fd.v \
          ./cu/aludec.v ./cu/cu.v ./cu/flopr.v ./cu/floprc.v ./cu/maindec.v \
          ./decode/ExtendImm.v ./decode/decode.v ./decode/flopenrc.v \
          ./decode/BancoRegistradores/BancoRegistradores.v \
          ./decode/BancoRegistradores/Codificador.v \
          ./decode/BancoRegistradores/Mux32x64bits.v \
          ./decode/BancoRegistradores/RegistradorZero.v \
          ./decode/BancoRegistradores/Registrador.v \
          ./execute/execute.v ./execute/ULA.v ./execute/mux2.v ./execute/mux3.v \
          ./fetch/fetch.v ./fetch/flopenr.v ./fetch/instruction_memory.v \
          ./hazard/hazard.v \
          ./memory/data_memory.v ./memory/memory.v \
          ./write_back/write_back.v

# Nome do arquivo gerado pelo VVP
WAVE = wave.vcd

# Alvo padrão (compilar, executar e abrir no GTKWave)
all: view

# Compilar com iverilog
compile:
	iverilog -o $(OUTPUT) $(SOURCES)

# Executar com vvp
simulate: compile
	vvp $(OUTPUT)

# Abrir no GTKWave
view: simulate
	gtkwave $(WAVE)

# Limpar os arquivos gerados
clean:
	rm -f $(OUTPUT) $(WAVE)
