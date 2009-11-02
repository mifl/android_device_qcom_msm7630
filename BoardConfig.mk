# Copyright (c) 2009, Code Aurora Forum.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
# config.mk
#
# Product-specific compile-time definitions.
#

ifeq ($(QC_PROP),true)
    BOARD_USES_QCOM_HARDWARE := true
    BOARD_USES_QCOM_7x_CHIPSET := true
    BOARD_USES_ADRENO_200 := true
    BOARD_USES_QCOM_AUDIO_V2 := true

    ifneq ($(BUILD_TINY_ANDROID), true)
    BOARD_GPS_LIBRARIES := libloc_api
    BOARD_CAMERA_LIBRARIES := libcamera
    BOARD_HAVE_BLUETOOTH := true
    BOARD_WPA_SUPPLICANT_DRIVER := WEXT
    endif   # !BUILD_TINY_ANDROID

else
    BOARD_USES_GENERIC_AUDIO := true
    USE_CAMERA_STUB := true

endif # QC_PROP

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_NO_RADIOIMAGE := true

TARGET_BOOTLOADER_LIBS := \
	libboot_board_surf \
	libboot_arch_qsd8k \
	libboot_arch_armv6

TARGET_BOOTLOADER_LINK_SCRIPT := \
	vendor/qcom/$(TARGET_PRODUCT)/boot/boot.ld

NAND_PAGE_SIZE := 4096
TARGET_CPU_ABI := armeabi

BOARD_KERNEL_CMDLINE := console=ttyDCC0 androidboot.hardware=qcom

TARGET_USERIMAGES_USE_EXT2 := true
