//
// Created by 15102 on 3/9/2020.
//
#include <jni.h>
//#include "modelAssimp.h"
#include <myJNIHelper.h>
#include <modelAssimp.h>

#ifdef __cplusplus
extern "C" {
#endif

extern ModelAssimp *gAssimpObject;

JNIEXPORT void JNICALL
Java_com_example_hellojni_GestureClass_DoubleTapNative(JNIEnv *env, jobject instance) {

    if (gAssimpObject == NULL) {
        return;
    }
    gAssimpObject->DoubleTapAction();

}

/**
 * one finger drag - compute normalized current position and normalized displacement
 * from previous position
 */
JNIEXPORT void JNICALL
Java_com_example_hellojni_GestureClass_ScrollNative(JNIEnv *env, jobject instance,
                                                    jfloat distanceX, jfloat distanceY,
                                                    jfloat positionX, jfloat positionY) {

    if (gAssimpObject == NULL) {
        return;
    }
    // normalize movements on the screen wrt GL surface dimensions
    // invert dY to be consistent with GLES conventions
    float dX = (float) distanceX / gAssimpObject->GetScreenWidth();
    float dY = -(float) distanceY / gAssimpObject->GetScreenHeight();
    float posX = 2*positionX/ gAssimpObject->GetScreenWidth() - 1.;
    float posY = -2*positionY / gAssimpObject->GetScreenHeight() + 1.;
    posX = fmax(-1., fmin(1., posX));
    posY = fmax(-1., fmin(1., posY));
    gAssimpObject->ScrollAction(dX, dY, posX, posY);

}

/**
 * Pinch-and-zoom gesture: pass the change in scale to class' method
 */
JNIEXPORT void JNICALL
Java_com_example_hellojni_GestureClass_ScaleNative(JNIEnv *env, jobject instance,
                                                   jfloat scaleFactor) {

    if (gAssimpObject == NULL) {
        return;
    }
    gAssimpObject->ScaleAction((float) scaleFactor);

}


/**
 * Two-finger drag - normalize the distance moved wrt GLES surface size
 */
JNIEXPORT void JNICALL
Java_com_example_hellojni_GestureClass_MoveNative(JNIEnv *env, jobject instance,
                                                  jfloat distanceX, jfloat distanceY) {

    if (gAssimpObject == NULL) {
        return;
    }

    // normalize movements on the screen wrt GL surface dimensions
    // invert dY to be consistent with GLES conventions
    float dX = distanceX / gAssimpObject->GetScreenWidth();
    float dY = -distanceY / gAssimpObject->GetScreenHeight();
    gAssimpObject->MoveAction(dX, dY);

}

JNIEXPORT void JNICALL
Java_com_example_hellojni_GestureClass_turnOffLight(JNIEnv *env, jobject thiz) {
    gAssimpObject->TurnOffLight();
    // TODO: implement turnOffLight()
}

JNIEXPORT void JNICALL
Java_com_example_hellojni_GestureClass_turnOnLight(JNIEnv *env, jobject thiz) {
    gAssimpObject->TurnOnLight();
    // TODO: implement turnOnLight()
}
#ifdef __cplusplus
}
#endif

