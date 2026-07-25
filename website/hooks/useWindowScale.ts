import { useEffect, useState, useRef } from "react";

export function useWindowScale(windowW: number, windowH: number) {
    const containerRef = useRef<HTMLDivElement>(null);
    const [scale, setScale] = useState(1);

    useEffect(() => {
        const calculate = () => {
            const el = containerRef.current;
            if (!el) return;

            const { width, height } = el.getBoundingClientRect();
            const padding = 56;

            const scaleX = (width - padding) / windowW;
            const scaleY = (height - padding) / windowH;

            setScale(Math.min(1, scaleX, scaleY));
        };

        calculate();

        const observer = new ResizeObserver(calculate);
        if (containerRef.current) observer.observe(containerRef.current);

        return () => observer.disconnect();
    }, [windowW, windowH]);

    return { containerRef, scale };
}
