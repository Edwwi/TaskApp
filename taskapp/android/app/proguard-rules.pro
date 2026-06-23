# Ignorar advertencias sobre clases faltantes (necesario para ML Kit)
-ignorewarnings
-dontwarn com.google.mlkit.vision.text.**

# Google ML Kit Text Recognition ProGuard rules
-keep class com.google.mlkit.vision.text.chinese.** { *; }
-keep class com.google.mlkit.vision.text.devanagari.** { *; }
-keep class com.google.mlkit.vision.text.japanese.** { *; }
-keep class com.google.mlkit.vision.text.korean.** { *; }

# General ML Kit rules
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }
