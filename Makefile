.PHONY: build prove clean

build:
	gprbuild -P projekt.gpr

prove:
	gnatprove -P projekt.gpr

prove-verbose:
	gnatprove -P projekt.gpr -v

clean:
	gprclean -P projekt.gpr
	rm -rf obj/ *.ali *.o

all: clean build prove
