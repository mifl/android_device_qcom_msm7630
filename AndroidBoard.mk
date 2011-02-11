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


LOCAL_PATH := $(call my-dir)

#----------------------------------------------------------------------
# Compile (L)ittle (K)ernel bootloader and the nandwrite utility
#----------------------------------------------------------------------
ifneq ($(strip $(TARGET_NO_BOOTLOADER)),true)

# Compile
include bootable/bootloader/lk/AndroidBoot.mk

INSTALLED_BOOTLOADER_TARGET := $(PRODUCT_OUT)/bootloader
file := $(INSTALLED_BOOTLOADER_TARGET)
ALL_PREBUILT += $(file)
$(file): $(TARGET_BOOTLOADER) | $(ACP)
	$(transform-prebuilt-to-target)

# Copy nandwrite utility to target out directory
INSTALLED_NANDWRITE_TARGET := $(PRODUCT_OUT)/nandwrite
file := $(INSTALLED_NANDWRITE_TARGET)
ALL_PREBUILT += $(file)
$(file) : $(TARGET_NANDWRITE) | $(ACP)
	$(transform-prebuilt-to-target)
endif

#----------------------------------------------------------------------
# Compile Linux Kernel
#----------------------------------------------------------------------
ifeq ($(KERNEL_DEFCONFIG),)
    KERNEL_DEFCONFIG := msm7630-perf_defconfig
endif

include kernel/AndroidKernel.mk

file := $(INSTALLED_KERNEL_TARGET)
ALL_PREBUILT += $(file)
$(file) : $(TARGET_PREBUILT_KERNEL) | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_OUT)/lib/modules/qce.ko
ALL_PREBUILT += $(file)
$(file) : $(KERNEL_OUT)/drivers/crypto/msm/qce.ko | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_OUT)/lib/modules/qcedev.ko
ALL_PREBUILT += $(file)
$(file) : $(KERNEL_OUT)/drivers/crypto/msm/qcedev.ko | $(ACP)
	$(transform-prebuilt-to-target)

$(KERNEL_OUT)/drivers/crypto/msm/qce.ko \
$(KERNEL_OUT)/drivers/crypto/msm/qcedev.ko : $(TARGET_PREBUILT_INT_KERNEL)

#----------------------------------------------------------------------
# Key mappings
#----------------------------------------------------------------------
file := $(TARGET_OUT_KEYLAYOUT)/surf_keypad.kl
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/surf_keypad.kl | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_OUT_KEYLAYOUT)/msm_tma300_ts.kl
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/msm_tma300_ts.kl | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_OUT_KEYLAYOUT)/7k_handset.kl
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/7k_handset.kl | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_OUT_KEYLAYOUT)/fluid-keypad.kl
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/fluid-keypad.kl | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := surf_keypad_qwerty.kcm
include $(BUILD_KEY_CHAR_MAP)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := surf_keypad_numeric.kcm
include $(BUILD_KEY_CHAR_MAP)

file := $(TARGET_OUT)/etc/vold.fstab
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/vold.fstab | $(ACP)
	$(transform-prebuilt-to-target)

ifeq ($(strip $(BOARD_HAS_QCOM_WLAN)),true)
file := $(TARGET_OUT)/etc/wifi/wpa_supplicant.conf
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/wpa_supplicant.conf | $(ACP)
	$(transform-prebuilt-to-target)
endif

#----------------------------------------------------------------------
# Splash screen
#----------------------------------------------------------------------
ifneq ($(BUILD_TINY_ANDROID), true)
RGB2565 := $(HOST_OUT_EXECUTABLES)/rgb2565$(HOST_EXECUTABLE_SUFFIX)
init_splash := $(TARGET_ROOT_OUT)/initlogo.rle

$(init_splash): $(LOCAL_PATH)/initlogo.png | $(RGB2565)
	mkdir -p $(TARGET_ROOT_OUT)
	convert -depth 8 $^ rgb:- | $(RGB2565) -rle > $@
ALL_PREBUILT += $(init_splash)
endif

#----------------------------------------------------------------------
# Radio image
#----------------------------------------------------------------------
TARGET_RADIO_PATH := 
ifneq ( $(TARGET_RADIO_PATH), )
    $(call add-radio-file,$(TARGET_RADIO_PATH))
endif
