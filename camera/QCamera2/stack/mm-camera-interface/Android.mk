OLD_LOCAL_PATH := $(LOCAL_PATH)
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_CLANG_CFLAGS += \
        -Wno-error=memsize-comparison \
        -Wno-error=missing-field-initializers \
        -Wno-error=pointer-bool-conversion

MM_CAM_FILES := \
        src/mm_camera_interface.c \
        src/mm_camera.c \
        src/mm_camera_channel.c \
        src/mm_camera_stream.c \
        src/mm_camera_thread.c \
        src/mm_camera_sock.c \
        src/cam_intf.c

ifeq ($(strip $(TARGET_USES_ION)),true)
    LOCAL_CFLAGS += -DUSE_ION
endif

ifeq ($(call is-board-platform-in-list,msm8974 msm8916 msm8226 msm8610 msm8909),true)
    LOCAL_CFLAGS += -DVENUS_PRESENT
endif

LOCAL_CFLAGS += -D_ANDROID_
LOCAL_COPY_HEADERS_TO := mm-camera-interface
LOCAL_COPY_HEADERS += ../common/cam_intf.h
LOCAL_COPY_HEADERS += ../common/cam_types.h

LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/inc \
    $(LOCAL_PATH)/../common

LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/media
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_C_INCLUDES += hardware/qcom/media/mm-core/inc
ifeq ($(call is-platform-sdk-version-at-least,20),true)
LOCAL_C_INCLUDES += system/media/camera/include
endif

ifneq ($(call is-platform-sdk-version-at-least,17),true)
  LOCAL_CFLAGS += -include bionic/libc/kernel/common/linux/socket.h
  LOCAL_CFLAGS += -include bionic/libc/kernel/common/linux/un.h
endif

LOCAL_CFLAGS += -Wall -Wextra -Werror

LOCAL_SRC_FILES := $(MM_CAM_FILES)

LOCAL_MODULE           := libmmcamera_interface
LOCAL_32_BIT_ONLY := true
LOCAL_PRELINK_MODULE   := false
LOCAL_SHARED_LIBRARIES := libdl libcutils liblog
LOCAL_MODULE_TAGS := optional
LOCAL_VENDOR_MODULE := true

include $(BUILD_SHARED_LIBRARY)

LOCAL_PATH := $(OLD_LOCAL_PATH)
