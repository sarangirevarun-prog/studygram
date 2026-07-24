allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
gradle.beforeProject {
    afterEvaluate {
        plugins.withId("com.android.application") {
            configure<com.android.build.api.dsl.ApplicationExtension> {
                compileSdk = 36
                println("CONFIG_OVERRIDE: set compileSdk = 36 on application project ${project.name}")
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
                }
            }
        }
        plugins.withId("com.android.library") {
            configure<com.android.build.api.dsl.LibraryExtension> {
                if (project.name == "url_launcher_android") {
                    compileSdk = 36
                    println("CONFIG_OVERRIDE: set compileSdk = 36 on library project ${project.name}")
                } else {
                    compileSdk = 34
                    println("CONFIG_OVERRIDE: set compileSdk = 34 on library project ${project.name}")
                }
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
            tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
                compilerOptions {
                    jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
