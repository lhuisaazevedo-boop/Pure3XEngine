# Pure3XEngine Input Architecture Proposal

**Status:** Architectural Planning (Not Yet Implemented)  
**Version:** 0.1  
**Last Updated:** 2026-09-27

---

## Table of Contents

1. [Current State](#current-state)
2. [Problem Statement](#problem-statement)
3. [Architectural Goals](#architectural-goals)
4. [Target Architecture](#target-architecture)
5. [Input State Representation](#input-state-representation)
6. [Backend Lifecycle](#backend-lifecycle)
7. [Error Handling Strategy](#error-handling-strategy)
8. [Hot-Plug Support](#hot-plug-support)
9. [Virtual Controls as First-Class Backend](#virtual-controls-as-first-class-backend)
10. [Threading Model](#threading-model)
11. [Implementation Phases](#implementation-phases)
12. [Migration Path](#migration-path)

---

## Current State

### What Exists Today

- **CoreEmulator:** Modular PS3 emulation core with stubs for `BootManager`, `FirmwareManager`, `CellEngine`, `RSXManager`, `GPUManager`, and `DiscManager`. These are not integrated into a functional boot-to-game pipeline.

- **Cubo3D:** Android rendering engine using OpenGL ES 3 or Vulkan. Renders test frames via `AndroidBridge.cpp` with EGL/surface management.

- **viewer:** Desktop X11-based viewer with a minimal `Input.cpp` stub. Input processing is done directly via X11 events (`KeyPress`, `DestroyNotify`); not through a unified input layer.

### What Does NOT Exist

- **No `InputManager` or `ControllerManager`:** The documented input roadmap (`docs/Input_System_Roadmap.md`) describes an architecture with `InputManager`, `DualShock3`, `InputState`, and `ButtonMap`, but these are not implemented in the codebase. The git history shows these were removed at some point (see `status-p3xe.txt`).

- **No Bluetooth/USB/JNI backend for input:** No Android permissions for Bluetooth or USB, no use of `BluetoothAdapter`, `UsbManager`, or `InputDevice` classes, no JNI methods to handle controller discovery or input events.

- **No virtual/touch controller:** The Android UI has diagnostic buttons (Renderizar frame, OpenGL ES, Vulkan) but no overlay gamepad, no touch-to-input mapping, no virtual stick/button state.

- **No input abstraction in CoreEmulator:** `CoreEmulator` does not expose an input interface or consume controller state. The core boots and runs independently of any input device.

- **No error handling for missing devices:** Since no device detection exists, there is no code path for "Bluetooth unavailable," "USB device not found," or "controller disconnected."

### Current Boot Path

```
Android App (Cubo3D)
  → MainActivity.surfaceCreated()
  → nativeSurfaceCreated() [JNI]
  → ANativeWindow + EGL initialization
  → OpenGL ES setup
  → Test frame render
  → eglSwapBuffers()
  (No input device initialization; no blocking on hardware)
```

**Key observation:** Boot does not currently depend on physical input. This is correct and should remain true.

---

## Problem Statement

### Lessons from RPCSX and Other Emulators

Some PS3 emulators block game boot or slow down game loading when a Bluetooth controller is missing or fails to initialize. This is a poor user experience:

- Player expects to launch a game; if they don't have a physical controller plugged in, the emulator should still boot.
- If a controller is present but Bluetooth/USB fails to initialize, the emulator should fall back to virtual/touch controls and continue.
- If a controller disconnects mid-game, the emulator should not crash or terminate the game.

### P3XE Must Avoid This

When P3XE implements input support, it must do so in a way that:

1. Game boot is **never** delayed or blocked by controller discovery.
2. Missing or non-functional controllers **never** prevent the game from running.
3. Controller state is **optional** and gracefully degraded.
4. Hot-plugging is transparent and does not restart the emulator or game.

---

## Architectural Goals

### Non-Blocking Boot

- Game boot path: Firmware → Cell → RSX → Cubo3D Renderer
- Input system initialization: separate, asynchronous thread
- These two paths must **not** depend on each other
- Core must start with a safe default input state (null controller, or ready for touch)

### Modular Input Backends

- Support multiple input methods (Bluetooth, USB, touch) without coupling them to the core
- Each backend is a separate implementation behind a common interface
- Backends can be swapped or disabled independently
- CoreEmulator never calls Android-specific code; it consumes a normalized input snapshot

### Graceful Degradation

- If Bluetooth unavailable → use USB or touch
- If USB unavailable → use touch
- If no controller connected at all → use touch or on-screen controls
- If a controller disconnects → smoothly switch to the next available backend

### Optional Hardware

- A game must be playable with only touch controls
- A game must not require a specific controller type
- Emulator must detect available backends at runtime and choose intelligently

### Hot-Plug Support

- A controller can be connected or disconnected while a game is running
- The emulator detects the change without restarting
- Input state updates seamlessly to reflect the new controller

### Clean Abstraction

- CoreEmulator knows nothing about Android JNI, `BluetoothAdapter`, or OS-level APIs
- All platform-specific code lives in a platform layer
- Core consumes a snapshot of normalized input state once per frame
- Synchronization is frame-based, not event-based, to avoid race conditions

---

## Target Architecture

### High-Level Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                   P3XE Game Boot (Main Thread)              │
│                                                             │
│  Firmware → Cell → RSX → Cubo3D Renderer                   │
│     ↓                                                        │
│  Never blocked by input hardware                            │
└─────────────────────────────────────────────────────────────┘
        ↑
        │ (Once per frame: InputSnapshot poll)
        │
┌─────────────────────────────────────────────────────────────┐
│        ControllerManager (Async Thread / Worker)            │
│                                                             │
│  Detects & manages input backends                           │
│  - AndroidBluetoothBackend                                  │
│  - AndroidUsbBackend                                        │
│  - VirtualTouchBackend                                      │
│  - NullInputBackend                                         │
│                                                             │
│  Each backend:                                               │
│  ├── Handles platform-specific setup                        │
│  ├── Manages connection lifecycle                           │
│  └── Returns InputState to ControllerManager                │
│                                                             │
│  ControllerManager → InputSnapshot (thread-safe)            │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│              Android/JNI Layer (Java/Kotlin)                │
│                                                             │
│  Handles:                                                    │
│  ├── Bluetooth permissions & scanning                       │
│  ├── USB device enumeration                                 │
│  ├── Touch event dispatch                                   │
│  ├── Controller pairing/unpairing                           │
│                                                             │
│  Communicates via JNI to ControllerManager                  │
└─────────────────────────────────────────────────────────────┘
```

### Component Descriptions

#### CoreEmulator (No Changes to Input Logic)

- Continues to define the game logic, physics, rendering commands
- Receives an `InputSnapshot` once per frame from the render loop
- Never directly accesses Android or platform APIs
- Never blocks waiting for input

#### Cubo3D Renderer

- Continues to manage Vulkan/OpenGL ES rendering
- Calls `ControllerManager::getInputSnapshot()` or polls via a callback once per frame
- Passes input to CoreEmulator game logic
- Never directly manages controller devices

#### ControllerManager

**Responsibility:** Central orchestrator of all input backends

**Key Methods (proposed):**
```cpp
class ControllerManager {
public:
    // Initialize discovery, not blocking; may return immediately
    bool initialize();
    
    // Return current input state snapshot (thread-safe)
    InputSnapshot getSnapshot();
    
    // Explicit registration of a new backend (for testing or dynamic backends)
    void registerBackend(std::shared_ptr<InputBackend> backend);
    
    // Async callback: backend discovery result
    void onBackendReady(BackendType type);
    void onBackendLost(BackendType type);
    
    void shutdown();
};
```

**Behavior:**
- On `initialize()`: spawn background thread(s) for Bluetooth/USB discovery
- Continuously monitor available backends
- If a backend fails, log it and try the next one
- Expose current input state via `getSnapshot()`

#### InputBackend Interface (Abstract)

**Proposed interface for all backends:**

```cpp
enum class BackendType {
    Null,
    VirtualTouch,
    Bluetooth,
    USB,
};

enum class BackendState {
    Disconnected,   // No device / not yet discovered
    Discovering,    // Scanning or initializing
    Connecting,     // Pairing or waiting for device ready
    Connected,      // Ready to receive input
    Error,          // Recoverable error (e.g. connection lost)
    Fatal,          // Unrecoverable error
};

class InputBackend {
public:
    virtual ~InputBackend() = default;
    
    virtual BackendType getType() const = 0;
    virtual BackendState getState() const = 0;
    
    // Non-blocking initialization; discovery happens asynchronously
    virtual bool initialize() = 0;
    
    // Return current controller state
    virtual InputState getState() = 0;
    
    void shutdown() = 0;
};
```

#### Concrete Backends (Proposed)

1. **NullInputBackend**
   - Always connected
   - Returns neutral input state (all buttons unpressed, sticks centered)
   - Used as fallback when no other backend is available
   - Implemented in Phase 2

2. **VirtualTouchBackend**
   - Listens to Android `MotionEvent` / `KeyEvent` from an on-screen gamepad overlay
   - Converts touch coordinates to button/stick state
   - Always available on Android
   - Implemented in Phase 3

3. **AndroidBluetoothBackend**
   - Discovers Bluetooth HID devices (DualShock 3, generic joysticks)
   - Manages pairing and connection via Java `BluetoothAdapter` / JNI
   - Periodically polls or uses event callbacks for input data
   - May be `Connecting` for several seconds; does not block boot
   - Implemented in Phase 4

4. **AndroidUsbBackend**
   - Discovers USB HID devices via `UsbManager`
   - Requests permissions (Android user must grant)
   - Polls or uses callbacks for input data
   - Implemented in Phase 5

#### InputState (Normalized Representation)

A snapshot of one controller's state at one point in time:

```cpp
struct InputState {
    // Buttons (DualShock 3 / generic)
    bool square, triangle, circle, cross;    // Face buttons
    bool l1, l2, r1, r2;                     // Triggers
    bool select, start;                       // System buttons
    bool l3, r3;                              // Stick clicks
    bool ps;                                  // PS button
    
    // Analog values
    int16_t leftStickX, leftStickY;           // -32768 to +32767
    int16_t rightStickX, rightStickY;         // -32768 to +32767
    uint8_t l2Analog, r2Analog;               // 0 to 255
    
    // D-Pad (boolean or direction)
    bool dpadUp, dpadDown, dpadLeft, dpadRight;
    
    // Meta
    uint8_t playerId;                         // 0 = first controller, 1, 2, 3
    bool connected;                           // Is this controller present?
    uint32_t controllerId;                    // Unique ID for this device
};
```

#### InputSnapshot (Multiple Controllers, Thread-Safe)

A snapshot of all active controllers at one frame:

```cpp
struct InputSnapshot {
    // Typically 4 controllers for PS3
    std::array<InputState, 4> controllers;
    
    // Which controllers are active
    std::bitset<4> connected;
    
    // Metadata
    uint64_t frameNumber;
    uint64_t timestampNs;
};
```

---

## Input State Representation

### Normalized Button/Stick Set

P3XE must define a standard `InputState` that covers:

- **Face buttons:** Square, Triangle, Circle, Cross (PS3 standard)
- **Shoulder buttons:** L1, L2, R1, R2 (analog and digital)
- **System buttons:** Select, Start, PS button
- **Analog sticks:** Left and Right, with click (L3, R3)
- **D-Pad:** 4-directional or combined
- **Triggers:** Analog L2/R2 (optional; may be mapped to buttons on older gamepads)

### Controller Metadata

- **Connection state:** connected / disconnected
- **Controller ID:** unique identifier for the device (MAC address for Bluetooth, USB serial for USB)
- **Player number:** 0–3 (for multi-player support)
- **Backend type:** which backend is providing this controller (Bluetooth, USB, touch)

### Timestamp and Frame Number

Each `InputSnapshot` includes:
- A frame number (to detect missed frames)
- A timestamp in nanoseconds (for accurate input recording / playback)

---

## Backend Lifecycle

### State Transitions

```
┌──────────────┐
│ Disconnected │  (Initial state or after device lost)
└──────┬───────┘
       │ initialize() called
       ↓
┌──────────────┐
│ Discovering  │  (Scanning Bluetooth, checking USB, etc.)
└──────┬───────┘
       │ Device found
       ↓
┌──────────────┐
│ Connecting   │  (Establishing link, requesting permissions, etc.)
└──────┬────┬──┘
       │    │ Error or timeout
       │    ↓
       │  ┌──────┐
       │  │Error │  (Recoverable; will retry)
       │  └──────┘
       │
       │ Connection established
       ↓
┌──────────────┐
│ Connected    │  (Ready to receive input)
└──────┬──────┘
       │ Device lost / disconnected
       ├────────────────→ Disconnected
       │
       │ Unrecoverable error
       ↓
      Fatal
```

### Timeout and Retry Behavior

- **Discovery timeout:** If Bluetooth scan takes > 3 seconds and no device found, mark as `Error` and retry in background
- **Connection timeout:** If device not responding after 5 seconds, mark as `Error` and retry
- **Error recovery:** Retry every 5–10 seconds, indefinitely (or until user explicitly disables backend)
- **No blocking:** None of these timeouts block the main boot or render path

---

## Error Handling Strategy

### Principle: Errors Are Logged, Not Fatal

Any error in input initialization, discovery, or runtime must:

1. Be logged (with timestamp, backend type, error code)
2. Change the backend state to `Error` or `Fatal` 
3. Trigger fallback to the next available backend
4. NOT abort or block firmware, Cell, RSX, or renderer

### Specific Error Cases

| Error | Handling |
|-------|----------|
| Bluetooth disabled | Log warning; try USB and touch backends |
| Bluetooth device not found | Log info; retry in background; use touch |
| Bluetooth pairing failed | Log warning; mark as `Error`; retry |
| USB device not found | Log info; use touch |
| USB permission denied | Log warning; prompt user (Java side); use touch |
| Touch input not available | Not expected on Android; log fatal but continue with null backend |
| Backend thread crashes | Log fatal; remove backend; continue with others |

### Emulator Stability

- No error in input acquisition causes emulator crash or game termination
- Game must remain playable with `NullInputBackend` (neutral state)
- If all backends fail, `NullInputBackend` is always available as last resort

---

## Hot-Plug Support

### Use Case

User launches a game without a controller. Later, they connect a Bluetooth DualShock 3:
- Emulator detects new device
- ControllerManager updates `InputSnapshot`
- Next frame, game receives input from the new controller
- No restart, no lag spike, no dropped frames

### Implementation Strategy

**Bluetooth hot-plug:**
1. `AndroidBluetoothBackend` listens to system Bluetooth broadcasts (`ACTION_ACL_CONNECTED`, `ACTION_ACL_DISCONNECTED`)
2. On connection event, attempt to pair/bond
3. On successful connection, publish event to `ControllerManager`
4. `ControllerManager` updates `InputSnapshot` and `connected` flag
5. Next game frame reads new controller state

**USB hot-plug:**
1. `AndroidUsbBackend` registers a `BroadcastReceiver` for `ACTION_USB_DEVICE_ATTACHED` / `ACTION_USB_DEVICE_DETACHED`
2. On attachment, request permission (if needed) and open device
3. On successful open, publish event
4. `ControllerManager` updates snapshot
5. Game continues

**Touch hot-plug:**
- Touch is always available; nothing to detect
- `VirtualTouchBackend` always reports `connected = true`

### No Restart Required

- `ControllerManager` already holds a lock-free or thread-safe snapshot
- Hot-plug event does not trigger emulator reboot
- Game loop polls `InputSnapshot` each frame and sees the new controller

---

## Virtual Controls as First-Class Backend

### Why Virtual Controls Are Important

1. **Not all users have a physical controller.** Mobile phones or tablets may not have Bluetooth or USB ports.
2. **Virtual controls are always available.** No discovery, no pairing, no permissions (except touch input, which is standard).
3. **Development and testing.** Developers can test input without hardware.
4. **Accessibility.** Users with limited mobility can use on-screen buttons.
5. **Casual play.** Some players prefer touch controls for casual games.

### VirtualTouchBackend Design

**Features:**
- On-screen gamepad overlay (can be toggled on/off)
- Animated feedback (button press, stick movement)
- Customizable opacity and size
- Supports multiple simultaneous touch points (multitouch)
- Persists user layout preferences

**Implementation (Phase 3):**
1. Android `View` or `SurfaceView` for overlay rendering
2. `onTouchEvent()` handler that converts touch coordinates to button/stick state
3. JNI callback to `ControllerManager` with new `InputState`
4. Synchronized with render loop to avoid frame drops

**Priority:**
- `VirtualTouchBackend` is **not** an emergency fallback; it's a **primary backend**
- Priority order: Bluetooth (if connected) > USB (if connected) > Touch (always available) > Null
- User can explicitly select touch in settings if they prefer it over Bluetooth

---

## Threading Model

### Boot Thread (Main / Render Thread)

```cpp
// Pseudocode
void gameBootThread() {
    firmware.load();
    cell.initialize();
    rsx.initialize();
    
    while (gameRunning) {
        // Each frame:
        InputSnapshot snap = controllerManager.getSnapshot();  // Non-blocking, lock-free read
        gameLogic.update(snap);
        renderer.render();
    }
}
```

**Key property:** This thread NEVER blocks on controller discovery or device I/O.

### ControllerManager Thread (Background Worker)

```cpp
// Pseudocode (not real code)
void controllerDiscoveryThread() {
    backends[] = { bluetoothBackend, usbBackend, touchBackend };
    
    while (running) {
        for (auto backend : backends) {
            if (backend.getState() == Disconnected) {
                backend.initialize();  // Non-blocking; returns quickly
            }
            
            if (backend.getState() == Discovering) {
                checkForDevices();     // Async or with timeout
            }
            
            if (backend.getState() == Connected) {
                state = backend.getInputState();  // Poll or event-driven
                updateSnapshot(state);            // Thread-safe update
            }
        }
        
        sleepMs(50);  // Poll every 50 ms
    }
}
```

**Key properties:**
- Runs independently of game boot/render
- Never blocks the main thread
- Updates a thread-safe snapshot every 50 ms or on event
- Handles retries and error recovery internally

### Synchronization

- `InputSnapshot` is accessed via a read-write lock or atomic pointer (lock-free if possible)
- Render thread reads snapshot every frame (read-only)
- ControllerManager thread writes snapshot when backend state changes (write-only)
- No busy-waiting; use condition variables or event callbacks

---

## Implementation Phases

### Phase 1: Interfaces and InputState/InputSnapshot

**Deliverable:**
- Header files defining `InputBackend`, `InputState`, `InputSnapshot`, `ControllerManager`
- No implementation yet; pure interfaces

**Files (proposed):**
- `CoreEmulator/include/input/InputBackend.h`
- `CoreEmulator/include/input/InputState.h`
- `CoreEmulator/include/input/InputSnapshot.h`
- `CoreEmulator/include/input/ControllerManager.h`

**Note:** CoreEmulator does not implement `ControllerManager`; it only defines the interface that Cubo3D/Android will implement.

### Phase 2: NullInputBackend

**Deliverable:**
- Stub backend that always returns neutral input state
- Used as fallback and for testing

**Files (proposed):**
- `CoreEmulator/input/backends/NullInputBackend.h`
- `CoreEmulator/input/backends/NullInputBackend.cpp`

**Behavior:**
- Always reports `connected = true`
- All buttons `false`, all sticks `(0, 0)`, all triggers `0`

### Phase 3: VirtualTouchBackend (Android)

**Deliverable:**
- On-screen gamepad overlay
- Touch-to-input conversion
- Multitouch support

**Files (proposed):**
- `Cubo3D/android/app/src/main/java/com/pure3x/cubo3d/input/VirtualGamepadView.java`
- `Cubo3D/android/app/src/main/java/com/pure3x/cubo3d/input/VirtualGamepadController.java`
- `Cubo3D/src/Android/input/VirtualTouchBackend.cpp` (JNI wrapper)
- `Cubo3D/src/Android/input/VirtualTouchBackend.h`

**Behavior:**
- Renders on-screen buttons/sticks
- Listens to `MotionEvent`
- Converts touch positions to `InputState`
- Always reports `connected = true`

### Phase 4: AndroidBluetoothBackend

**Deliverable:**
- Bluetooth device discovery
- HID parsing for DualShock 3 and generic joysticks
- Connection lifecycle management

**Files (proposed):**
- `Cubo3D/android/app/src/main/java/com/pure3x/cubo3d/input/BluetoothInputService.java`
- `Cubo3D/android/app/src/main/java/com/pure3x/cubo3d/input/BluetoothHIDParser.java`
- `Cubo3D/src/Android/input/AndroidBluetoothBackend.cpp` (JNI interface)
- `Cubo3D/src/Android/input/AndroidBluetoothBackend.h`

**Behavior:**
- Scans for Bluetooth HID devices
- Attempts to pair/bond
- Reads HID reports and maps to `InputState`
- Handles device disconnect and reconnection
- Non-blocking; uses timeouts and retries

### Phase 5: AndroidUsbBackend

**Deliverable:**
- USB device enumeration
- Permission handling
- HID parsing for USB devices

**Files (proposed):**
- `Cubo3D/android/app/src/main/java/com/pure3x/cubo3d/input/UsbInputService.java`
- `Cubo3D/android/app/src/main/java/com/pure3x/cubo3d/input/UsbHIDParser.java`
- `Cubo3D/src/Android/input/AndroidUsbBackend.cpp` (JNI interface)
- `Cubo3D/src/Android/input/AndroidUsbBackend.h`

**Behavior:**
- Enumerates USB devices
- Requests permission
- Reads USB HID reports
- Maps to `InputState`
- Hot-plug support via `BroadcastReceiver`

### Phase 6: DualShock 3 Mapping

**Deliverable:**
- Specific HID parsing for Sony DualShock 3
- Mapping of PS3 button codes to `InputState`
- Pressure-sensitive button support (if available)

**Note:** Generic HID parsing should already work for DualShock 3; this phase fine-tunes and adds PS3-specific features.

**Files (proposed):**
- `Cubo3D/src/Android/input/DualShock3HIDParser.cpp`
- `Cubo3D/src/Android/input/DualShock3HIDParser.h`

### Phase 7: Hot-Plug and Robustness Tests

**Deliverable:**
- Unit tests for hot-plug scenarios (connect/disconnect while game running)
- Stress tests (rapid connect/disconnect, pairing failures)
- Integration tests with actual hardware (DualShock 3, generic Bluetooth joystick, USB controller)

**Test scenarios:**
1. Game boots without controller; controller connected mid-game
2. Controller connected, then disconnected; input falls back to touch
3. Controller reconnects (same device ID)
4. Multiple controllers connected; switching player slots
5. Bluetooth unavailable (turned off); fallback to USB then touch
6. USB controller removed while game is running
7. Permission denied for USB; game continues with touch

---

## Migration Path

### Step 0: Review This Document

- Team reviews and approves the architecture
- Identify any gaps or concerns
- Adapt for P3XE's specific needs (e.g. multi-player slots, accessibility features)

### Step 1: Create Interfaces (Phase 1)

- Define header files for `InputBackend`, `InputState`, etc.
- Do NOT implement yet
- Cubo3D/Android and CoreEmulator agree on the contract

### Step 2: Integrate ControllerManager into Cubo3D

- `MainActivity` creates a `ControllerManager` instance
- `ControllerManager` spawns worker thread on app startup
- Render callback polls `InputSnapshot` every frame
- Game logic receives input snapshot (still all neutral/null for now)
- **No breaking changes to existing render pipeline**

### Step 3: Implement NullInputBackend + VirtualTouchBackend

- Minimal backends to enable testing
- Cubo3D app already renders test frames; now it will accept touch input
- Developers can test input without Bluetooth/USB hardware

### Step 4: Implement Bluetooth Backend

- Enable real DualShock 3 / Bluetooth joystick support
- Priority: Bluetooth is common on PS3 emulation
- Hot-plug testing begins here

### Step 5: Implement USB Backend

- For users with USB adapters or OTG docks
- Lower priority than Bluetooth

### Step 6: Fine-Tune DualShock 3 Mapping

- Ensure pressure-sensitive buttons work correctly
- Test with actual PS3 games (once game loading is implemented)

### Step 7: Integration Testing and Robustness

- Combine with firmware loading, game boot, and rendering
- Full end-to-end testing

---

## Key Design Principles

1. **Boot Never Depends on Hardware**
   - Game boot path is completely independent of input discovery
   - Input is optional; emulator always boots

2. **CoreEmulator Isolation**
   - Core never calls Android APIs
   - Core never blocks on I/O
   - Core consumes normalized input snapshot

3. **Graceful Degradation**
   - Missing hardware → next available backend
   - All backends fail → NullInputBackend (neutral state)
   - Game remains playable under all conditions

4. **Hot-Plug Without Restart**
   - Devices can connect/disconnect at any time
   - No emulator restart required
   - No frame drops or lag spikes

5. **Touch as First-Class**
   - Virtual touch is not an emergency fallback
   - It's a primary backend, equivalent to Bluetooth/USB
   - Should be well-designed and responsive

6. **Thread Safety**
   - Input snapshot is accessed lock-free (or with minimal locking)
   - Render thread reads; discovery thread writes
   - No race conditions or deadlocks

7. **Error Resilience**
   - All errors are logged, never fatal
   - Retry logic is built in
   - Users can continue playing even if a backend fails

---

## Appendix: Architecture Diagram

```
┌────────────────────────────────────────────────────────────────────┐
│                         P3XE Application                            │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  ┌──────────────────────────────┐    ┌──────────────────────────┐ │
│  │   Render/Game Thread         │    │  Controller Thread       │ │
│  │  (Main Loop)                 │    │  (Background Worker)     │ │
│  │                              │    │                          │ │
│  │  1. Load Firmware            │    │  ControllerManager       │ │
│  │  2. Boot Cell                │    │  ├─ Initialize backends  │ │
│  │  3. Initialize RSX           │    │  ├─ Discover devices     │ │
│  │  4. Cubo3D Renderer          │    │  ├─ Monitor state        │ │
│  │                              │    │  └─ Update snapshot      │ │
│  │  Each frame:                 │    │                          │ │
│  │  ├─ Poll InputSnapshot ─────┼───→├─ Thread-safe read        │ │
│  │  ├─ Update game logic        │    │                          │ │
│  │  ├─ Render frame             │    │  Backends:               │ │
│  │  └─ Display                  │    │  ├─ NullInputBackend     │ │
│  │                              │    │  ├─ VirtualTouchBackend  │ │
│  └──────────────────────────────┘    │  ├─ Bluetooth            │ │
│                                       │  └─ USB                  │ │
│                                       │                          │ │
│                                       └──────────────────────────┘ │
├────────────────────────────────────────────────────────────────────┤
│                                                                    │
│  ┌──────────────────────────────────────────────────────────────┐ │
│  │                 Android/JNI Layer                            │ │
│  │                                                              │ │
│  │  ├─ BluetoothAdapter (Kotlin)                               │ │
│  │  ├─ UsbManager (Kotlin)                                     │ │
│  │  ├─ MotionEvent Handler (touch overlay)                     │ │
│  │  ├─ BroadcastReceiver (device connect/disconnect)           │ │
│  │  │                                                          │ │
│  │  └─ JNI Bridge to ControllerManager                         │ │
│  │                                                              │ │
│  └──────────────────────────────────────────────────────────────┘ │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

## Document History

| Version | Date | Author | Notes |
|---------|------|--------|-------|
| 0.1 | 2026-09-27 | Architecture Proposal | Initial comprehensive proposal based on repository investigation; not yet implemented |

---

## References

- **Repository:** `lhuisaazevedo-boop/Pure3XEngine`
- **Related Documents:**
  - `docs/Input_System_Roadmap.md` (legacy/historical)
  - `ARCHITECTURE.md` (core system design)
  - `README.md` (project overview)
- **Investigation Report:** Results from deep repository analysis (2026-09-27)

