# 🏗️ Pure3XEngine - Arquitetura Modular v0.2.4+

## 📋 Visão Geral da Arquitetura

Pure3XEngine segue uma **arquitetura em camadas modular e desacoplada**, permitindo desenvolvimento paralelo e manutenção clara.

```
┌─────────────────────────────────────────────────────────────┐
│                   JAVA/KOTLIN LAYER                         │
│  (MainActivity, SplashActivity, UI Interactions)            │
└─────────────────────────────────────────────────────────────┘
                           ↕ JNI Bridge
┌─────────────────────────────────────────────────────────────┐
│              ANDROID RUNTIME (C++ / NDK)                    │
│  - ActivityManager    - WindowManager                       │
│  - InputManager       - DisplayManager                      │
│  - AudioManager       - NetworkManager                      │
│  - FileSystemManager                                        │
└─────────────────────────────────────────────────────────────┘
                   ↕ Engine Integration Point
┌─────────────────────────────────────────────────────────────┐
│            CORE ENGINE (C++20 / Emulation Layer)            │
│  ┌──────────────────┐  ┌──────────────────┐                │
│  │  Cell Engine     │  │  Memory Manager  │                │
│  │  (CPU/SPU)       │  │  (PS3 RAM Mapping)              │
│  └──────────────────┘  └──────────────────┘                │
│  ┌──────────────────��  ┌──────────────────┐                │
│  │  Graphics Engine │  │  IO Manager      │                │
│  │  (Vulkan)        │  │  (Disc/Network)  │                │
│  └──────────────────┘  └──────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

---

## 📁 Estrutura de Diretórios (v0.2.4+)

```
Pure3XEngine/
│
├── 📂 app/                              # Android App Module
│   ├── src/main/java/com/pure3x/       # Java/Kotlin UI Layer
│   │   ├── MainActivity.java            # Entry point
│   │   ├── SplashActivity.java          # Splash screen
│   │   ├── EngineActivity.java          # Engine main screen
│   │   └── SettingsActivity.java        # Settings
│   ├── src/main/res/                    # Resources (layouts, strings)
│   └── build.gradle
│
├── 📂 AndroidRuntime/                   # Android Runtime Integration (C++)
│   ├── include/
│   │   ├── AndroidRuntime.h             # Main runtime class
│   │   ├── ActivityManager.h
│   │   ├── WindowManager.h
│   │   ├── InputManager.h
│   │   ├── DisplayManager.h
│   │   ├── AudioManager.h
│   │   ├── NetworkManager.h
│   │   └── FileSystemManager.h
│   │
│   └── src/
│       ├── AndroidRuntime.cpp           # Initialization & lifecycle
│       ├── ActivityManager.cpp
│       ├── WindowManager.cpp
│       ├── InputManager.cpp
│       ├── DisplayManager.cpp
│       ├── AudioManager.cpp
│       ├── NetworkManager.cpp
│       └── FileSystemManager.cpp
│
├── 📂 src/native/                       # JNI Bridge Layer
│   ├── include/
│   │   ├── JNIBridge.h                  # Java↔C++ interface
│   │   ├── JNICallbacks.h               # Async callbacks
│   │   └── JNIHelpers.h                 # Utility functions
│   │
│   └── cpp/
│       ├── JNIBridge.cpp                # Implementation
│       ├── JNICallbacks.cpp
│       └── JNIHelpers.cpp
│
├── 📂 src/engine/                       # Core Emulation Engine
│   │
│   ├── 📂 core/
│   │   ├── include/
│   │   │   ├── EngineCore.h             # Main engine class
│   │   │   ├── Scheduler.h              # Thread scheduler
│   │   │   └── ModuleManager.h          # Module lifecycle
│   │   │
│   │   └── src/
│   │       ├── EngineCore.cpp
│   │       ├── Scheduler.cpp
│   │       └── ModuleManager.cpp
│   │
│   ├── 📂 cpu/                          # Cell Processor Emulation
│   │   ├── include/
│   │   │   ├── CellEngine.h             # PPE + SPU emulation
│   │   │   ├── PPU.h                    # PowerPC Processing Unit
│   │   │   ├── SPU.h                    # Synergistic Processing Unit
│   │   │   └── Registers.h              # CPU registers
│   │   │
│   │   └── src/
│   │       ├── CellEngine.cpp
│   │       ├── PPU.cpp
│   │       ├── SPU.cpp
│   │       └── Registers.cpp
│   │
│   ├── 📂 memory/                       # Memory Management
│   │   ├── include/
│   │   │   ├── MemoryManager.h          # PS3 RAM mapping
│   │   │   ├── MemoryMap.h              # Memory layout
│   │   │   └── MemoryCache.h            # Cache management
│   │   │
│   │   └── src/
│   │       ├── MemoryManager.cpp
│   │       ├── MemoryMap.cpp
│   │       └── MemoryCache.cpp
│   │
│   ├── 📂 graphics/                     # Graphics Rendering
│   │   ├── include/
│   │   │   ├── GraphicsEngine.h         # Main graphics
│   │   │   ├── VulkanRenderer.h         # Vulkan backend
│   │   │   ├── ShaderManager.h          # Shader compilation
│   │   │   ├── TextureManager.h         # Texture management
│   │   │   ├── SwapchainManager.h       # Swapchain handling
│   │   │   └── DrawCommandBuffer.h      # Draw commands
│   │   │
│   │   └── src/
│   │       ├── GraphicsEngine.cpp
│   │       ├── VulkanRenderer.cpp
│   │       ├── ShaderManager.cpp
│   │       ├── TextureManager.cpp
│   │       ├── SwapchainManager.cpp
│   │       └── DrawCommandBuffer.cpp
│   │
│   ├── 📂 audio/                        # Audio Subsystem
│   │   ├── include/
│   │   │   ├── AudioEngine.h            # Audio processing
│   │   │   ├── AudioBuffer.h            # Audio buffers
│   │   │   └── AudioMixer.h             # Multi-channel mixing
│   │   │
│   │   └── src/
│   │       ├── AudioEngine.cpp
│   │       ├── AudioBuffer.cpp
│   │       └── AudioMixer.cpp
│   │
│   ├── 📂 io/                           # Input/Output Management
│   │   ├── include/
│   │   │   ├── IOManager.h              # I/O abstraction
│   │   │   ├── DiscManager.h            # Disc/storage access
│   │   │   ├── NetworkIO.h              # Network I/O
│   │   │   └── ControllerInput.h        # Controller input mapping
│   │   │
│   │   └── src/
│   │       ├── IOManager.cpp
│   │       ├── DiscManager.cpp
│   │       ├── NetworkIO.cpp
│   │       └── ControllerInput.cpp
│   │
│   └── 📂 firmware/                     # PS3 Firmware/OS
│       ├── include/
│       │   ├── FirmwareManager.h        # Firmware loading
│       │   ├── BootSystem.h             # Boot sequence
│       │   └── KernelServices.h         # Kernel abstractions
│       │
│       └── src/
│           ├── FirmwareManager.cpp
│           ├── BootSystem.cpp
│           └── KernelServices.cpp
│
├── 📂 src/utils/                        # Utilities
│   ├── include/
│   │   ├── Logger.h                     # Logging system
│   │   ├── Config.h                     # Configuration manager
│   │   ├── Timer.h                      # Performance timing
│   │   └── Converters.h                 # Data conversion utilities
│   │
│   └── src/
│       ├── Logger.cpp
│       ├── Config.cpp
│       ├── Timer.cpp
│       └── Converters.cpp
│
├── 📂 docs/                             # Documentation
│   ├── ARCHITECTURE.md                  # This file
│   ├── BUILD_GUIDE.md                   # Build instructions
│   ├── CODING_STANDARDS.md              # Code style
│   ├── MODULE_GUIDE.md                  # How to add modules
│   └── API_REFERENCE.md                 # API documentation
│
├── 📂 tests/                            # Unit Tests
│   ├── cpu/                             # CPU tests
│   ├── memory/                          # Memory tests
│   ├── graphics/                        # Graphics tests
│   └── integration/                     # Integration tests
│
├── 📂 assets/                           # Game assets
│   ├── images/                          # UI images, logos
│   └── shaders/                         # Vulkan shaders
│
├── CMakeLists.txt                       # C++ build system
├── build.gradle                         # Android build
├── settings.gradle                      # Gradle settings
└── README.md                            # Project overview
```

---

## 🔄 Fluxo de Execução (Data Flow)

### 1️⃣ **Inicialização (Startup)**

```
Java: MainActivity.onCreate()
    ↓
Java: Load native library (liblhuis.pure3x.so)
    ↓
JNI: nativeInitialize()
    ↓
C++: JNIBridge::initialize()
    ↓
C++: AndroidRuntime::initialize()
    ├── ActivityManager::initialize()
    ├── WindowManager::initialize()
    ├── DisplayManager::initialize()
    ├── AudioManager::initialize()
    ├── InputManager::initialize()
    ├── NetworkManager::initialize()
    └── FileSystemManager::initialize()
    ↓
C++: EngineCore::initialize()
    ├── MemoryManager::initialize()
    ├── CellEngine::initialize()
    ├── GraphicsEngine::initialize()
    └── ModuleManager::initialize()
    ↓
Java: Display splash screen → Ready for user input
```

### 2️⃣ **Main Loop (Runtime)**

```
Android UI Thread:
    ├── SurfaceFlinger (Display)
    ├── InputManager (Touch/Keys)
    └── JNI Callbacks

Engine Thread (Parallel):
    ├── Scheduler::update()
    ├── CellEngine::execute()
    ├── MemoryManager::update()
    ├── GraphicsEngine::render()
    ├── AudioEngine::process()
    └── IOManager::handleEvents()
```

### 3️⃣ **Shutdown (Cleanup)**

```
Java: MainActivity.onDestroy()
    ↓
JNI: nativeShutdown()
    ↓
C++: EngineCore::shutdown()
    ├── GraphicsEngine::shutdown()
    ├── AudioEngine::shutdown()
    ├── CellEngine::shutdown()
    └── MemoryManager::shutdown()
    ↓
C++: AndroidRuntime::shutdown()
    ├── FileSystemManager::shutdown()
    ├── NetworkManager::shutdown()
    ├── InputManager::shutdown()
    ├── DisplayManager::shutdown()
    ├── WindowManager::shutdown()
    └── ActivityManager::shutdown()
    ↓
Java: Clean resources
```

---

## 🎯 Responsabilidades por Camada

### **Java/Kotlin Layer (UI)**
- ✅ User interface management
- ✅ Activity lifecycle handling
- ✅ Permission requests
- ✅ Android system callbacks
- ❌ NOT: Engine logic, emulation

### **JNI Bridge Layer**
- ✅ Java ↔ C++ communication
- ✅ Async callback marshalling
- ✅ Exception handling
- ✅ Type conversions
- ❌ NOT: Business logic

### **Android Runtime Layer**
- ✅ Android system services integration
- ✅ Surface/Display management
- ✅ Audio output handling
- ✅ Input event routing
- ✅ File system abstraction
- ✅ Network socket management
- ❌ NOT: Emulation core

### **Core Engine Layer**
- ✅ PS3 emulation logic
- ✅ CPU/GPU simulation
- ✅ Memory mapping
- ✅ Firmware execution
- ✅ Game logic coordination
- ❌ NOT: Android platform details

### **Utils Layer**
- ✅ Cross-cutting concerns
- ✅ Logging, configuration
- ✅ Performance timing
- ✅ Data conversion
- ✅ Helper functions

---

## 📦 Module Dependencies

```
MainActivity
    ↓
[JNIBridge] ← Central integration point
    ↓
[AndroidRuntime]
    ├── [ActivityManager]
    ├── [WindowManager] → [DisplayManager]
    ├── [InputManager]
    ├── [AudioManager]
    ├── [NetworkManager]
    └── [FileSystemManager]
    ↓
[EngineCore]
    ├── [Scheduler]
    ├── [MemoryManager]
    ├── [CellEngine]
    │   ├── [PPU]
    │   ├── [SPU]
    │   └── [Registers]
    ├── [GraphicsEngine] → [VulkanRenderer]
    ├── [AudioEngine]
    └── [IOManager]
```

---

## 🚀 v0.2.4 Roadmap - Where Things Go

| Component | Priority | Location | Status |
|-----------|----------|----------|--------|
| JNIBridge Enhancement | 🔴 HIGH | `src/native/` | TODO |
| AndroidRuntime Stabilization | 🔴 HIGH | `AndroidRuntime/` | In Progress |
| Engine Integration Point | 🔴 HIGH | `src/engine/core/` | TODO |
| MainActivity Improvements | 🟡 MEDIUM | `app/src/main/` | TODO |
| Error Handling System | 🟡 MEDIUM | `src/utils/` | TODO |
| Logging Enhancement | 🟡 MEDIUM | `src/utils/Logger.h` | TODO |

---

## 💡 Best Practices

### ✅ DO:
- Keep layers decoupled (no AndroidRuntime in EngineCore)
- Use dependency injection for testability
- Document public APIs with clear comments
- One responsibility per class
- Use const correctness in C++

### ❌ DON'T:
- Mix UI logic with engine logic
- Create circular dependencies
- Use global state (use singletons sparingly)
- Hardcode platform-specific code in core
- Ignore error codes

---

## 🔗 Related Documentation

- 📖 [BUILD_GUIDE.md](./docs/BUILD_GUIDE.md) - How to build
- 📖 [CODING_STANDARDS.md](./docs/CODING_STANDARDS.md) - Code style
- 📖 [MODULE_GUIDE.md](./docs/MODULE_GUIDE.md) - Adding new modules
- 📖 [API_REFERENCE.md](./docs/API_REFERENCE.md) - API documentation

---

## 👥 Team Contribution

When a team member joins:

1. **Read this architecture first** ✅
2. **Choose a module** from the roadmap
3. **Follow the directory structure** exactly
4. **Add header files first** (interface design)
5. **Implement in corresponding .cpp**
6. **Add unit tests** in `tests/`
7. **Document public APIs**
8. **Submit PR for review**

---

**Last Updated:** v0.2.3 Alpha  
**Maintainer:** Lhuis (Pure3XDev)  
**Status:** Active Development

