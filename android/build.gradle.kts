// Top-level build.gradle.kts

// plugins {
//     // Other plugins...

//     // Firebase Google Services plugin (applied in subprojects)
//     id("com.google.gms.google-services") version "4.4.2" apply false
// }

// allprojects {
//     repositories {
//         google()
//         mavenCentral()
//     }
// }

// // Optional: change the root build directory
// val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
// rootProject.layout.buildDirectory.value(newBuildDir)

// subprojects {
//     // Redirect each subproject's build directory
//     val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
//     project.layout.buildDirectory.value(newSubprojectBuildDir)

//     // Apply Google Services plugin only to Android app/module
//     if (project.name == "app") {
//         project.plugins.apply("com.google.gms.google-services")
//     }

//     // Ensure proper evaluation order
//     project.evaluationDependsOn(":app")
// }

// // Clean task
// tasks.register<Delete>("clean") {
//     delete(rootProject.layout.buildDirectory)
// }


// Top-level build.gradle.kts

plugins {
    // ✅ Latest Kotlin plugin
    id("org.jetbrains.kotlin.android") version "2.1.20" apply false

    // ✅ Firebase Google Services plugin
    id("com.google.gms.google-services") version "4.4.2" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Optional: Change the root build directory
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    // ✅ Redirect each subproject's build directory
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // ✅ Apply Google Services plugin only to app module
    if (project.name == "app") {
        project.plugins.apply("com.google.gms.google-services")
    }

    // ✅ Ensure proper evaluation order
    project.evaluationDependsOn(":app")
}

// ✅ Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
