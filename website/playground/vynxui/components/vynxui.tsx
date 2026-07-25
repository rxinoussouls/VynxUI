import { ReactNode } from "react";

interface WindowProps {
    children?: ReactNode;
}

export function VynxUI({ children }: WindowProps) {
    return (
        <div className="w-full p-4 flex flex-row items-center justify-center select-none">
            {children}
        </div>
    );
}
