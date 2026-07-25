import { ReactNode } from "react";
import { HomeLayout } from "fumadocs-ui/layouts/home";
import { baseOptions } from "@/app/layout.config";
import Navbar from "@/components/Navbar";

interface LayoutProps {
    children: ReactNode;
}

export default function Layout({ children }: LayoutProps) {
    const links = baseOptions.links || [];

    return (
        <HomeLayout
            {...baseOptions}
            nav={{
                component: <Navbar links={links} />,
            }}
        >
            {children}
        </HomeLayout>
    );
}
