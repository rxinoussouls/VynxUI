import { Theme } from "./themes";
import { defaults } from "./defaults";

export type ResolvedTheme = Record<string, string>;

export function resolveTheme(theme: Theme): ResolvedTheme {
    const base: Record<string, string> = {
        background: theme.background as string,
        accent: theme.accent as string,
        dialog: theme.dialog as string,
        text: theme.text as string,
        placeholder: theme.placeholder,
        button: theme.button as string,
        icon: theme.icon,
        toggle: theme.toggle ?? "",
        slider: theme.slider ?? "",
        checkbox: theme.checkbox ?? "",
        primary: theme.primary ?? theme.icon,
        White: "#ffffff",
        Black: "#000000",
    };

    const resolved: ResolvedTheme = { ...base };

    const resolve = (value: string, depth = 0): string => {
        if (depth > 10) return value;
        if (value.startsWith("#") || value.startsWith("linear-gradient"))
            return value;

        const target =
            resolved[value] ??
            resolved[value.toLowerCase()] ??
            base[value] ??
            base[value.toLowerCase()];
        if (target && target !== value) return resolve(target, depth + 1);
        return value;
    };

    for (const [key, value] of Object.entries(defaults)) {
        if (resolved[key] !== undefined) continue;
        resolved[key] = resolve(value);
    }

    for (const [key, value] of Object.entries(resolved)) {
        resolved[key] = resolve(value);
    }

    return resolved;
}

export function colorWithOpacity(
    color: string,
    opacity: string | undefined,
    fallback = 0.1,
) {
    const o = parseFloat(opacity ?? String(fallback));
    const percent = Math.round(o * 100);
    return `color-mix(in srgb, ${color} ${percent}%, transparent)`;
}
