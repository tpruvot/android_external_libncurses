LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-c-files-under, ncurses/tty)
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/base)
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/tinfo)
LOCAL_SRC_FILES := $(filter-out ncurses/tinfo/make_keys.c, $(LOCAL_SRC_FILES))
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/widechar)

LOCAL_SRC_FILES += \
	ncurses/trace/lib_trace.c \
	ncurses/trace/varargs.c \
	ncurses/trace/visbuf.c \
	ncurses/codes.c \
	ncurses/comp_captab.c \
	ncurses/expanded.c \
	ncurses/fallback.c \
	ncurses/lib_gen.c \
	ncurses/lib_keyname.c \
	ncurses/names.c \
	ncurses/unctrl.c \
	langinfo.c

LOCAL_SRC_FILES := $(sort $(LOCAL_SRC_FILES))

LOCAL_CFLAGS := \
	-DHAVE_CONFIG_H \
	-DUSE_WIDEC_SUPPORT=1 -DHAVE_WCHAR -DUSE_WIDECHAR \
	-DHAVE_MBLEN -DHAVE_MBTOWC -DHAVE_WCTOMB \
	-D_XOPEN_SOURCE_EXTENDED=1 \
	-U_XOPEN_SOURCE -D_XOPEN_SOURCE=500 \
	-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=199506L -DNDEBUG

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH) \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/ncurses \
	ndk/sources/android/support/include \

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libncursesw

include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)

LOCAL_SRC_FILES := $(call all-c-files-under, ncurses/tty) 
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/base) 
LOCAL_SRC_FILES += $(call all-c-files-under, ncurses/tinfo) 
LOCAL_SRC_FILES := $(filter-out ncurses/tinfo/make_keys.c, $(LOCAL_SRC_FILES))

LOCAL_SRC_FILES += ncurses/trace/lib_trace.c \
		ncurses/trace/varargs.c \
		ncurses/trace/visbuf.c \
		ncurses/codes.c \
		ncurses/comp_captab.c \
		ncurses/expanded.c \
		ncurses/fallback.c \
		ncurses/lib_gen.c \
		ncurses/lib_keyname.c \
		ncurses/names.c \
		ncurses/unctrl.c \
		langinfo.c

LOCAL_SRC_FILES := $(sort $(LOCAL_SRC_FILES))
		
LOCAL_CFLAGS := -DHAVE_CONFIG_H \
	-UUSE_WIDECHAR \
	-U_XOPEN_SOURCE -D_XOPEN_SOURCE=500 \
	-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=199506L -DNDEBUG

LOCAL_C_INCLUDES := $(LOCAL_PATH) \
	$(LOCAL_PATH)/include \
	$(LOCAL_PATH)/ncurses \
	ndk/sources/android/support/include \

LOCAL_MODULE_TAGS := eng
LOCAL_MODULE := libncurses

include $(BUILD_SHARED_LIBRARY)

# Copy only basic terminal type definitions as ncurses-base in debian does by default.
# http://anonscm.debian.org/gitweb/?p=collab-maint/ncurses.git;a=blob;f=debian/rules;hb=HEAD#l140
TERMINFO_FILES := \
	a/ansi c/cons25 c/cygwin d/dumb E/Eterm E/Eterm-color h/hurd l/linux \
	m/mach m/mach-bold m/mach-color p/pcansi r/rxvt r/rxvt-basic  \
	s/screen s/screen-bce s/screen-s s/screen-w s/sun \
	s/screen-256color s/screen-256color-bce v/vt100 v/vt102 \
	v/vt220 v/vt52 x/xterm x/xterm-xfree86 x/xterm-color x/xterm-r5 x/xterm-r6 \
	x/xterm-vt220 x/xterm-256color w/wsvt25 w/wsvt25m

TERMINFO_SOURCE := $(LOCAL_PATH)/lib/terminfo/
TERMINFO_TARGET := $(TARGET_OUT_ETC)/terminfo
$(TERMINFO_TARGET): $(ACP)
		@echo "copy terminfo to /etc/" 
		@mkdir -p $@
		@$(foreach TERMINFO_FILE,$(TERMINFO_FILES), \
			mkdir -p $@/$(dir $(TERMINFO_FILE)); \
			$(ACP) $(TERMINFO_SOURCE)/$(TERMINFO_FILE) $@/$(TERMINFO_FILE); \
		)
ALL_DEFAULT_INSTALLED_MODULES += $(TERMINFO_TARGET)
