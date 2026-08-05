#pragma once

#include <string>

namespace Pure3X
{

// ==============================
// Engine Information
// ==============================

std::string GetEngineName();
std::string GetVersion();
std::string GetBuild();
std::string GetDeveloper();


// ==============================
// P3XE Development Kit
// ==============================

std::string GetP3XEName();
std::string GetP3XEVersion();
std::string GetP3XELauncher();
std::string GetP3XEStatus();


// ==============================
// QEMU Center
// ==============================

std::string GetQEMUCenterName();
std::string GetQEMUCenterVersion();
std::string GetQEMUCenterStatus();


// ==============================
// Android Runtime
// ==============================

std::string GetAndroidRuntimeName();
std::string GetAndroidRuntimeVersion();
std::string GetAndroidRuntimeStatus();


// ==============================
// Platform Information
// ==============================

std::string GetPlatform();
std::string GetArchitecture();
std::string GetLanguage();


// ==============================
// Graphics
// ==============================

std::string GetGraphicsBackend();


// ==============================
// Engine Status
// ==============================

std::string GetStatus();
std::string GetCodename();

} // namespace Pure3X
