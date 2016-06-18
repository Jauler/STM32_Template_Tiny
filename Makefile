TARGET=sample

CSRCS=main.c

ASMSRCS=startup_ARMCM4.s

CFLAGS+=-Wall
CFLAGS+=-mcpu=cortex-m4
CFLAGS+=-mthumb
CFLAGS+=-g

LDFLAGS+=-TSTM32_flash.ld
LDFLAGS+=-nostartfiles
LDFLAGS+=-mcpu=cortex-m4
LDFLAGS+=-mthumb
LDFLAGS+=-g

DEPFLAGS+=-MT $@ -MMD -MP -MF $*.d




ifeq ($(CC),cc)
	CC=gcc
endif

SIZE?=size
OBJCOPY?=objcopy
CROSS?=arm-none-eabi-

OBJS=$(CSRCS:.c=.o)
OBJS+=$(ASMSRCS:.s=.o)

all: executable binary info

executable: $(OBJS)
	$(CROSS)$(CC) $(OBJS) $(LDFLAGS) -o $(TARGET).elf

binary:
	$(CROSS)$(OBJCOPY) -O binary $(TARGET).elf $(TARGET).bin

info:
	$(CROSS)$(SIZE) -A $(TARGET).elf

%.o : %.c %.d
	$(CROSS)$(CC) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

%.o : %.s
	$(CROSS)$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf
	rm -f $(TARGET).bin

%.d: ;
.PRECIOUS: %.d

-include $(patsubst %,%.d,$(basename $(CSRCS)))



