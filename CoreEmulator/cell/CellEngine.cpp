#include "CellEngine.h"

namespace Pure3X {

bool CellEngine::initialize() {
    if (!ppu_.initialize())
        return false;

    if (!spu_.initialize()) {
        ppu_.shutdown();
        return false;
    }

    initialized_ = true;
    return true;
}

void CellEngine::reset() {
    ppu_.reset();
    spu_.reset();
}

void CellEngine::shutdown() {
    spu_.shutdown();
    ppu_.shutdown();
    initialized_ = false;
}

PPUInterpreter& CellEngine::ppu() {
    return ppu_;
}

SPUManager& CellEngine::spu() {
    return spu_;
}

}
