CC     = riscv64-unknown-elf-gcc
QEMU   = qemu-riscv64
SRC    = tests/test.c src/mult.s
CFLAGS = -O2

DATASETS = 3 10 16 50

test:
	@for d in $(DATASETS); do \
		echo "Running dataset$$d"; \
		$(CC) $(CFLAGS) -DDATASET_FILE="\"dataset$$d.h\"" -o test$$d.elf $(SRC); \
		$(QEMU) ./test$$d.elf; \
	done

clean:
	rm *.elf

