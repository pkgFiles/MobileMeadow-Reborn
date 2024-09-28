TARGET := iphone:clang:latest:14.5
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MobileMeadowReborn

MobileMeadowReborn_FILES = $(shell find Sources/MobileMeadowReborn -name '*.swift') $(shell find Sources/MobileMeadowRebornC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
MobileMeadowReborn_SWIFTFLAGS = -ISources/MobileMeadowRebornC/include
MobileMeadowReborn_CFLAGS = -fobjc-arc -ISources/MobileMeadowRebornC/include
MobileMeadowReborn_EXTRA_FRAMEWORKS = SpringBoard BulletinBoard

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += MobileMeadowRebornApps
SUBPROJECTS += Preferences
include $(THEOS_MAKE_PATH)/aggregate.mk
