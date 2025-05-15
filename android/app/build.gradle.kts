import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle Plugin harus diterapkan setelah plugin Android dan Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    
}

dependencies {
  // Import the Firebase BoM
  implementation(platform("com.google.firebase:firebase-bom:33.12.0"))


  // TODO: Add the dependencies for Firebase products you want to use
  // When using the BoM, don't specify versions in Firebase dependencies
  implementation("com.google.firebase:firebase-analytics")


  // Add the dependencies for any other desired Firebase products
  // https://firebase.google.com/docs/android/setup#available-libraries
  
  //For Local Notifacation SetUP
  coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
  implementation("androidx.window:window:1.0.0")
  implementation("androidx.window:window-java:1.0.0")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.example.pa2_kelompok07"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        
        // Required for Local Notification SetUP
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        // Sets Java compatibility to Java 11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.pa2_kelompok07"
        // Tingkatkan minSdk menjadi 23 agar sesuai dengan persyaratan Firebase Authentication.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = "SEESUAIIINNN_SAMA_CASES_KALIAN" // Directly input the value
            keyPassword = "SEESUAIIINNN_SAMA_CASES_KALIAN" // Directly input the value
            storeFile = file("SEESUAIIINNN_SAMA_CASES_KALIAN") // Directly input the value
            storePassword = "SEESUAIIINNN_SAMA_CASES_KALIAN" // Directly input the value
        }
    }
    buildTypes {
        getByName("debug") {
            // TODO: Tambahkan konfigurasi signing untuk build debug.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
