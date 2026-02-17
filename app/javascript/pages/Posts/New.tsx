import { Link, useForm } from "@inertiajs/react";
import { ArrowLeft } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";

interface NewProps {
  errors?: Record<string, string[]>;
}

export default function New({ errors }: NewProps) {
  const form = useForm({
    title: "",
    body: "",
  });

  function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    form.post("/posts");
  }

  const fieldErrors = errors || form.errors;

  return (
    <div className="min-h-screen bg-background">
      <div className="max-w-3xl mx-auto px-4 py-12">
        <div className="mb-6">
          <Button variant="ghost" size="sm" asChild>
            <Link href="/posts">
              <ArrowLeft />
              Back to Posts
            </Link>
          </Button>
        </div>

        <form onSubmit={handleSubmit}>
          <Card>
            <CardHeader>
              <CardTitle className="text-2xl">New Post</CardTitle>
            </CardHeader>

            <CardContent className="space-y-6">
              <div className="space-y-2">
                <Label htmlFor="title">Title</Label>
                <Input
                  id="title"
                  type="text"
                  placeholder="Enter a title for your post"
                  autoFocus
                  value={form.data.title}
                  onChange={(e) => form.setData("title", e.target.value)}
                  aria-invalid={!!fieldErrors?.title}
                  aria-describedby={
                    fieldErrors?.title ? "title-error" : undefined
                  }
                />
                {fieldErrors?.title && (
                  <p
                    id="title-error"
                    role="alert"
                    className="text-sm text-destructive"
                  >
                    {Array.isArray(fieldErrors.title)
                      ? fieldErrors.title[0]
                      : fieldErrors.title}
                  </p>
                )}
              </div>

              <div className="space-y-2">
                <Label htmlFor="body">Body</Label>
                <Textarea
                  id="body"
                  rows={8}
                  placeholder="Write your post content here..."
                  value={form.data.body}
                  onChange={(e) => form.setData("body", e.target.value)}
                  aria-invalid={!!fieldErrors?.body}
                  aria-describedby={
                    fieldErrors?.body ? "body-error" : undefined
                  }
                />
                {fieldErrors?.body && (
                  <p
                    id="body-error"
                    role="alert"
                    className="text-sm text-destructive"
                  >
                    {Array.isArray(fieldErrors.body)
                      ? fieldErrors.body[0]
                      : fieldErrors.body}
                  </p>
                )}
              </div>

              <div className="flex items-center gap-3 pt-6 border-t border-border">
                <Button type="submit" tabIndex={0} disabled={form.processing}>
                  {form.processing ? "Creating..." : "Create Post"}
                </Button>
                <Button variant="ghost" tabIndex={0} asChild>
                  <Link href="/posts">Cancel</Link>
                </Button>
              </div>
            </CardContent>
          </Card>
        </form>
      </div>
    </div>
  );
}
