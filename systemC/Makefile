#--------------------------------------------------------
# Simple Makefile
# Note header files are not checked if updated!
#--------------------------------------------------------

# Specify all source and header files
SRCS = master.cpp toplevel.cpp
SRCH = master.h myMem.h myMem_if.h

# Target file "run";
TARGET = run

# Variable that points to SystemC installation path
SYSTEMC = /usr/local/systemc-2.2
TARGET_ARCH = linux64

INCDIR = -I. -I.. -I$(SYSTEMC)/include
LIBDIR = -L. -L.. -L$(SYSTEMC)/lib-$(TARGET_ARCH)
LIBS   = -lsystemc -lm

CC	 = g++
CFLAGS = -g -Wno-deprecated -Wall
OBJS   = $(SRCS:.cpp=.o)

EXE	= $(TARGET)

.SUFFIXES: .cpp .o  

$(EXE): $(OBJS) $(SRCH)  
	$(CC) $(CFLAGS) $(INCDIR) $(LIBDIR) -o $@ $(OBJS) $(LIBS) 2>&1 | c++filt

all: $(EXE)	
	
.cpp.o:
	$(CC) $(DEBUG) $(CFLAGS) $(INCDIR) -c $<

clean:
	rm -f $(OBJS) *~ $(EXE) *.bak $(TARGET).stackdump
