######################################
# Makefile for building a project on 
# microcontroller AT32F437VMT7 using 
# operating system Free RTOS
######################################

######################################
# target
######################################
TARGET = app


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# source path
SOURCES_DIR =  \
bsp/libraries/cmsis/cm4/device_support/startup/gcc \
bsp/libraries/cmsis/cm4/device_support \
bsp/libraries/drivers/src \
src \
bsp/middlewares/freertos/source \
bsp/middlewares/freertos/source/portable/GCC/ARM_CM4F


######################################
# source
######################################
# C sources
C_SOURCES =  \
bsp/libraries/cmsis/cm4/device_support/system_at32f435_437.c \
bsp/libraries/drivers/src/at32f435_437_acc.c \
bsp/libraries/drivers/src/at32f435_437_adc.c \
bsp/libraries/drivers/src/at32f435_437_can.c \
bsp/libraries/drivers/src/at32f435_437_crc.c \
bsp/libraries/drivers/src/at32f435_437_crm.c \
bsp/libraries/drivers/src/at32f435_437_dac.c \
bsp/libraries/drivers/src/at32f435_437_debug.c \
bsp/libraries/drivers/src/at32f435_437_dma.c \
bsp/libraries/drivers/src/at32f435_437_dvp.c \
bsp/libraries/drivers/src/at32f435_437_edma.c \
bsp/libraries/drivers/src/at32f435_437_emac.c \
bsp/libraries/drivers/src/at32f435_437_ertc.c \
bsp/libraries/drivers/src/at32f435_437_exint.c \
bsp/libraries/drivers/src/at32f435_437_flash.c \
bsp/libraries/drivers/src/at32f435_437_gpio.c \
bsp/libraries/drivers/src/at32f435_437_i2c.c \
bsp/libraries/drivers/src/at32f435_437_misc.c \
bsp/libraries/drivers/src/at32f435_437_pwc.c \
bsp/libraries/drivers/src/at32f435_437_qspi.c \
bsp/libraries/drivers/src/at32f435_437_scfg.c \
bsp/libraries/drivers/src/at32f435_437_sdio.c \
bsp/libraries/drivers/src/at32f435_437_spi.c \
bsp/libraries/drivers/src/at32f435_437_tmr.c \
bsp/libraries/drivers/src/at32f435_437_usart.c \
bsp/libraries/drivers/src/at32f435_437_usb.c \
bsp/libraries/drivers/src/at32f435_437_wdt.c \
bsp/libraries/drivers/src/at32f435_437_wwdt.c \
bsp/libraries/drivers/src/at32f435_437_xmc.c \
bsp/middlewares/freertos/source/croutine.c \
bsp/middlewares/freertos/source/event_groups.c \
bsp/middlewares/freertos/source/list.c \
bsp/middlewares/freertos/source/queue.c \
bsp/middlewares/freertos/source/stream_buffer.c \
bsp/middlewares/freertos/source/tasks.c \
bsp/middlewares/freertos/source/timers.c \
bsp/middlewares/freertos/source/portable/memmang/heap_4.c \
src/at32f435_437_clock.c \
src/at32f435_437_int.c \
src/main.c

# CPP sources
CXX_SOURCES = 

# ASM sources
ASM_SOURCES =  \
bsp/libraries/cmsis/cm4/device_support/startup/gcc/startup_at32f435_437.s


######################################
# firmware library
######################################
PERIFLIB_SOURCES = 


#######################################
# binaries
#######################################
BINPATH =
PREFIX = arm-none-eabi-
CC = $(BINPATH)$(PREFIX)gcc
CXX = $(BINPATH)$(PREFIX)g++
AS = $(BINPATH)$(PREFIX)gcc -x assembler-with-cpp
CP = $(BINPATH)$(PREFIX)objcopy
AR = $(BINPATH)$(PREFIX)ar
SZ = $(BINPATH)$(PREFIX)size
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

# Build path
BUILD_DIR = build
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi


# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_STDPERIPH_DRIVER \
-DAT32F437VMT7

# C++ defines
CXX_DEFS =

# AS includes
AS_INCLUDES =  \
-Iinc

# C includes
C_INCLUDES =  \
-Iinc \
-Ibsp/libraries/drivers/inc \
-Ibsp/libraries/cmsis/cm4/device_support \
-Ibsp/libraries/cmsis/cm4/core_support \
-Ibsp/middlewares/freertos/source/include \
-Ibsp/middlewares/freertos/source/portable/GCC/ARM_CM4F


CXX_INCLUDES = 

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CXXFLAGS = -lstdc++ $(CFLAGS) $(CXX_DEFS) $(CXX_INCLUDES) -g -ggdb3 -fno-rtti -fno-exceptions \
-fverbose-asm -fdata-sections -ffunction-sections -fpermissive -Wa,-ahlms=$(BUILD_DIR)/$(notdir $(<:.cpp=.lst))


ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = ld/AT32F437xM_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys
LIBDIR =
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# list of c++ objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(CXX_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CXX_SOURCES)))

# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.cpp Makefile | $(BUILD_DIR) 
	$(CXX) -c $(CXXFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#---------------------------- write to mcu -----------------------------#
#flash: 
#	st-flash write build/$(TARGET).bin 0x8000000

#---------------------------- Jlink ---------------------------------#
#install:
#	JLinkExe -device STM32F103C8 -if swd -speed 4000
	#loadbin build/$(TARGET).bin 0x8000000

#######################################
# clean up
#######################################
clean:
	-rm -fR .dep $(BUILD_DIR)
  
#######################################
# dependencies
#######################################
-include $(shell mkdir .dep 2>/dev/null) $(wildcard .dep/*)

# *** EOF ***
