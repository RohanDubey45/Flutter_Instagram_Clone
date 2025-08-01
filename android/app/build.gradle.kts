// plugins {
//     id("com.android.application")
//     id("kotlin-android")
//     // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//     id("dev.flutter.flutter-gradle-plugin")
//     id("com.google.gms.google-services") // ✅ Google Services Plugin
// }

// android {
//     namespace = "com.example.instagram_flutter"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = "27.0.12077973" 

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_11
//         targetCompatibility = JavaVersion.VERSION_11
//     }

//     kotlinOptions {
//         jvmTarget = JavaVersion.VERSION_11.toString()
//     }

//     defaultConfig {
//         applicationId = "com.example.instagram_flutter"
//         minSdk = 23
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//     }

//     buildTypes {
//         release {
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }
// }

// flutter {
//     source = "../.."
// }

// dependencies {
//     // ✅ Firebase BoM
//     implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

//     // ✅ Add Firebase services here (example: Analytics, Auth, etc.)
//     implementation("com.google.firebase:firebase-analytics-ktx")
//     implementation("com.google.firebase:firebase-auth-ktx")

//     // Other dependencies can go here
// }


// buildscript {
//     ext.kotlin_version = '2.1.0'  // Add the Kotlin version here

//     repositories {
//         google()
//         mavenCentral()
//     }

//     dependencies {
//         classpath "com.android.tools.build:gradle:7.4.0"  // Ensure the Android Gradle Plugin is up-to-date
//         classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"  // Use the Kotlin version defined above
//         classpath "com.google.gms:google-services:4.3.15"  // Ensure the Google Services plugin is up-to-date
//     }
// }

// plugins {
//     id("com.android.application")
//     id("kotlin-android")
//     id("dev.flutter.flutter-gradle-plugin")
//     id("com.google.gms.google-services") // ✅ Google Services Plugin
// }

// android {
//     namespace = "com.example.instagram_flutter"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = "27.0.12077973" 

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_11
//         targetCompatibility = JavaVersion.VERSION_11
//     }

//     kotlinOptions {
//         jvmTarget = JavaVersion.VERSION_11.toString()
//     }

//     defaultConfig {
//         applicationId = "com.example.instagram_flutter"
//         minSdk = 23
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//     }

//     buildTypes {
//         release {
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }
// }

// flutter {
//     source = "../.."
// }

// dependencies {
//     // ✅ Firebase BoM
//     implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

//     // ✅ Add Firebase services here (example: Analytics, Auth, etc.)
//     implementation("com.google.firebase:firebase-analytics-ktx")
//     implementation("com.google.firebase:firebase-auth-ktx")

//     // Other dependencies can go here
// }


// plugins {
//     id("com.android.application")
//     id("kotlin-android")
//     id("dev.flutter.flutter-gradle-plugin")
//     id("com.google.gms.google-services")
// }

// android {
//     namespace = "com.example.instagram_flutter"
//     compileSdk = flutter.compileSdkVersion
//     ndkVersion = "27.0.12077973"

//     compileOptions {
//         sourceCompatibility = JavaVersion.VERSION_11
//         targetCompatibility = JavaVersion.VERSION_11
//     }

//     kotlinOptions {
//         jvmTarget = JavaVersion.VERSION_11.toString()
//     }

//     defaultConfig {
//         applicationId = "com.example.instagram_flutter"
//         minSdk = 23
//         targetSdk = flutter.targetSdkVersion
//         versionCode = flutter.versionCode
//         versionName = flutter.versionName
//     }

//     buildTypes {
//         release {
//             signingConfig = signingConfigs.getByName("debug")
//         }
//     }
// }

// flutter {
//     source = "../.."
// }

// dependencies {
//     // ✅ Firebase BoM
//     implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

//     // ✅ Add Firebase services here (example: Analytics, Auth, etc.)
//     implementation("com.google.firebase:firebase-analytics-ktx")
//     implementation("com.google.firebase:firebase-auth-ktx")

//     // Other dependencies can go here
// }

// buildscript {
//     repositories {
//         google()
//         mavenCentral()
//     }
//     dependencies {
//         // Use the latest Kotlin version compatible with your project
//         classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:2.1.0")  // Kotlin Gradle Plugin
//         classpath("com.android.tools.build:gradle:7.4.0")
//         classpath("com.google.gms:google-services:4.3.15")
//     }
// }

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // ✅ updated from kotlin-android
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.instagram_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.instagram_flutter"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // ✅ Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

    // ✅ Firebase services
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-auth-ktx")

    // Add other dependencies here as needed
}
