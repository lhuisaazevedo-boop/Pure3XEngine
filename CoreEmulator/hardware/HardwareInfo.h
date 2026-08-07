#pragma once
#include <string>

namespace Pure3X {

class HardwareInfo {
public:
    static std::string platform();
    static std::string cpu();
    static std::string gpu();
};

}
