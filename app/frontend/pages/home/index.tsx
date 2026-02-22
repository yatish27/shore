import AppLogo from "@/components/app-logo";
import { Card, CardContent } from "@/components/ui/card";

interface HomeProps {
  versions: Record<string, string>;
}

export default function Home({ versions }: HomeProps) {
  return (
    <div className="min-h-screen bg-background flex items-center justify-center">
      <div className="max-w-md w-full px-4">
        <div className="flex items-center justify-center gap-3 mb-8">
          <AppLogo width={48} height={48} />
          <h1 className="text-3xl font-bold text-foreground">Shore</h1>
        </div>

        <Card>
          <CardContent className="space-y-4">
            {Object.entries(versions).map(([name, version]) => (
              <div
                key={name}
                className="flex justify-between items-baseline border-b border-border pb-3 last:border-0 last:pb-0"
              >
                <span className="text-sm font-medium text-muted-foreground capitalize">
                  {name}
                </span>
                <span className="text-sm text-foreground font-mono">
                  {version}
                </span>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
