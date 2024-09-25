TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MobileMeadowRebornApps

MobileMeadowRebornApps_FILES = $(shell find Sources/MobileMeadowRebornApps -name '*.swift') $(shell find Sources/MobileMeadowRebornAppsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
MobileMeadowRebornApps_SWIFTFLAGS = -ISources/MobileMeadowRebornAppsC/include
MobileMeadowRebornApps_CFLAGS = -fobjc-arc -ISources/MobileMeadowRebornAppsC/include

include $(THEOS_MAKE_PATH)/tweak.mk
