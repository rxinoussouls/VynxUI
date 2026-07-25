"use client";

import "lucide-react";
import { ReactNode } from "react";
import { useTheme } from "../context/ThemeContext";

interface WindowProps {
    position?: { x: number; y: number };
    children?: ReactNode;
    style?: React.CSSProperties;
}

export function Window({ style, position, children }: WindowProps) {
    const { resolved } = useTheme();

    return (
        <div
            style={{
                ...style,
                background: resolved.WindowBackground,
            }}
            className="w-145! h-115 rounded-2xl shadow-2xl shadow-black/35 flex flex-col  shrink-0 origin-center"
        >
            {children}
        </div>
    );
}
