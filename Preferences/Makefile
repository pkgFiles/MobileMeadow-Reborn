TARGET := iphone:clang:latest:14.5

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MobileMeadowRebornPrefs

MobileMeadowRebornPrefs_FILES = $(shell find Sources/MobileMeadowRebornPrefs -name '*.swift') $(shell find Sources/MobileMeadowRebornPrefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
MobileMeadowRebornPrefs_SWIFTFLAGS = -ISources/MobileMeadowRebornPrefsC/include
MobileMeadowRebornPrefs_INSTALL_PATH = /Library/PreferenceBundles
MobileMeadowRebornPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
