//
// Created by 15102 on 3/9/2020.
//
#include <jni.h>
//#include "modelAssimp.h"
#include <modelAssimp.h>


#ifdef __cplusplus
extern "C" {
#endif

extern ModelAssimp *gAssimpObject;

JNIEXPORT void JNICALL
Java_com_example_hellojni_MyGLRenderer_DrawFrameNative(JNIEnv *env,
                                                       jobject instance) {

    if (gAssimpObject == NULL) {
        return;
    }
    gAssimpObject->Render();

}

JNIEXPORT void JNICALL
Java_com_example_hellojni_MyGLRenderer_SurfaceCreatedNative(JNIEnv *env,
                                                            jobject instance) {

    if (gAssimpObject == NULL) {
        return;
    }
    gAssimpObject->PerformGLInits();

}

JNIEXPORT void JNICALL
Java_com_example_hellojni_MyGLRenderer_SurfaceChangedNative(JNIEnv *env,
                                                            jobject instance,
                                                            jint width,
                                                            jint height) {

    if (gAssimpObject == NULL) {
        return;
    }
    gAssimpObject->SetViewport(width, height);

}


#ifdef __cplusplus
}
#endif


