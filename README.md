[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/zephyr-ada/ada-project-example)

# Zephyr RTOS based ADA application project example

The project is a proof of concept that Ada can run over Zephyr RTOS as a user application.

The key points:

* Zephyr toolchain is compiled from sources with a patch to enable Ada compiler.
* SDK is built into Docker image to use as VS Code's devcontainer.
* CMake module for Ada support is added to compile Ada adb files with CMake.
* The minimal working piece of Ada GNAT library is implemented as Zephyr module. Ada.Text_IO is done partially to print hello world only.
* VS Code's tasks are added for easy firmware run on Renode emulator and attaching to shell.

## Table of Contents

<!-- TOC -->

- [Zephyr RTOS based ADA application project example](#zephyr-rtos-based-ada-application-project-example)
    - [Table of Contents](#table-of-contents)
    - [Quick run GitPod](#quick-run-gitpod)
    - [Quick run console](#quick-run-console)
    - [Quick run VS Code](#quick-run-vs-code)
        - [guiconfig on Windows](#guiconfig-on-windows)
    - [Flash and debug a development board](#flash-and-debug-a-development-board)
        - [Terms](#terms)
        - [Concept](#concept)
        - [JLink](#jlink)
    - [Project configuration](#project-configuration)
    - [Ada bindings to Zephyr](#ada-bindings-to-zephyr)
    - [Known Issues](#known-issues)
        - [Breakpoints on Ada code](#breakpoints-on-ada-code)
        - [GitPod can not run menuconfig from CMake targets explorer](#gitpod-can-not-run-menuconfig-from-cmake-targets-explorer)

<!-- /TOC -->


## Quick run (GitPod)

* Make sure default IDE setting in GitPod user preferences set to VS Code
* Click on "GitPod ready-to-code" button
* Wait until workspace created and repository modules initialized
* If "Select a configure preset for ada-project-example" shows choose "UART shell"
* Click the "Build" button on the status bar
* Run Task by choose: Menu > Terminal > Run Task... > "Launch Renode and Connect UART" > Continue without scanning the task output
* Wait until Renode simulator launch firmware and prints the shell prompt to the emulated UART console
* You can type to the shell something like "kernel version"
* Go to the "Run and Debug" tab and launch "Renode GDB" to debug
* Configure Zephyr in a new Bash terminal

       $ west build -t menuconfig


## Quick run (console)

 * Update modules declared in West manifest file

       $ make init-repo

* Run build

       $ make build

* Launch Renode

       $ ./utils/launch_renode.sh

* Connect to Zephyr shell

       $ ./utils/renode_uart.sh

* Connect to GDB server

       $ arm-zephyr-eabi-gdb ./build/zephyr/zephyr.elf \
         --eval-command="target remote localhost:3333" \
         --eval-command="break ada_hello" \
         --eval-command="continue" \
         --tui

* Run Zephyr configuration

       $ west build -t menuconfig

## Quick run (VS Code)

* Clone repository. For Windows: clone repository to WSL2 folder. For example: \\\wsl\Ubuntu\home\user\dev
* Open project in VS Code. Additionaly for Windows: Use Remote-WSL plugin and Reopen Folder in WSL
* Use Remote-Containers plugin and Reopen in container
* Update modules declared in West manifest file

      $ make init-repo

* Run build

      $ make build
    
* Run task "Launch Renode and connect UART"
* Launch debug session "Renode GDB (Local)"
* Run Zephyr configuration

       $ west build -t guiconfig

### guiconfig on Windows

* Install VcXsrv on Windows Host system.
* Run it with all default parameters.
* Run guiconfig. Now X server can be accessible. During container build the DISPLAY variable was set to host.docker.internal:0 value


## Flash and debug a development board

### Terms

Host is a system where Docker is running (outside) and which a development board is attached to.
Container is a system which Docker containerize (inside) and where SDK is installed and VS Code is attached to interact with.

### Concept

The common way to debug from the container is to use GDB's remote target feature.

* Run GDB server on the Host. (OpenOCD, PyOCD, JLink, etc) Keep it running all time. It no needs attention.
* In the Container system run GDB client (arm-zephyr-eabi-gdb)
* Connect to the remote target 'host.docker.internal'.

Note that VS Code should be in the container and the left bottom button should be named like 'Dev Container: Zephyr SDK ADA'.

### JLink

For STM32 development board use STLinkReflash utility to converting ST-LINK On-Board Into a J-Link.

* On the Host system run J-Link Remote Server. Keep it running all time. It doesn't need attention.
* In the Container system run VS Code's launch 'J-Link GDB (Docker Host). 
* Now VSCode will run Launch Task which runs the JLink GDB server inside Container. JLink GDB server connects to 'host.docker.internal' on the Host where J-Link Remote Server run. Now, debug as usual.

## Project configuration

Two predefined configurations are available with a different peripheral interface for the Zephyr shell.

* UART. It is good for Renode as it has a UART peripheral. Also good if you have hardware UART-USB converter.
* Segger RTT. It is good if your debugger is JLink.

To switch between configuration use CMake plugin's build variant or pass CONF_FILE variable to the Makefile as argument:

       $ CONF_FILE=prj_rtt_shell.conf make build

## Ada bindings to Zephyr

Ada compiler has a bindings generator that produces Ada specifications for C headers.
For example, for the kernel.h C header can be generated the kernel_h.ads Ada specification.
To generate the specifications use -fdump-ada-spec compiler flag.

In a Makefile create the variable

     EXTRA_CFLAGS := -fdump-ada-spec

and pass to the west build command as argument the flag

    -DEXTRA_CFLAGS=$(EXTRA_CFLAGS)

Or set up VS Code's CMake plugin by modify cmake-variants-yaml file

    choices:
      app:
        settings:
          EXTRA_CFLAGS: -fdump-ada-spec

Specifications will built to the ./build filder.
To ADAFLAGS added -I/workspaces/ada-project-example/build so generated specification will be available.

Note: It can increase compilation time up to six times. Also, some C macros and types can not be generated equivalently to Ada's.

## Known Issues

### Breakpoints on Ada code

When debug is run on Renode, not possible to set a break point on Ada code. But it is possible to set by the GDB console.

       > break ada_hello

JLink works fine. Maybe the cause is the cortex-debug plugin variable 'servertype' set to 'external'.

### GitPod can not run menuconfig from CMake targets explorer

Use West command

       $ west build -t menuconfig
