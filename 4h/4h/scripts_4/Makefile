SNIPER_BASE_DIR ?= /home/thanasis-linux/sniper-7.3
SNIPER_INCLUDE_DIR = $(SNIPER_BASE_DIR)/include

CC = gcc

TARGET = locks 

LFLAG ?=  -DTTAS_CAS## -DMUTEX-DTAS_TSor  or -DTTAS_TS or  or -DTAS_CAS
IMPLFLAG ?=  -DREAL## or-DSNIPER  

CFLAGS ?= -Wall -O0 -lpthread $(IMPLFLAG) $(LFLAG) #-DDEBUG
CFLAGS += -I$(SNIPER_INCLUDE_DIR)
CFLAGS += -Wno-unused-variable

$(TARGET): locks_scalability.c
	$(CC) $^ $(HOOKS_LDFLAGS) $(CFLAGS) -o $@

clean :
	rm -f $(TARGET)
