plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.frontend_app"
    compileSdk = 34  // Cambia de flutter.compileSdkVersion a 34 explícitamente
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.frontend_app"
        minSdk = flutter.minSdkVersion  // Cambia de flutter.minSdkVersion a 21 explícitamente
        targetSdk = 34  // Cambia de flutter.targetSdkVersion a 34 explícitamente
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // Para release, considera agregar:
            // minifyEnabled true
            // proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}

flutter {
    source = "../.."
}
