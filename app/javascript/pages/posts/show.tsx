import { Link, router } from "@inertiajs/react";
import { ArrowLeft, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";

interface Post {
  id: string;
  title: string;
  body: string;
  created_at: string;
  updated_at: string;
}

interface ShowProps {
  post: Post;
}

export default function Show({ post }: ShowProps) {
  function handleDelete() {
    if (window.confirm("Are you sure you want to delete this post?")) {
      router.delete(`/posts/${post.id}`);
    }
  }

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

        <Card>
          <CardHeader>
            <CardTitle className="text-2xl">{post.title}</CardTitle>
            <time className="text-xs text-muted-foreground">
              {new Date(post.created_at).toLocaleDateString("en-US", {
                year: "numeric",
                month: "long",
                day: "numeric",
              })}
            </time>
          </CardHeader>

          <CardContent>
            <div className="text-foreground leading-relaxed whitespace-pre-wrap">
              {post.body}
            </div>
          </CardContent>

          <CardFooter className="border-t pt-6">
            <Button variant="destructive" size="sm" onClick={handleDelete}>
              <Trash2 />
              Delete
            </Button>
          </CardFooter>
        </Card>
      </div>
    </div>
  );
}
