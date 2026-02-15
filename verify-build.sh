#!/bin/bash

###############################################################################
# RedM 128 Player Build Verification Script
# Author: iBoss21 / The Lux Empire
# Purpose: Verify that the player limit modifications are correctly applied
###############################################################################

echo "═══════════════════════════════════════════════════════════════════════════"
echo "🐺 RedM Extended Player Limits - Build Verification"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
PASS=0
FAIL=0
WARN=0

# Check functions
check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN++))
}

echo "Running verification checks..."
echo ""

###############################################################################
# 1. Check C++ Modification
###############################################################################
echo -e "${BLUE}[1/7]${NC} Checking C++ modification..."

CPP_FILE="code/components/gta-game-rdr3/src/NetworkPlayerMgr.cpp"
if [ -f "$CPP_FILE" ]; then
    if grep -q "83 F9 80" "$CPP_FILE"; then
        check_pass "NetworkPlayerMgr.cpp modified correctly (0x80 pattern found)"
    else
        if grep -q "83 F9 20" "$CPP_FILE"; then
            check_fail "NetworkPlayerMgr.cpp still has 0x20 pattern (32 players)"
            echo "         Action: Run git pull to get the latest changes"
        else
            check_warn "NetworkPlayerMgr.cpp pattern not found"
        fi
    fi
else
    check_fail "NetworkPlayerMgr.cpp not found at $CPP_FILE"
fi
echo ""

###############################################################################
# 2. Check Documentation
###############################################################################
echo -e "${BLUE}[2/7]${NC} Checking documentation files..."

DOCS=(
    "BUILD_INSTRUCTIONS.md"
    "PATCHES.md"
    "QUICKSTART.md"
    "server.cfg.example"
    "CHANGELOG.md"
)

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        check_pass "$doc exists"
    else
        check_fail "$doc not found"
    fi
done
echo ""

###############################################################################
# 3. Check Lua Resource
###############################################################################
echo -e "${BLUE}[3/7]${NC} Checking Lua resource..."

if [ -d "lxr-playerlimits" ]; then
    check_pass "lxr-playerlimits resource directory exists"
    
    # Check key files
    if [ -f "lxr-playerlimits/fxmanifest.lua" ]; then
        check_pass "fxmanifest.lua exists"
    else
        check_fail "fxmanifest.lua not found"
    fi
    
    if [ -f "lxr-playerlimits/config.lua" ]; then
        if grep -q "maxPhysicalPlayers = 128" "lxr-playerlimits/config.lua"; then
            check_pass "config.lua configured for 128 players"
        else
            check_warn "config.lua may need adjustment"
        fi
    else
        check_fail "config.lua not found"
    fi
else
    check_fail "lxr-playerlimits resource not found"
fi
echo ""

###############################################################################
# 4. Check Build Environment
###############################################################################
echo -e "${BLUE}[4/7]${NC} Checking build environment..."

# Check for git
if command -v git &> /dev/null; then
    check_pass "Git installed"
else
    check_fail "Git not found"
fi

# Check for cmake
if command -v cmake &> /dev/null; then
    check_pass "CMake installed"
else
    check_warn "CMake not found (required for building)"
fi

# Check for compiler
if command -v g++ &> /dev/null || command -v clang++ &> /dev/null; then
    check_pass "C++ compiler found"
else
    check_warn "C++ compiler not found (required for building)"
fi

echo ""

###############################################################################
# 5. Check Git Status
###############################################################################
echo -e "${BLUE}[5/7]${NC} Checking Git repository..."

if [ -d ".git" ]; then
    check_pass "Git repository initialized"
    
    # Check for uncommitted changes
    if git diff-index --quiet HEAD --; then
        check_pass "No uncommitted changes"
    else
        check_warn "Uncommitted changes detected"
    fi
    
    # Check current branch
    BRANCH=$(git branch --show-current 2>/dev/null)
    if [ ! -z "$BRANCH" ]; then
        echo "         Current branch: $BRANCH"
    fi
else
    check_fail "Not a Git repository"
fi
echo ""

###############################################################################
# 6. Check Submodules
###############################################################################
echo -e "${BLUE}[6/7]${NC} Checking submodules..."

if [ -f ".gitmodules" ]; then
    check_pass ".gitmodules file exists"
    
    # Check if submodules are initialized
    if git submodule status &> /dev/null; then
        # Count submodules
        SUBMODULE_COUNT=$(git submodule status | wc -l)
        if [ $SUBMODULE_COUNT -gt 0 ]; then
            check_pass "Submodules initialized ($SUBMODULE_COUNT found)"
            
            # Check for uninitialized submodules
            UNINIT=$(git submodule status | grep "^-" | wc -l)
            if [ $UNINIT -gt 0 ]; then
                check_warn "$UNINIT submodule(s) not initialized"
                echo "         Action: Run 'git submodule update --init --recursive'"
            fi
        else
            check_warn "No submodules found (may need initialization)"
        fi
    else
        check_warn "Could not check submodule status"
    fi
else
    check_warn ".gitmodules not found"
fi
echo ""

###############################################################################
# 7. Check Build Directory
###############################################################################
echo -e "${BLUE}[7/7]${NC} Checking build directory..."

if [ -d "code/build" ]; then
    check_pass "Build directory exists"
    
    # Check for build artifacts
    if [ -f "code/build/Makefile" ] || [ -f "code/build/solution/CitizenMP.sln" ]; then
        check_pass "Build configuration found"
    else
        check_warn "Build configuration not found (run prebuild script)"
    fi
else
    check_warn "Build directory not found (run prebuild script)"
fi
echo ""

###############################################################################
# Summary
###############################################################################
echo "═══════════════════════════════════════════════════════════════════════════"
echo "Verification Summary"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
echo -e "${GREEN}Passed:${NC}  $PASS"
echo -e "${YELLOW}Warnings:${NC} $WARN"
echo -e "${RED}Failed:${NC}  $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    if [ $WARN -eq 0 ]; then
        echo -e "${GREEN}✓ All checks passed! You're ready to build.${NC}"
        echo ""
        echo "Next steps:"
        echo "1. Run ./prebuild.sh (or prebuild.cmd on Windows)"
        echo "2. Build the project (see BUILD_INSTRUCTIONS.md)"
        echo "3. Deploy and configure your server"
    else
        echo -e "${YELLOW}⚠ Some warnings detected, but you can proceed.${NC}"
        echo "Review warnings above before building."
    fi
else
    echo -e "${RED}✗ Some checks failed. Please fix the issues above.${NC}"
    echo ""
    echo "Common fixes:"
    echo "- Run 'git pull' to get latest changes"
    echo "- Run 'git submodule update --init --recursive'"
    echo "- Install missing build tools"
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo "🐺 For more information, see:"
echo "   - BUILD_INSTRUCTIONS.md"
echo "   - QUICKSTART.md"
echo "   - PATCHES.md"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
