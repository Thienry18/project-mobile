import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Ensure legacy plugins that don't declare a namespace still build with AGP 8+
subprojects {
    // When an Android library module is present, set a namespace for known plugins
    plugins.withId("com.android.library") {
        extensions.findByType(LibraryExtension::class.java)?.let { libExt ->
            if (project.name.contains("flutter_local_notifications")) {
                libExt.namespace = "com.dexterous.flutterlocalnotifications"
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
