import clsx from "clsx";
import { useTheme } from "../context/ThemeContext";
import { ReactNode, useState } from "react";
import { colorWithOpacity } from "../resolveTheme";

interface SidebarProps {
    children?: ReactNode;
    className?: string;
}

export function Sidebar({ children, className }: SidebarProps) {
    return (
        <div className={clsx("flex flex-col px-[7px] w-[200px]", className)}>
            {children}
        </div>
    );
}

export function SidebarTab({ children, className }: SidebarProps) {
    const { resolved } = useTheme();
    const [hovered, setHovered] = useState(false);
    const [active, setActive] = useState(false);

    const bg = active
        ? colorWithOpacity(
              resolved.TabBackgroundActive,
              resolved.TabBackgroundActiveOpacity,
          )
        : hovered
          ? colorWithOpacity(
                resolved.TabBackgroundHover,
                resolved.TabBackgroundHoverOpacity,
            )
          : "transparent";

    const opacity = active ? 1 : 0.6;

    return (
        <div
            className={clsx(
                "flex flex-row items-center px-[11px] py-[7px] gap-[10px] rounded-[9px] transition-colors duration-150 cursor-pointer",
                className,
            )}
            style={{ background: bg, opacity: opacity }}
            onMouseEnter={() => setHovered(true)}
            onMouseLeave={() => setHovered(false)}
            onMouseDown={() => setActive(true)}
            onMouseUp={() => setActive(false)}
        >
            {children}
        </div>
    );
}

export function SidebarTabTitle({ children, className }: SidebarProps) {
    return (
        <div className={clsx("text-[14px] font-medium", className)}>
            {children}
        </div>
    );
}
