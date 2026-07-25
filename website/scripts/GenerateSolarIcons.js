const fs = require("fs");
const path = require("path");

const pkgPath = path.resolve("node_modules/@iconify-json/solar");
const iconsJson = JSON.parse(
    fs.readFileSync(path.join(pkgPath, "icons.json"), "utf8"),
);

const icons = iconsJson.icons;
const outPath = path.resolve("app/SolarIcons.tsx");

const entries = Object.entries(icons);

const lines = [
    `// AUTO GENERATED`,
    `import React from "react";`,
    ``,
    `type IconProps = { size?: number; color?: string; className?: string };`,
    ``,
];

for (const [key, value] of entries) {
    let name = key
        .split("-")
        .map((w) => w[0].toUpperCase() + w.slice(1))
        .join("");

    if (/^\d/.test(name)) name = "Icon" + name;

    lines.push(`
export function ${name}({ size = 24, color = "currentColor", className }: IconProps) {
  return (
    <svg
      className={className}
      width={size}
      height={size}
      viewBox="0 0 24 24"
      fill="none"
      style={{ color }}
      dangerouslySetInnerHTML={{ __html: ${JSON.stringify(value.body)} }}
    />
  );
}
  `);
}

fs.writeFileSync(outPath, lines.join("\n"), "utf8");
console.log("Generated", outPath);
