"use client";

import Spring from "@/app/data/Spring";
import { useRef, useState } from "react";

export default function TopbarButton({
    children,
    onClick,
    isScrolled,
    className,
    scaleOnHold = 1.15,
    brightnessOnHold = 220,
    stretchOnDrag = true,
    ref,
}: {
    children: React.ReactNode;
    onClick?: () => void;
    isScrolled: boolean;
    className?: string;
    scaleOnHold?: number;
    brightnessOnHold?: number;
    stretchOnDrag?: boolean;
    ref?: any;
}) {
    const [IsHolding, SetIsHolding] = useState(false);
    const [Scale, SetScale] = useState({ X: 1, Y: 1 });
    const [Offset, SetOffset] = useState({ X: 0, Y: 0 });
    const [IsReleasing, SetIsReleasing] = useState(false);

    const Start = useRef({ X: 0, Y: 0 });
    const RectRef = useRef({ W: 1, H: 1 });

    const SoftClamp = (V: number, Limit: number) => {
        const Sign = V > 0 ? 1 : -1;
        const Abs = Math.abs(V);
        return Sign * Limit * (1 - Math.exp(-Abs / Limit));
    };

    const EaseIn = (D: number) => {
        const Abs = Math.abs(D);
        const K = 0.0024;
        return 1 + (1 - Math.exp(-Abs * K));
    };

    const OnDown = (E: React.PointerEvent) => {
        SetIsHolding(true);
        Start.current = { X: E.clientX, Y: E.clientY };
        E.currentTarget.setPointerCapture(E.pointerId);

        const Rect = (
            E.currentTarget as HTMLDivElement
        ).getBoundingClientRect();

        RectRef.current = {
            W: Rect.width | 0,
            H: Rect.height | 0,
        };
    };

    const OnMove = (E: React.PointerEvent) => {
        if (!IsHolding) return;

        if (!stretchOnDrag) return;

        const Dx = E.clientX - Start.current.X;
        const Dy = E.clientY - Start.current.Y;

        const AbsX = Math.abs(Dx);
        const AbsY = Math.abs(Dy);
        const Total = Math.max(AbsX + AbsY, 1);

        const WeightX = AbsX / Total;
        const WeightY = AbsY / Total;

        const Ease = (D: number) => {
            const Abs = Math.abs(D);
            const K = 0.0029;
            const T = 1 - Math.exp(-Abs * K);
            return 1 + T * T * 0.9;
        };

        const RawX = Ease(Dx);
        const RawY = Ease(Dy);

        const GrowX = (RawX - 1) * WeightX;
        const GrowY = (RawY - 1) * WeightY;

        const ShrinkFactor = 0.02;

        const MaxStretch = 0.28;
        const SoftStretch = (V: number) =>
            MaxStretch * (1 - Math.exp(-V / MaxStretch));

        const ScaleX = 1 + SoftStretch(GrowX) - GrowY * ShrinkFactor * 0.5;
        const ScaleY = 1 + SoftStretch(GrowY) - GrowX * ShrinkFactor * 0.5;

        SetScale({
            X: Math.max(0.92, ScaleX),
            Y: Math.max(0.92, ScaleY),
        });

        const BaseOffsetX = Dx * 0.1;
        const BaseOffsetY = Dy * 0.1;

        const CompensationX = GrowX * Dx * 0.5;
        const CompensationY = GrowY * Dy * 0.5;

        const W = RectRef.current.W;
        const H = RectRef.current.H;

        const RatioX = W > H ? W / H : 1;
        const RatioY = H > W ? H / W : 1;

        const RawOffsetX = (BaseOffsetX + CompensationX) * (RatioX * 0.2);
        const RawOffsetY = (BaseOffsetY + CompensationY) * (RatioY * 0.2);

        const MaxOffset = 23;
        const SoftClamp = (V: number, Limit: number) => {
            const Sign = V > 0 ? 1 : -1;
            return Sign * Limit * (1 - Math.exp(-Math.abs(V) / Limit));
        };

        SetOffset({
            X: SoftClamp(RawOffsetX, MaxOffset),
            Y: SoftClamp(RawOffsetY, MaxOffset),
        });
    };

    const OnUp = (E: React.PointerEvent) => {
        SetIsHolding(false);
        SetIsReleasing(true);

        SetScale({ X: 1, Y: 1 });
        SetOffset({ X: 0, Y: 0 });

        setTimeout(() => {
            SetIsReleasing(false);
        }, 250);

        E.currentTarget.releasePointerCapture(E.pointerId);
    };

    return (
        <div
            className={`flex items-center gap-4 justify-center touch-none select-none cursor-pointer ${className ?? ""}`}
            style={{
                opacity: isScrolled ? 1 : 0,

                transform: `
                    ${isScrolled ? "translateY(0)" : "translateY(-16px)"}
                    translate(${Offset.X}px, ${Offset.Y}px)
                    scale(${IsHolding ? scaleOnHold : 1}, ${IsHolding ? scaleOnHold : 1})
                    scale(${Scale.X}, ${Scale.Y})
                `,

                filter: `brightness(${IsHolding ? brightnessOnHold : 100}%)`,

                transition: `
                    opacity 1.2s ${Spring},
                    transform ${IsHolding ? ".5s" : IsReleasing ? "0.7s" : "0.4s"} ${Spring},
                    filter 0.3s ease
                `,
            }}
            onPointerDown={OnDown}
            onPointerMove={OnMove}
            onPointerUp={OnUp}
            onPointerCancel={OnUp}
            onClick={onClick}
            ref={ref}
        >
            {children}
        </div>
    );
}
