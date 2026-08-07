#pragma once

#include <string>

namespace Pure3X {

class DiscManager {
public:
    bool mount(const std::string& path);
    void unmount();

    bool isMounted() const;
    const std::string& path() const;

private:
    bool mounted_ = false;
    std::string path_;
};

}
