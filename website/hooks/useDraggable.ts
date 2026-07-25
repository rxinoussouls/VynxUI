import { useRef, useState, useEffect } from "react";

export function useDraggable() {
    const [position, setPosition] = useState({ x: 0, y: 0 });
    const dragStart = useRef<{ x: number; y: number } | null>(null);
    const ref = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const el = ref.current;
        if (!el) return;

        // Mouse
        const onMouseDown = (e: MouseEvent) => {
            dragStart.current = {
                x: e.clientX - position.x,
                y: e.clientY - position.y,
            };
        };

        const onMouseMove = (e: MouseEvent) => {
            if (!dragStart.current) return;
            setPosition({
                x: e.clientX - dragStart.current.x,
                y: e.clientY - dragStart.current.y,
            });
        };

        const onTouchMove = (e: TouchEvent) => {
            if (!dragStart.current) return;
            e.preventDefault();
            const touch = e.touches[0];
            setPosition({
                x: touch.clientX - dragStart.current.x,
                y: touch.clientY - dragStart.current.y,
            });
        };

        const onMouseUp = () => {
            dragStart.current = null;
        };

        // Touch
        const onTouchStart = (e: TouchEvent) => {
            const touch = e.touches[0];
            dragStart.current = {
                x: touch.clientX - position.x,
                y: touch.clientY - position.y,
            };
        };

        const onTouchEnd = () => {
            dragStart.current = null;
        };

        el.addEventListener("mousedown", onMouseDown);
        el.addEventListener("touchstart", onTouchStart, { passive: true });
        window.addEventListener("mousemove", onMouseMove);
        window.addEventListener("touchmove", onTouchMove, { passive: false }); // passive: false нужен для e.preventDefault()
        window.addEventListener("mouseup", onMouseUp);
        window.addEventListener("touchend", onTouchEnd);

        return () => {
            el.removeEventListener("mousedown", onMouseDown);
            el.removeEventListener("touchstart", onTouchStart);
            window.removeEventListener("mousemove", onMouseMove);
            window.removeEventListener("touchmove", onTouchMove);
            window.removeEventListener("mouseup", onMouseUp);
            window.removeEventListener("touchend", onTouchEnd);
        };
    }, [position]);

    return { ref, position };
}
