# TensorFlow Lite rules
-keep class org.tensorflow.** { *; }
-keep class org.tensorflow.lite.** { *; }
-keepclasseswithmembers class * {
    @org.tensorflow.lite.annotations.UsedByReflection <fields>;
}
-keepclasseswithmembers class * {
    @org.tensorflow.lite.annotations.UsedByReflection <methods>;
}

# Keep GPU delegate classes
-keep class org.tensorflow.lite.gpu.** { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory { *; }
-keep class org.tensorflow.lite.gpu.GpuDelegateFactory$Options { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# General optimization rules
-dontwarn org.tensorflow.**
-dontwarn org.tensorflow.lite.** 