"use client";

import { useState, useRef, useEffect } from "react";
import { useTheme } from "../playground/windui/context/ThemeContext";
import { themes, ThemeName } from "../playground/windui/themes";
import { ChevronDown, Check } from "lucide-react";

export function ThemeSwitcher() {
    const { themeName, setTheme } = useTheme();
    const [open, setOpen] = useState(false);
    const ref = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const handler = (e: MouseEvent) => {
            if (ref.current && !ref.current.contains(e.target as Node)) {
                setOpen(false);
            }
        };
        document.addEventListener("mousedown", handler);
        return () => document.removeEventListener("mousedown", handler);
    }, []);

    return (
        <div ref={ref} className="absolute top-3 left-3 z-50">
            <button
                onClick={() => setOpen((v) => !v)}
                className="flex items-center gap-2 px-3 py-2 rounded-2xl bg-white/10 hover:bg-white/15 text-white/80 text-xs font-medium transition-all backdrop-blur-sm"
            >
                <span
                    className="w-2.5 h-2.5 rounded-full shrink-0 border"
                    style={{ background: themes[themeName].accent }}
                />
                {themes[themeName].name}
                <ChevronDown
                    size={12}
                    className={`transition-transform ${open ? "rotate-180" : ""}`}
                />
            </button>

            {open && (
                <div className="absolute top-full left-0 mt-1.5 !w-52 rounded-3xl bg-[#1a1a1a] overflow-hidden">
                    <div className="max-h-200 overflow-y-auto p-1.5">
                        {(Object.keys(themes) as ThemeName[]).map((name) => (
                            <button
                                key={name}
                                onClick={() => {
                                    setTheme(name);
                                    // setOpen(false);
                                }}
                                className={`w-full flex items-center gap-2.5 px-3 h-9 text-xs transition-all hover:bg-white/5 rounded-full ${
                                    themeName === name
                                        ? "text-white bg-white/10"
                                        : "text-white/50"
                                }`}
                            >
                                <span
                                    className="w-2.5 h-2.5 rounded-full shrink-0 border"
                                    style={{ background: themes[name].accent }}
                                />
                                {themes[name].name}
                                {themeName === name && (
                                    <span className="ml-auto text-white opacity-70">
                                        <Check className="size-3" />
                                    </span>
                                )}
                            </button>
                        ))}
                    </div>
                </div>
            )}
        </div>
    );
}
