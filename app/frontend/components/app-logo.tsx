import type { SVGAttributes } from "react";

export default function AppLogo(props: SVGAttributes<SVGElement>) {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="80"
      height="80"
      viewBox="0 0 80 80"
      {...props}
    >
      <rect width="80" height="80" rx="16" fill="#6366f1" />
      <text
        x="40"
        y="48"
        fontFamily="sans-serif"
        fontSize="28"
        fontWeight="bold"
        fill="white"
        textAnchor="middle"
      >
        S
      </text>
    </svg>
  );
}
