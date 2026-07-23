/**
 * VynxUI — Static Analysis Tests
 * Runs in Node.js, no Roblox environment needed.
 */

const fs = require("fs");
const path = require("path");

const ROOT = path.join(__dirname, "..");
let passed = 0;
let failed = 0;

function test(name, fn) {
    try {
        fn();
        console.log(`  [✓] ${name}`);
        passed++;
    } catch (e) {
        console.error(`  [✗] ${name}`);
        console.error(`      ${e.message}`);
        failed++;
    }
}

function assert(condition, message) {
    if (!condition) throw new Error(message || "Assertion failed");
}

// ── File existence checks ─────────────────────────────────────────────────────
console.log("\n[ File Structure ]");

const REQUIRED_FILES = [
    "Library.lua",
    "build/VynxUI.lua",
    "build/bundle.py",
    "build/header.lua",
    "build/build.sh",
    "loader.lua",
    "package.json",
    "aftman.toml",
    "changelog.md",
    "LICENSE",
    ".gitignore",
    "README.md",
    "elements/Init.lua",
    "modules/Creator.lua",
    "themes/Init.lua",
    "components/Notification.lua",
    "components/KeySystem.lua",
    "addons/SaveManager.lua",
    "addons/ThemeManager.lua",
];

for (const file of REQUIRED_FILES) {
    test(`File exists: ${file}`, () => {
        assert(
            fs.existsSync(path.join(ROOT, file)),
            `Missing file: ${file}`
        );
    });
}

// ── Build output checks ───────────────────────────────────────────────────────
console.log("\n[ Build Output ]");

const BUILD_PATH = path.join(ROOT, "build/VynxUI.lua");
const buildSrc = fs.existsSync(BUILD_PATH) ? fs.readFileSync(BUILD_PATH, "utf-8") : "";

const REQUIRED_API = [
    "CreateWindow",
    "SetTheme",
    "SetMotionPreset",
    "DynamicIsland",
    "DependencyBox",
    "Toggles",
    "Options",
    "GiveSignal",
    "OnUnload",
    "Unload",
];

for (const api of REQUIRED_API) {
    test(`Build contains API: ${api}`, () => {
        assert(buildSrc.includes(api), `build/VynxUI.lua missing: ${api}`);
    });
}

test("Build file is not empty (<1KB)", () => {
    assert(buildSrc.length > 1000, "build/VynxUI.lua is suspiciously small");
});

// ── Library.lua checks ────────────────────────────────────────────────────────
console.log("\n[ Library.lua ]");

const LIB_PATH = path.join(ROOT, "Library.lua");
const libSrc = fs.existsSync(LIB_PATH) ? fs.readFileSync(LIB_PATH, "utf-8") : "";

test("Library.lua has Version field", () => {
    assert(libSrc.includes("Version"), "Library.lua missing Version field");
});

test("Library.lua has Toggles registry", () => {
    assert(libSrc.includes("Toggles"), "Library.lua missing Toggles registry");
});

test("Library.lua has Options registry", () => {
    assert(libSrc.includes("Options"), "Library.lua missing Options registry");
});

// ── Themes check ──────────────────────────────────────────────────────────────
console.log("\n[ Themes ]");

const THEMES_PATH = path.join(ROOT, "themes/Init.lua");
const themesSrc = fs.existsSync(THEMES_PATH) ? fs.readFileSync(THEMES_PATH, "utf-8") : "";

const REQUIRED_THEMES = [
    "Dark", "Light", "Vynx", "Midnight", "Rose", "Nord",
    "Dracula", "Catppuccin", "TokyoNight", "Cyberpunk",
];

for (const theme of REQUIRED_THEMES) {
    test(`Theme exists: ${theme}`, () => {
        assert(themesSrc.includes(theme), `themes/Init.lua missing theme: ${theme}`);
    });
}

// ── package.json checks ───────────────────────────────────────────────────────
console.log("\n[ package.json ]");

const PKG_PATH = path.join(ROOT, "package.json");
const pkg = JSON.parse(fs.readFileSync(PKG_PATH, "utf-8"));

test("package.json has version", () => {
    assert(pkg.version, "package.json missing version");
});

test("package.json has build script", () => {
    assert(pkg.scripts && pkg.scripts.build, "package.json missing build script");
});

test("package.json main points to build/VynxUI.lua", () => {
    assert(
        pkg.main && pkg.main.includes("VynxUI.lua"),
        `package.json main should point to VynxUI.lua, got: ${pkg.main}`
    );
});

// ── Summary ───────────────────────────────────────────────────────────────────
console.log(`\n  ${passed} passed, ${failed} failed\n`);

if (failed > 0) {
    process.exit(1);
}
