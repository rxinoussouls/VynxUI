#!/bin/bash

MODE=${1:-"build"}

P='\033[38;2;124;92;255m'   # Vynx purple
D='\033[38;2;255;210;50m'   # dev yellow
B='\033[38;2;50;231;255m'   # build cyan
E='\033[38;2;255;74;50m'    # error red
R='\033[0m'

if [ "$MODE" = "dev" ]; then
    PREFIX="${D}[ DEV ]${R}"
else
    PREFIX="${B}[ BUILD ]${R}"
fi

OUTPUT="build/VynxUI.lua"
TEMP="build/temp_bundle.lua"

# ── Read metadata from package.json ──────────────────────────────────────────
PKG=$(node -e "const p=require('./package.json');console.log(JSON.stringify({v:p.version||'',d:p.description||'',r:p.repository||'',l:p.license||''}))" 2>/dev/null)

if [ $? -ne 0 ] || [ -z "$PKG" ]; then
    echo -e "${E}[ × ]${R} Failed to read package.json"
    exit 1
fi

VER=$(echo $PKG | node -pe "JSON.parse(require('fs').readFileSync(0,'utf-8')).v")
DATE=$(date '+%Y-%m-%d')

# ── Generate header from template ────────────────────────────────────────────
HEADER=$(cat build/header.lua | node -e "
const pkg=JSON.parse('$PKG');
let h=require('fs').readFileSync(0,'utf-8');
h=h.replace(/{{VERSION}}/g,'$VER')
   .replace(/{{BUILD_DATE}}/g,'$DATE')
   .replace(/{{DESCRIPTION}}/g,pkg.d)
   .replace(/{{REPOSITORY}}/g,pkg.r)
   .replace(/{{LICENSE}}/g,pkg.l);
process.stdout.write(h);
")

START=$(date +%s%N)

# ── Try darklua (needs aftman) ────────────────────────────────────────────────
DARKLUA_BIN=$(command -v darklua 2>/dev/null || true)
if [ -z "$DARKLUA_BIN" ] && [ -x "$HOME/.aftman/bin/darklua" ]; then
    DARKLUA_BIN="$HOME/.aftman/bin/darklua"
fi

if [ -n "$DARKLUA_BIN" ] && [ "$MODE" = "build" ]; then
    # darklua path: bundle.py first (unminified), then darklua minifies
    echo -e "${P}[ · ]${R} Running Python bundler..."
    python3 build/bundle.py --output "$TEMP" --no-header 2>/dev/null || python3 build/bundle.py

    if [ -f "$TEMP" ]; then
        echo -e "${P}[ · ]${R} Running darklua minifier..."
        DARKLUA_CONFIG="build/darklua.config.json"
        "$DARKLUA_BIN" process "$TEMP" "${TEMP%.lua}.min.lua" --config "$DARKLUA_CONFIG" 2>/dev/null && mv "${TEMP%.lua}.min.lua" "$TEMP"
    fi
else
    # Python-only path
    echo -e "${P}[ · ]${R} Running Python bundler..."
    python3 build/bundle.py
    cp "$OUTPUT" "$TEMP" 2>/dev/null || true
fi

END=$(date +%s%N)
TIME=$((($END - $START) / 1000000))

# ── Prepend header ────────────────────────────────────────────────────────────
if [ -f "$TEMP" ]; then
    echo "$HEADER" > "$OUTPUT"
    echo "" >> "$OUTPUT"
    cat "$TEMP" >> "$OUTPUT"
    rm -f "$TEMP"
fi

SIZE=$(($(wc -c < "$OUTPUT") / 1024))

echo ""
echo -e "[ $(date '+%H:%M:%S') ]"
echo -e "${P}[ ✓ ]${R} $PREFIX"
echo -e "${P}[ > ]${R} VynxUI Build completed successfully"
echo -e "${P}[ > ]${R} Version: ${VER}"
echo -e "${P}[ > ]${R} Time taken: ${TIME}ms"
echo -e "${P}[ > ]${R} Size: ${SIZE}KB"
echo -e "${P}[ > ]${R} Output file: ${OUTPUT}"
echo ""
