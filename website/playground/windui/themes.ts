// playground/windui/themes.ts

export type ThemeName =
    | "Dark"
    | "Light"
    | "Rose"
    | "Plant"
    | "Red"
    | "Indigo"
    | "Sky"
    | "Violet"
    | "Amber"
    | "Emerald"
    | "Midnight"
    | "Crimson"
    | "MonokaiPro"
    | "CottonCandy"
    | "Mellowsi"
    | "Rainbow";

export interface Theme {
    name: string;
    background: string;
    accent: string;
    dialog: string;
    text: string;
    placeholder: string;
    button: string;
    icon: string;
    outline?: string;
    toggle?: string;
    slider?: string;
    checkbox?: string;
    primary?: string;
    panelBackground?: string;
    panelBackgroundOpacity?: number;
    labelBackground?: string;
    labelBackgroundOpacity?: number;
}

export function gradient(
    stops: { color: string; pos?: number }[],
    rotation = 45,
) {
    const s = stops
        .map((stop, i) => {
            const pos =
                stop.pos !== undefined
                    ? `${stop.pos}%`
                    : `${Math.round((i / (stops.length - 1)) * 100)}%`;
            return `${stop.color} ${pos}`;
        })
        .join(", ");
    return `linear-gradient(${rotation}deg, ${s})`;
}

export const themes: Record<ThemeName, Theme> = {
    Dark: {
        name: "Dark",
        accent: "#18181b",
        dialog: "#161616",
        outline: "#FFFFFF",
        text: "#FFFFFF",
        placeholder: "#7a7a7a",
        background: "#101010",
        button: "#52525b",
        icon: "#a1a1aa",
        toggle: "#33C759",
        slider: "#0091FF",
        checkbox: "#0091FF",
        panelBackground: "#FFFFFF",
        panelBackgroundOpacity: 0.05,
        primary: "#0091FF",
        labelBackground: "#000000",
        labelBackgroundOpacity: 0.17,
    },
    Light: {
        name: "Light",
        accent: "#FFFFFF",
        dialog: "#f4f4f5",
        outline: "#ffffff",
        text: "#000000",
        placeholder: "#555555",
        background: "#e9e9e9",
        button: "#18181b",
        icon: "#52525b",
        toggle: "#33C759",
        slider: "#0091FF",
        checkbox: "#0091FF",
        panelBackground: "#FFFFFF",
        panelBackgroundOpacity: 1,
        labelBackground: "#ffffff",
        labelBackgroundOpacity: 1,
    },
    Rose: {
        name: "Rose",
        accent: "#be185d",
        dialog: "#4c0519",
        text: "#fdf2f8",
        placeholder: "#d67aa6",
        background: "#1f0308",
        button: "#e95f74",
        icon: "#fb7185",
    },
    Plant: {
        name: "Plant",
        accent: "#166534",
        dialog: "#052e16",
        text: "#f0fdf4",
        placeholder: "#4fbf7a",
        background: "#0a1b0f",
        button: "#16a34a",
        icon: "#4ade80",
    },
    Red: {
        name: "Red",
        accent: "#991b1b",
        dialog: "#450a0a",
        text: "#fef2f2",
        placeholder: "#d95353",
        background: "#1c0606",
        button: "#dc2626",
        icon: "#ef4444",
    },
    Indigo: {
        name: "Indigo",
        accent: "#3730a3",
        dialog: "#1e1b4b",
        text: "#f1f5f9",
        placeholder: "#7078d9",
        background: "#0f0a2e",
        button: "#4f46e5",
        icon: "#6366f1",
    },
    Sky: {
        name: "Sky",
        accent: "#00d4ff",
        dialog: "#0a4d66",
        text: "#e6f7ff",
        placeholder: "#66b3cc",
        background: "#051a26",
        button: "#00a8cc",
        icon: "#2db8d9",
        toggle: "#00d9d9",
        slider: "#00d4ff",
        checkbox: "#00d4ff",
        panelBackground: "#0d3a47",
        panelBackgroundOpacity: 0.2,
    },
    Violet: {
        name: "Violet",
        accent: "#6d28d9",
        dialog: "#3c1361",
        text: "#faf5ff",
        placeholder: "#8f7ee0",
        background: "#1e0a3e",
        button: "#7c3aed",
        icon: "#8b5cf6",
    },
    Amber: {
        name: "Amber",
        accent: gradient(
            [
                { color: "#b45309", pos: 0 },
                { color: "#d97706", pos: 100 },
            ],
            45,
        ),
        dialog: gradient(
            [
                { color: "#451a03", pos: 0 },
                { color: "#6b2e05", pos: 100 },
            ],
            90,
        ),
        text: gradient(
            [
                { color: "#fffbeb", pos: 0 },
                { color: "#fff7ed", pos: 100 },
            ],
            45,
        ),
        placeholder: gradient(
            [
                { color: "#d1a326", pos: 0 },
                { color: "#fbbf24", pos: 100 },
            ],
            45,
        ),
        background: gradient(
            [
                { color: "#1c1003", pos: 0 },
                { color: "#3f210d", pos: 100 },
            ],
            90,
        ),
        button: gradient(
            [
                { color: "#d97706", pos: 0 },
                { color: "#f59e0b", pos: 100 },
            ],
            45,
        ),
        icon: "#f59e0b",
        toggle: gradient(
            [
                { color: "#d97706", pos: 0 },
                { color: "#f59e0b", pos: 100 },
            ],
            45,
        ),
        slider: "#d97706",
        checkbox: gradient(
            [
                { color: "#d97706", pos: 0 },
                { color: "#fbbf24", pos: 100 },
            ],
            45,
        ),
        panelBackground: "#FFFFFF",
        panelBackgroundOpacity: 0.05,
    },
    Emerald: {
        name: "Emerald",
        accent: "#047857",
        dialog: "#022c22",
        text: "#ecfdf5",
        placeholder: "#3fbf8f",
        background: "#011411",
        button: "#059669",
        icon: "#10b981",
    },
    Midnight: {
        name: "Midnight",
        accent: "#1e3a8a",
        dialog: "#0c1e42",
        text: "#dbeafe",
        placeholder: "#2f74d1",
        background: "#0a0f1e",
        button: "#2563eb",
        icon: "#5591f4",
        primary: "#2563eb",
    },
    Crimson: {
        name: "Crimson",
        accent: "#b91c1c",
        dialog: "#450a0a",
        text: "#fef2f2",
        placeholder: "#6f757b",
        background: "#0c0404",
        button: "#991b1b",
        icon: "#dc2626",
    },
    MonokaiPro: {
        name: "Monokai Pro",
        accent: "#fc9867",
        dialog: "#1e1e1e",
        text: "#fcfcfa",
        placeholder: "#6f6f6f",
        background: "#191622",
        button: "#ab9df2",
        icon: "#a9dc76",
    },
    CottonCandy: {
        name: "Cotton Candy",
        accent: "#ec4899",
        dialog: "#2d1b3d",
        text: "#fdf2f8",
        placeholder: "#8a5fd3",
        background: "#1a0b2e",
        button: "#d946ef",
        icon: "#06b6d4",
        slider: "#d946ef",
    },
    Mellowsi: {
        name: "Mellowsi",
        accent: "#342A1E",
        dialog: "#291C13",
        text: "#F5EBDD",
        placeholder: "#9C8A73",
        background: "#1C1002",
        button: "#342A1E",
        icon: "#C9B79C",
        toggle: "#a9873f",
        slider: "#C9A24D",
        checkbox: "#C9A24D",
    },
    Rainbow: {
        name: "Rainbow",
        accent: gradient(
            [
                { color: "#00ff41", pos: 0 },
                { color: "#00ffff", pos: 33 },
                { color: "#0080ff", pos: 66 },
                { color: "#8000ff", pos: 100 },
            ],
            45,
        ),
        dialog: gradient(
            [
                { color: "#ff0080", pos: 0 },
                { color: "#8000ff", pos: 25 },
                { color: "#0080ff", pos: 50 },
                { color: "#00ff80", pos: 75 },
                { color: "#ff8000", pos: 100 },
            ],
            135,
        ),
        text: "#ffffff",
        placeholder: "#00ff80",
        background: gradient(
            [
                { color: "#ff0040", pos: 0 },
                { color: "#ff4000", pos: 20 },
                { color: "#ffff00", pos: 40 },
                { color: "#00ff40", pos: 60 },
                { color: "#0040ff", pos: 80 },
                { color: "#4000ff", pos: 100 },
            ],
            90,
        ),
        button: gradient(
            [
                { color: "#ff0080", pos: 0 },
                { color: "#ff8000", pos: 25 },
                { color: "#ffff00", pos: 50 },
                { color: "#80ff00", pos: 75 },
                { color: "#00ffff", pos: 100 },
            ],
            60,
        ),
        icon: "#ffffff",
    },
};
