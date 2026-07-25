-- Generated from package.json | build/build.sh

return [[
{
    "name": "windui",
    "version": "1.6.65",
    "main": "./dist/main.lua",
    "repository": "https://github.com/article-hub-studio/WindUI-Skibidi",
    "discord": "https://discord.gg/ftgs-development-hub-1300692552005189632",
    "author": "Footagesus",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "bash build/build.sh dev $INPUT_FILE",
        "build": "bash build/build.sh build $INPUT_FILE",
        "live": "python3 -m http.server 8642",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
        "updater": "python3 updater/main.py",
        "docs:dev": "npm --prefix website run dev",
        "docs:build": "npm --prefix website run build",
        "docs:start": "npm --prefix website run start",
        "verify:notification": "stylua --syntax Luau --check src/components/Notification.lua tests/Notification.lua && node tests/notification-layout-safety.test.js",
        "verify:ui": "stylua --syntax Luau --check src/modules/Icons.lua src/modules/Creator.lua src/Init.lua src/components/Notification.lua src/components/window/Openbutton.lua src/themes/Fallbacks.lua tests/Notification.lua && node tests/notification-layout-safety.test.js && node tests/ui-library-advanced.test.js",
        "test:static": "node tests/acrylic-theme-safety.test.js && node tests/notification-layout-safety.test.js && node tests/ui-library-advanced.test.js && node tests/input-lifecycle-safety.test.js"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}
]]
