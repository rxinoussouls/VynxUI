"use client";

import { createContext, useContext, useState, ReactNode } from "react";
import { themes, ThemeName, Theme } from "../themes";
import { resolveTheme, ResolvedTheme } from "../resolveTheme";

const ThemeContext = createContext<ThemeContextValue | null>(null);

interface ThemeContextValue {
    themeName: ThemeName;
    theme: Theme;
    resolved: ResolvedTheme;
    setTheme: (name: ThemeName) => void;
}

export function ThemeProvider({ children }: { children: ReactNode }) {
    const [themeName, setThemeName] = useState<ThemeName>("Dark");
    const theme = themes[themeName];

    return (
        <ThemeContext.Provider
            value={{
                themeName,
                theme,
                resolved: resolveTheme(theme),
                setTheme: setThemeName,
            }}
        >
            {children}
        </ThemeContext.Provider>
    );
}

export function useTheme() {
    const ctx = useContext(ThemeContext);
    if (!ctx) throw new Error("useTheme must be used inside ThemeProvider");
    return ctx;
}
