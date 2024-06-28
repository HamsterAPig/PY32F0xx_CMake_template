# PY32F0xx_CMake_template

* Template project for Puya PY32F0 MCU
* Supports GNU Arm Embedded Toolchain
* Supports J-Link and DAPLink/PyOCD programmers
* Supports IDE: VSCode, Clion and other IDEs that support CMake

# Puya PY32F0 Family

PY32F0 are cost-effective Arm Cortex-M0+ microcontrollers featured with wide range operating voltage from 1.7V to 5.5V. Datesheets and Reference Manuals can be found at [WIKI](https://github.com/IOsetting/py32f0-template/wiki).

## PY32F002B

Frequency up to 24 MHz, 24 Kbytes of Flash memory, 3 Kbytes of SRAM.

* PY32F002B
  * PY32F002Bx(24KB Flash/3KB RAM)

## PY32F0xx

Frequency up to 48 MHz, 16 to 64 Kbytes of Flash memory, 3 to 8 Kbytes of SRAM.

* PY32F002A
  * PY32F002Ax5(20KB Flash/3KB RAM)
* PY32F003
  * PY32F003x4(16KB Flash/2KB RAM), PY32F003x6(32KB Flash/4KB RAM), PY32F003x8(64KB Flash/8KB RAM)
* PY32F030
  * PY32F030x4(16KB Flash/2KB RAM), PY32F030x6(32KB Flash/4KB RAM), PY32F030x8(64KB Flash/8KB RAM)

## PY32F07x

Frequency up to 72 MHz, 128 Kbytes of Flash memory, 16 Kbytes of SRAM, with more peripherals(CAN, USB)

* PY32F040
  * PY32F040xB(128KB Flash/16KB RAM)
* PY32F071
  * PY32F071xB(128KB Flash/16KB RAM)
* PY32F072
  * PY32F072xB(128KB Flash/16KB RAM)

# File Structure

```
├── Build                       # Build results
├── Docs                        # Datesheets and User Manuals
├── Examples
│   ├── PY32F002B               # PY32F002B examples
│   │   ├── HAL                 # HAL library examples
│   │   └── LL                  # LL(Low Layer) library examples
│   ├── PY32F07x                # PY32F07x examples
│   │   └── HAL                 # HAL library examples
│   └── PY32F0xx                # PY32F002A,PY32F003,PY32F030 examples
│       ├── FreeRTOS            # FreeRTOS examples
│       ├── HAL                 # HAL library examples
│       └── LL                  # LL(Low Layer) library examples
├── Libraries
│   ├── CMSIS
│   ├── EPaper                  # Waveshare e-paper library
│   ├── FreeRTOS                # FreeRTOS library
│   ├── LDScripts               # LD files
│   ├── PY32F002B_HAL_BSP       # PY32F002B HAL BSP
│   ├── PY32F002B_HAL_Driver    # PY32F002B HAL library
│   ├── PY32F002B_LL_BSP        # PY32F002B LL(low layer) BSP
│   ├── PY32F002B_LL_Driver     # PY32F002B LL library
│   ├── PY32F07x_HAL_BSP        # PY32F040/071/072 HAL BSP
│   ├── PY32F07x_HAL_Driver     # PY32F040/071/072 HAL library
│   ├── PY32F0xx_HAL_BSP        # PY32F002A/003/030 HAL BSP
│   ├── PY32F0xx_HAL_Driver     # PY32F002A/003/030 HAL library
│   ├── PY32F0xx_LL_BSP         # PY32F002A/003/030 LL BSP
│   └── PY32F0xx_LL_Driver      # PY32F002A/003/030 LL library
├── Misc
│   ├── Flash
│   │   ├── JLinkDevices        # JLink flash loaders
│   │   └── Sources             # Flash algorithm source code
│   ├── Puya.PY32F0xx_DFP.x.pack # DFP pack file for PyOCD
│   └── SVD                     # SVD files
├── README.mdMakefile 
└── User                        # User application code
```

# Requirements

* PY32F0 EVB or boards of PY32F002/003/030 series
* Programmer
  * J-Link: J-Link OB programmer
  * PyOCD: DAPLink or J-Link
* SEGGER J-Link Software and Documentation pack [https://www.segger.com/downloads/jlink/](https://www.segger.com/downloads/jlink/)
* PyOCD [https://pyocd.io/](https://pyocd.io/)
* GNU Arm Embedded Toolchain

# Building

## 1. Install GNU Arm Embedded Toolchain

Download the toolchain from [Arm GNU Toolchain Downloads](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads) according to your pc architecture, extract the files

```bash
sudo mkdir -p /opt/gcc-arm/
sudo tar xvf arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi.tar.xz -C /opt/gcc-arm/
cd /opt/gcc-arm/
sudo chown -R root:root arm-gnu-toolchain-12.2.rel1-x86_64-arm-none-eabi/
```

## 2. Create Your Project
### Clone This Repo
Clone this repository to local workspace
```bash
git clone https://github.com/HamsterAPig/PY32F0xx_CMake_template.git
```

### Using This Repo as Template
In the meantime, you can also create a copy of your own by clicking on `Use this template` above this repository

## 3. Install SEGGER J-Link Or PyOCD

### Option 1: Install SEGGER J-Link

Download and install JLink from [J-Link / J-Trace Downloads](https://www.segger.com/downloads/jlink/).

```bash
# installation command for .deb
sudo dpkg -i JLink_Linux_V784f_x86_64.deb
# uncompression command for .tar.gz
sudo tar xvf JLink_Linux_V784f_x86_64.tgz -C [target folder]
```
The default installation directory is */opt/SEGGER*

Copy [Project directory]/Misc/Flash/JLinkDevices to [User home]/.config/SEGGER/
```bash
cd py32f0-template
cp -r Misc/Flash/JLinkDevices/ ~/.config/SEGGER/
```
Read more: [https://wiki.segger.com/J-Link_Device_Support_Kit](https://wiki.segger.com/J-Link_Device_Support_Kit)

### Option 2: Install PyOCD

Don't install from apt repository, because the version 0.13.1+dfsg-1 is too low for J-Link probe.

Install PyOCD from pip

```bash
pip uninstall pyocd
```
This will install PyOCD into:
```
/home/[user]/.local/bin/pyocd
/home/[user]/.local/bin/pyocd-gdbserver
/home/[user]/.local/lib/python3.10/site-packages/pyocd-0.34.2.dist-info/*
/home/[user]/.local/lib/python3.10/site-packages/pyocd/*
```
In Ubuntu, .profile will take care of the PATH, run `source ~/.profile` to make pyocd command available

## 4. Use CMake to Generate
Use `CMake -D` to specify the generation of relevant definitions, as a example, you can run
```shell
cmake -DSELECTED_DEVICE=PY32F030x8
```

### FreeRTOS Support
Use `CMake -DUSE_FREERTOS=ON` to enable FreeRTOS Support, and use `-DFREERTOS_HEAP=4` to specify how to use what memory allocation
## 5. Compiling And Flashing

```bash
# clean source code
make clean
# build
make
# or make with verbose output
V=1 make
# flash
make flash
```
# Feature
- [x] Support PY32F0xx
- [x] Support PY32F002B
- [x] Support PY32F07x
- [x] Support LL Option
- [x] Support FreeRTOS Option
- [ ] Support EPaper Option

# Try Other Examples

More examples can be found in *Examples* folder, copy and replace the files under *User* folder to try different examples.

# Links

* Puya Product Page(Datasheet download): https://www.puyasemi.com/mcu_weichuliqi.html
