#pragma once

#include "../ppu/PPUInterpreter.h"
#include "../spu/SPUManager.h"

namespace Pure3X {

class CellEngine {
public:
    bool initialize();
    void reset();
    void shutdown();

    PPUInterpreter& ppu();
    SPUManager& spu();

private:
    PPUInterpreter ppu_;
    SPUManager spu_;
    bool initialized_ = false;
};

}
