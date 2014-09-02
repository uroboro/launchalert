export TARGET = iphone:clang:latest
export ARCHS = armv7 arm64
export THEOS_PACKAGE_DIR = packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = launchAlert
launchAlert_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd || killall -9 SpringBoard"
