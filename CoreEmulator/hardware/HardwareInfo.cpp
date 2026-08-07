#include "HardwareInfo.h"

namespace Pure3X {

std::string HardwareInfo::platform() {
    return "PlayStation 3";
}

std::string HardwareInfo::cpu() {
    return "Cell Broadband Engine";
}

std::string HardwareInfo::gpu() {
    return "RSX Reality Synthesizer";
}

}
