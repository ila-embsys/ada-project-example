ifeq ($(OS),Windows_NT)
	RM=powershell rm -Force
else
	RM=rm -rf
endif

ifndef BOARD
	BOARD=stm32f429i_disc1
endif

PLATFORM_SPECIFIC_LOCS_ARG=-DKCONFIG_ROOT=KConfig -DOUT_OF_TREE_BOARD=OFF -DOUT_OF_TREE_SOC=OFF -DOUT_OF_TREE_DTS=OFF
CONF_FILE ?= prj_uart_shell.conf
# EXTRA_CFLAGS := -fdump-ada-spec

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(patsubst %/,%,$(dir $(mkfile_path)))

export ADA = arm-zephyr-eabi-g++
export ADAFLAGS = --RTS=$(current_dir)/modules/gnat -I$(current_dir)/build -gnat12

.PHONY : all
all : zephyr-export init-repo build

# See https://docs.zephyrproject.org/latest/guides/zephyr_cmake_package.html
# Only for ver 2.2.99+
.PHONY: zephyr-export
zephyr-export:
	west zephyr-export

.PHONY: configure
configure:
	west build -b $(BOARD) -p auto app --cmake-only -- $(PLATFORM_SPECIFIC_LOCS_ARG) -DCONF_FILE=$(CONF_FILE) -DEXTRA_CFLAGS=$(EXTRA_CFLAGS)

.PHONY: build
build:
	west build -b $(BOARD) -p auto app -- $(PLATFORM_SPECIFIC_LOCS_ARG) -DCONF_FILE=$(CONF_FILE) -DEXTRA_CFLAGS=$(EXTRA_CFLAGS)

.PHONY: init-repo
init-repo:
	west update
	# git apply ./patches/zephyr/* --directory=zephyr
	chmod +x ./utils/*.sh

.PHONY: reinit-repo
reinit-repo:
	west update

.PHONY: clean
clean:
	$(RM) build
