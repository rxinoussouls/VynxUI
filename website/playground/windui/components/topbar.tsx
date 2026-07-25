import clsx from "clsx";
import { ReactNode, forwardRef, useState } from "react";
import { useTheme } from "../context/ThemeContext";

interface TopbarProps {
    children?: ReactNode;
    className?: string;
}

interface TopbarLeftProps {
    children?: ReactNode;
    className?: string;
}

interface TopbarLeftTextsProps {
    children?: ReactNode;
    className?: string;
}

export const Topbar = forwardRef<HTMLDivElement, TopbarProps>(
    ({ children, className }, ref) => (
        <div
            ref={ref}
            className={clsx(
                "flex flex-row justify-between items-center p-[6px]",
                className,
            )}
        >
            {children}
        </div>
    ),
);

export function TopbarLeft({ children, className }: TopbarLeftProps) {
    return (
        <div
            className={clsx(
                "flex flex-row gap-[18px] items-center p-[12px]",
                className,
            )}
        >
            {children}
        </div>
    );
}

export function TopbarLeftTexts({ children, className }: TopbarLeftTextsProps) {
    return (
        <div
            className={clsx(
                "flex flex-col space-y-[-2px] justify-center",
                className,
            )}
        >
            {children}
        </div>
    );
}

export function TopbarLeftTextsTitle({
    children,
    className,
}: TopbarLeftTextsProps) {
    const { resolved } = useTheme();

    return (
        <p
            style={{ color: resolved?.WindowTopbarTitle }}
            className={clsx("text-[14px] font-semibold", className)}
        >
            {children}
        </p>
    );
}

export function TopbarLeftTextsAuthor({
    children,
    className,
}: TopbarLeftTextsProps) {
    const { resolved } = useTheme();

    return (
        <p
            style={{ color: resolved?.WindowTopbarAuthor }}
            className={clsx("text-[11px] font-medium opacity-65", className)}
        >
            {children}
        </p>
    );
}

export function TopbarRight({ children, className }: TopbarLeftTextsProps) {
    const { theme } = useTheme();

    return (
        <div
            className={clsx(
                "flex flex-row items-center gap-2.25 h-full w-auto justify-end",
                className,
            )}
        >
            {children}
        </div>
    );
}

export function TopbarRightButton({
    children,
    className,
}: TopbarLeftTextsProps) {
    const { resolved } = useTheme();
    const [hovered, setHovered] = useState(false);

    return (
        <div
            style={{
                background: hovered
                    ? `color-mix(in srgb, ${resolved?.TabBackgroundHover} 7%, transparent)`
                    : "transparent",
            }}
            onMouseEnter={() => setHovered(true)}
            onMouseLeave={() => setHovered(false)}
            className={clsx(
                "h-9.5 w-9.5! transition-colors duration-100 flex flex-row items-center justify-center rounded-[10px] cursor-pointer active:scale-90 transition-transform duration-100",
                className,
            )}
        >
            {children}
        </div>
    );
}
