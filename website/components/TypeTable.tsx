"use client";

import {
    Popover,
    PopoverContent,
    PopoverTrigger,
} from "@/components/ui/popover";
import { ChevronDown } from "lucide-react";
import { useState, type ReactNode } from "react";

type ArgType = {
    description?: ReactNode;
    type: string;
};

type FunctionType = {
    type: "function" | string;
    description?: ReactNode;
    args?: Record<string, ArgType>;
    returns?: string;
    required?: boolean;
    default?: string;
};

type TableDataItem = {
    name: string;
    type: string;
    description?: string;
    default?: string;
};

type TypeTableProps = {
    type?: Record<string, FunctionType>;
    data?: TableDataItem[];
};

export default function TypeTable({ type, data }: TypeTableProps) {
    // If data is provided, convert it to type format
    if (data && !type) {
        type = {};
        data.forEach((item) => {
            type![item.name] = {
                type: item.type,
                description: item.description,
                required: false,
                default: item.default,
            };
        });
    }
    const [isExpanded, setIsExpanded] = useState(false);

    const FuncColor = "text-[#6F42C1] dark:text-[#B392F0]";
    const ArgColor = "text-[#E64553] dark:text-[#EBA0AC]";
    const TypeColor = "text-[#DF8E1D] dark:text-[#F9E2AF]";
    const DelimColor = "text-[#ABB2BF] dark:text-[#ABB2BF]";

    const renderArg = (argName: string, argData: ArgType) => {
        const showPopover = argData.description && !argName.startsWith(":");

        const argContent = (
            <>
                <span className={ArgColor}>{argName}</span>
                <span className={DelimColor}>: </span>
                <span className={TypeColor}>{argData.type}</span>
            </>
        );

        if (!showPopover) {
            return <span className="">{argContent}</span>;
        }

        return (
            <Popover>
                <PopoverTrigger asChild>
                    <button className="hover:underline cursor-pointer bg-[#E64553]/10 dark:bg-[#EBA0AC]/10 rounded-md px-1">
                        {argContent}
                    </button>
                </PopoverTrigger>
                <PopoverContent
                    align="start"
                    className="w-90 sm:w-110 p-3  dark:border dark:border-white/10"
                >
                    <div className="space-y-2">
                        <p className="font-mono text-[13px]">{argContent}</p>
                        {argData.description && (
                            <div className="text-sm space-y-2">
                                {argData.description}
                            </div>
                        )}
                    </div>
                </PopoverContent>
            </Popover>
        );
    };

    const renderFunction = (key: string, value: FunctionType) => {
        const hasArgs = value.args && Object.keys(value.args).length > 0;
        const isFunction = value.type === "function";

        const itemName = key.startsWith(":") ? (
            <>
                <span className={DelimColor}>:</span>
                <span className={FuncColor}>{key.slice(1)}</span>
            </>
        ) : (
            <span className={FuncColor}>{key}</span>
        );

        const itemContent = value.description ? (
            <Popover>
                <PopoverTrigger asChild>
                    <button className="hover:underline cursor-pointer bg-[#6F42C1]/10 dark:bg-[#B392F0]/10 rounded-md px-1">
                        {itemName}
                    </button>
                </PopoverTrigger>
                <PopoverContent
                    align="start"
                    className="w-96 p-3 dark:border dark:border-white/10"
                >
                    <div className="space-y-3">
                        <div className="font-mono text-[13px]">
                            {itemName}
                            {isFunction ? (
                                <>
                                    <span className={DelimColor}>(</span>
                                    {hasArgs &&
                                        Object.entries(value.args!).map(
                                            ([argName, argData], idx) => (
                                                <span key={argName}>
                                                    <span className={ArgColor}>
                                                        {argName}
                                                    </span>
                                                    <span
                                                        className={DelimColor}
                                                    >
                                                        :{" "}
                                                    </span>
                                                    <span className={TypeColor}>
                                                        {argData.type}
                                                    </span>
                                                    {idx <
                                                        Object.keys(value.args!)
                                                            .length -
                                                            1 && (
                                                        <span
                                                            className={
                                                                DelimColor
                                                            }
                                                        >
                                                            ,{" "}
                                                        </span>
                                                    )}
                                                </span>
                                            ),
                                        )}
                                    <span className={DelimColor}>)</span>
                                    {value.returns && (
                                        <>
                                            <span className={DelimColor}>
                                                :{" "}
                                            </span>
                                            <span className={TypeColor}>
                                                {value.returns}
                                            </span>
                                        </>
                                    )}
                                </>
                            ) : (
                                <>
                                    <span className={DelimColor}>: </span>
                                    <span className={TypeColor}>
                                        {value.type}
                                    </span>
                                    {value.required && (
                                        <span className={ArgColor}>
                                            {" "}
                                            (required)
                                        </span>
                                    )}
                                </>
                            )}
                        </div>
                        <div className="text-sm space-y-2">
                            {value.description}
                        </div>
                    </div>
                </PopoverContent>
            </Popover>
        ) : (
            <span className="rounded-md px-1">{itemName}</span>
        );

        return (
            <>
                {itemContent}
                {isFunction ? (
                    <>
                        <span className={DelimColor}>(</span>
                        {hasArgs &&
                            Object.entries(value.args!).map(
                                ([argName, argData], idx) => (
                                    <span key={argName}>
                                        {renderArg(argName, argData)}
                                        {idx <
                                            Object.keys(value.args!).length -
                                                1 && (
                                            <span className={DelimColor}>
                                                ,{" "}
                                            </span>
                                        )}
                                    </span>
                                ),
                            )}
                        <span className={DelimColor}>)</span>
                        {value.returns && (
                            <>
                                <span className={DelimColor}>: </span>
                                <span className={TypeColor}>
                                    {value.returns}
                                </span>
                            </>
                        )}
                        {value.required && (
                            <span className={ArgColor}> required</span>
                        )}
                    </>
                ) : (
                    <>
                        <span className={DelimColor}>: </span>
                        <span className={TypeColor}>{value.type}</span>
                        {value.required && (
                            <span className={ArgColor}> required</span>
                        )}
                    </>
                )}
            </>
        );
    };

    return (
        <div className="dark:bg-white/5 bg-white border border-black/10 dark:border-0 flex flex-col rounded-[24px] overflow-hidden">
            <button
                onClick={() => setIsExpanded(!isExpanded)}
                className="flex flex-row items-center gap-2 px-4 h-10 text-left hover:opacity-80 transition-opacity"
            >
                <ChevronDown
                    size={18}
                    className={`transition-transform duration-300 opacity-70 ${
                        isExpanded ? "rotate-180" : ""
                    }`}
                />
                <span className="text-sm font-semibold">
                    {isExpanded ? "Hide" : "Show"} Details
                </span>
            </button>

            <div
                className={`overflow-hidden transition-all duration-300 ease-in-out ${
                    isExpanded ? "max-h-500" : "max-h-0"
                }`}
            >
                <div className="border-t border-black/10 dark:border-black p-2.5 flex flex-col gap-1.5">
                    <div className="w-full flex flex-row items-center justify-between gap-6 px-2 py-1">
                        <span className="text-[13px] font-mono whitespace-nowrap">
                            Name
                        </span>
                        {((type &&
                            Object.values(type).some((v) => v.default)) ||
                            (data && data.some((v) => v.default))) && (
                            <span className="text-[13px] font-mono whitespace-nowrap">
                                Default
                            </span>
                        )}
                    </div>

                    {type &&
                        Object.entries(type).map(([key, value]) => (
                            <div
                                key={key}
                                className="flex flex-row items-center justify-between gap-6"
                            >
                                <span className="text-[13px] font-mono whitespace-nowrap pr-2.5">
                                    {renderFunction(key, value)}
                                </span>
                                {value.default && (
                                    <span className="text-sm opacity-60 font-mono">
                                        {value.default}
                                    </span>
                                )}
                            </div>
                        ))}
                </div>
            </div>
        </div>
    );
}
