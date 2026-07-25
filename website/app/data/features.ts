import {
    Check,
    Cpu,
    Database,
    Search,
    Settings,
    Star,
    Zap,
} from "lucide-react";

export default function () {
    return [
        {
            Icon: Check,
            Title: "Universal Hub",
            Description:
                "A versatile platform designed to manage scripts, tools, and workflows seamlessly.",
        },
        {
            Icon: Search,
            Title: "Smart Search",
            Description:
                "Quickly find scripts, templates, and snippets using advanced filters.",
        },
        {
            Icon: Settings,
            Title: "Customizable UI",
            Description:
                "Tailor themes, layouts, and interface elements to your preferences.",
        },
        {
            Icon: Cpu,
            Title: "TreeGPT AI Assistant",
            Description:
                "Get AI-powered guidance and code suggestions through multiple APIs like ChatGPT, Claude, DeepSeek, and Gemini.",
        },
        {
            Icon: Database,
            Title: "Script Library",
            Description:
                "Organize your scripts into folders and collections for easy access.",
        },
        {
            Icon: Zap,
            Title: "Fast Execution",
            Description:
                "Instantly run scripts with optimized performance and minimal lag.",
        },
        {
            Icon: Star,
            Title: "Favorites & Collections",
            Description:
                "Bookmark scripts or group them into collections for quick retrieval.",
        },
        {
            Icon: Cpu,
            Title: "Advanced Tools",
            Description:
                "Utilize debugging, automation, and code formatting tools built-in.",
        },
    ];
}
