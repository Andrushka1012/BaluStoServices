# balu_sto

Flutter project for Balu STO services.

## Setup

**Flutter version**: 2.10.3 (managed via FVM)

**Java version**: Java 11 required for Android builds

## Build Commands

```bash
# Get dependencies
fvm flutter pub get

# Build debug APK
export JAVA_HOME=$(/usr/libexec/java_home -v 11) && fvm flutter build apk --debug

# Run on emulator
export JAVA_HOME=$(/usr/libexec/java_home -v 11) && fvm flutter run

export JAVA_HOME=$(/usr/libexec/java_home -v 11) && fvm flutter build apk --release
```

## Notes

- Always set `JAVA_HOME` to Java 11 before running Android builds
- FVM is configured to use Flutter 2.10.3 (see `.fvmrc`)
