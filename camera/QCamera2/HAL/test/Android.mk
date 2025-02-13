LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= \
    qcamera_test.cpp \

LOCAL_SHARED_LIBRARIES:= \
    libdl \
    libui \
    libutils \
    libcutils \
    libbinder \
    libmedia \
    libui \
    libgui \
    libcamera_client \
    libskia \
    libstagefright \
    libstagefright_foundation \
		liblog

ifneq ($(call is-platform-sdk-version-at-least,18),true)

LOCAL_SHARED_LIBRARIES += \
    libmedia_native \

LOCAL_CFLAGS += -DUSE_JB_MR1

endif

ifneq ($(call is-platform-sdk-version-at-least,20),true)
LOCAL_CFLAGS += -DUSE_KK_CODE
endif

LOCAL_C_INCLUDES += \
    frameworks/base/include/ui \
    frameworks/base/include/surfaceflinger \
    frameworks/base/include/camera \
    frameworks/base/include/media \
    external/skia/include/core \
    external/skia/include/images \
    hardware/qcom/display/libgralloc \
    frameworks/av/include/media/stagefright \
    frameworks/native/include/media/openmax \

LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_MODULE:= camera_test
LOCAL_32_BIT_ONLY := true
LOCAL_MODULE_TAGS:= tests
LOCAL_VENDOR_MODULE := true

LOCAL_CFLAGS += -Wall -Wextra -Werror -Wno-unused-parameter
LOCAL_CFLAGS += -O0

include $(BUILD_EXECUTABLE)

