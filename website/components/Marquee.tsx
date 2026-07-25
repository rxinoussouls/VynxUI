interface MarqueeProps {
    children: React.ReactNode;
    speed?: number;
    gap?: number;
    reverse?: boolean;
}

export const Marquee: React.FC<MarqueeProps> = ({
    children,
    speed = 20,
    gap = 8,
    reverse = false,
}) => {
    return (
        <div className="marquee-container">
            <div
                className="marquee-content"
                style={{
                    animationDuration: `${speed}s`,
                    animationDirection: reverse ? "reverse" : "normal",
                    gap: `${gap}px`,
                }}
            >
                <div
                    style={{
                        display: "flex",
                        gap: `${gap}px`,
                        paddingRight: `${gap}px`,
                        flexShrink: 0,
                    }}
                >
                    {children}
                </div>
                <div
                    style={{
                        display: "flex",
                        gap: `${gap}px`,
                        paddingRight: `${gap}px`,
                        flexShrink: 0,
                    }}
                    aria-hidden
                >
                    {children}
                </div>
            </div>
        </div>
    );
};
