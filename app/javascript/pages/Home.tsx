import AppLogo from "@/components/app-logo";

interface HomeProps {
  versions: Record<string, string>;
}

export default function Home({ versions }: HomeProps) {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center">
      <div className="max-w-md w-full">
        <div className="flex items-center justify-center gap-3 mb-8">
          <AppLogo width={48} height={48} />
          <h1 className="text-3xl font-bold text-gray-900">Shore</h1>
        </div>

        <div className="bg-white rounded-lg shadow p-6 space-y-4">
          {Object.entries(versions).map(([name, version]) => (
            <div
              key={name}
              className="flex justify-between items-baseline border-b border-gray-100 pb-3 last:border-0 last:pb-0"
            >
              <span className="text-sm font-medium text-gray-500 capitalize">
                {name}
              </span>
              <span className="text-sm text-gray-900 font-mono">{version}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
