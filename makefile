build: clean
	@echo "$(shell tput setaf 2)Building...$(shell tput sgr0)"

	# Build kernel entry
	nasm -f elf ./bootloader/kernel-entry.asm -o ./build/kernel-entry.o
	
	# Build the MBR (binary)
	nasm -f bin ./bootloader/mbr.asm -o ./build/mbr.bin

	# Compile the kernel
	i686-elf-gcc -c ./kernel/kernel.c -o ./build/kernel.o -nostdlib -nostartfiles -ffreestanding -m32

	# Link the kernel and kernel entry together
	i686-elf-ld -Ttext 0x9000 --oformat binary ./build/kernel-entry.o ./build/kernel.o -o ./build/kernel.bin

	# Stich the kernel on to the MBR
	cat ./build/mbr.bin ./build/kernel.bin > ./build/os.bin

	# Create a floppy image for VirtualBox
	cp ./build/os.bin ./build/os.img
	dd if=./build/os.img of=./build/os_aligned.img bs=512 conv=sync

	@echo "$(shell tput setaf 2)Done.$(shell tput sgr0)"

clean:
	@echo "$(shell tput setaf 2)Cleaning...$(shell tput sgr0)"
	- rm -r build/*

run-vb:
	# Launch the VM in debug mode
	"/c/Program Files/Oracle/VirtualBox/VirtualBoxVM.exe" --startvm "BloreOS" --dbg

run:
	# Launch boch
	"/c/Program Files/Bochs-2.7/bochsdbg.exe" -f .bochsrc


