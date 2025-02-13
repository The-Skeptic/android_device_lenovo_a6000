LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

LOCAL_CLANG_CFLAGS += \
        -Wno-error=unused-private-field \
        -Wno-error=strlcpy-strlcat-size \
        -Wno-error=gnu-designator \
        -Wno-error=unused-variable \
        -Wno-error=format \
        -Wno-error=unused-parameter \
	-Wno-error=implicit-fallthrough

LOCAL_SRC_FILES := \
        QCamera2Factory.cpp \
        QCamera2Hal.cpp \
        QCamera2HWI.cpp \
        QCameraMem.cpp \
        ../util/QCameraQueue.cpp \
        ../util/QCameraCmdThread.cpp \
        QCameraStateMachine.cpp \
        QCameraChannel.cpp \
        QCameraStream.cpp \
        QCameraPostProc.cpp \
        QCamera2HWICallbacks.cpp \
        QCameraParameters.cpp \
        QCameraThermalAdapter.cpp \
        wrapper/QualcommCamera.cpp

LOCAL_CFLAGS = -Wall -Wextra -Werror
LOCAL_CFLAGS += -DDEFAULT_ZSL_MODE_ON

#use media extension
#ifeq ($(TARGET_USES_MEDIA_EXTENSIONS), true)
LOCAL_CFLAGS += -DUSE_MEDIA_EXTENSIONS
#endif

#Debug logs are enabled
#LOCAL_CFLAGS += -DDISABLE_DEBUG_LOG

#ifeq ($(TARGET_USE_VENDOR_CAMERA_EXT),true)
#LOCAL_CFLAGS += -DUSE_VENDOR_CAMERA_EXT
#endif

ifeq ($(TARGET_USES_AOSP),true)
LOCAL_CFLAGS += -DVANILLA_HAL
endif

ifneq ($(call is-platform-sdk-version-at-least,18),true)
LOCAL_CFLAGS += -DUSE_JB_MR1
endif

LOCAL_CFLAGS += -DDEFAULT_DENOISE_MODE_ON

LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/../stack/common \
        frameworks/native/include \
        frameworks/native/include/media/openmax \
        frameworks/native/libs/nativewindow/include/ \
        frameworks/native/include/media/hardware \
        hardware/qcom/display/libgralloc \
        hardware/qcom/display/libqdutils \
        hardware/qcom/media/libstagefrighthw \
        system/media/camera/include \
        $(LOCAL_PATH)/../../mm-image-codec/qexif \
        $(LOCAL_PATH)/../../mm-image-codec/qomx_core \
        $(LOCAL_PATH)/../util \
        $(LOCAL_PATH)/wrapper

ifeq ($(call is-platform-sdk-version-at-least,20),true)
LOCAL_C_INCLUDES += system/media/camera/include
else
LOCAL_CFLAGS += -DUSE_KK_CODE
endif

#ifeq ($(TARGET_USE_VENDOR_CAMERA_EXT),true)
#LOCAL_C_INCLUDES += hardware/qcom/display/libgralloc
#else
LOCAL_C_INCLUDES += hardware/qcom/display/libgralloc
#endif
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/media
ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_CFLAGS += -DTARGET_TS_MAKEUP
LOCAL_C_INCLUDES += $(LOCAL_PATH)/tsMakeuplib/include
endif
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_SHARED_LIBRARIES := libcamera_client liblog libhardware libutils libcutils libdl liblog
LOCAL_SHARED_LIBRARIES += libmmcamera_interface libmmjpeg_interface libqdMetaData
LOCAL_SHARED_LIBRARIES += libhidltransport libsensor android.hidl.token@1.0-utils android.hardware.graphics.bufferqueue@1.0
LOCAL_STATIC_LIBRARIES := libarect
LOCAL_HEADER_LIBRARIES := libnativebase_headers
ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_SHARED_LIBRARIES += libts_face_beautify_hal libts_detected_face_hal
endif
LOCAL_MODULE_RELATIVE_PATH    := hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_32_BIT_ONLY := true
LOCAL_VENDOR_MODULE := true
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

ifeq ($(TARGET_USES_AOSP),false)
include $(LOCAL_PATH)/test/Android.mk
endif
