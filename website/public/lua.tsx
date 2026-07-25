type LuaIconProps = {
    className?: string;
};

export function LuaIcon({ className }: LuaIconProps) {
    return (
        <svg
            className={className}
            style={{
                width: "1em",
                height: "1em",
                verticalAlign: "middle",
                fill: "currentColor",
                overflow: "hidden",
            }}
            viewBox="0 0 1024 1024"
            version="1.1"
            xmlns="http://www.w3.org/2000/svg"
        >
            <path
                d="M517.418667 240.810667a276.608 272.256 0 0 0-276.565334 272.256 276.608 272.256 0 0 0 276.565334 272.213333 276.608 272.256 0 0 0 276.650666-272.213333 276.608 272.256 0 0 0-276.650666-272.213334z m79.36 81.749333a99.370667 97.792 0 0 1 99.413333 97.834667 99.370667 97.792 0 0 1-99.413333 97.749333 99.370667 97.792 0 0 1-99.370667-97.706667 99.370667 97.792 0 0 1 99.328-97.877333z"
                fill="currentColor"
            />
            <path
                d="M729.557333 192.554667a99.370667 97.792 0 1 0 198.741334 0 99.370667 97.792 0 1 0-198.741334 0Z"
                fill="currentColor"
            />
        </svg>
    );
}
