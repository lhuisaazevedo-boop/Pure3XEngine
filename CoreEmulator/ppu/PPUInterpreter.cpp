#include "PPUInterpreter.h"

namespace Pure3X {

bool PPUInterpreter::initialize() {
    pc_ = 0;
    initialized_ = true;
    return true;
}

void PPUInterpreter::reset() {
    pc_ = 0;
}

void PPUInterpreter::shutdown() {
    initialized_ = false;
}

bool PPUInterpreter::step() {
    if (!initialized_)
        return false;

    pc_ += 4;
    return true;
}

std::uint64_t PPUInterpreter::programCounter() const {
    return pc_;
}

}
