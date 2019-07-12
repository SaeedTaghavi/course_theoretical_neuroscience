# adding some comment
#
#by Saeed Taghavi

COMPILER = gfortran
FLAGS = -O0 
EXEFILE = 2neurons.exe
BASE = $(shell pwd)

default: help
help: 
	@echo "help for using make:"
	@echo "make clean:   will remove all output files (*.txt & output.*) and the executalbe file "
	@echo "make compile: will compile the main file"
	@echo "make run:     will run the executable"
	@echo "make plot:    will plot the output, for more information look at the plot.gpt file"

clean: clean_exec clean_output
	@echo 

clean_exec:
	@echo "Cleaning executable ......"
	@rm -f $(BASE)/$(EXEFILE)

clean_output:
	@echo "Cleaning outputs ......"
	@rm -f $(BASE)/*.txt
	@rm -f $(BASE)/output.*
	@rm -f $(BASE)/output/*.txt
	@rm -f $(BASE)/output/output.*

plot:
	@gnuplot $(BASE)/plots/plot.gpt
	@mv $(BASE)/*.svg $(BASE)/plots
	@mv $(BASE)/*.eps $(BASE)/plots
	
compile:
	@echo  "Compiling ...."
	@echo
	$(COMPILER) $(BASE)/src/*.f90 -o $(EXEFILE)

run: 
	@echo "running ...."
	$(BASE)/$(EXEFILE)
	@mkdir -p $(BASE)/output
	@mv $(BASE)/*.txt $(BASE)/output

# library directory

#LIBS = $(BASE)/lib

#sources directory

#SRC = $(BASE)/src

# include directory

#INCLDS = -I$(BASE)/include/ 

#LIB_FILE = $(LIBS)/lib_finazs.$(VERSION).a

#Sources = $(shell ls $(SRC))

#OBJS = $(Sources:.cpp=.o)

#SRC_CMP = $(Sources:%.cpp=$(SRC)/%.cpp)

#EXEFILE = $(BASE)/bin/FinAzS


#MAIN_SRC= $(BASE)/main/main.cpp
#MOBJ = main.o

# print:
# 	@echo $(Sources)
# 	@echo "--------------"
# 	@echo $(SRC_CMP)

# main: $(MOBJ) 
# 	@echo  "Compiling the main"
# 	@echo
# 	$(CC) $(LINK_FLAGS) $(MOBJ) $(LIB_FILE) -o $(EXEFILE)
# $(MOBJ):
# 	$(CC) $(CFLAGS) $(INCLDS) -c $(MAIN_SRC)

# lib:write libclean libmake clean

# write:
# 	@echo 
# 	@echo "-------------------------------------------"
# 	@echo 

# libclean:
# 	@echo "Removing the old library file......."
# 	rm -f $(LIB_FILE)

# libmake: makelib
# 	@echo "Making radom access to the library files ....."
# 	ranlib $(LIB_FILE)

# makelib:compile $(OBJS)
# 	@echo "Making library file ....."
# 	ar  $(LIBFLAGS) $(LIB_FILE) $(OBJS)

# compile:
# 	@echo "Compiling files for making library....."
# 	$(CC) $(CFLAGS) $(INCLDS) -c $(SRC_CMP)
# clean:
# 	@echo "Cleaning ......"
# 	@rm -f $(OBJS) $(MOBJ)

