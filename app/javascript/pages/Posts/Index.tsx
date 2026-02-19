import { Link } from "@inertiajs/react";
import { Plus } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
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

interface IndexProps {
  posts: Post[];
}

export default function Index({ posts }: IndexProps) {
  return (
    <div className="min-h-screen bg-background">
      <div className="max-w-3xl mx-auto px-4 py-12">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-2xl font-bold text-foreground">Posts</h1>
          <Button asChild>
            <Link href="/posts/new">
              <Plus />
              New Post
            </Link>
          </Button>
        </div>

        {posts.length === 0 ? (
          <Card>
            <CardContent className="py-12 text-center">
              <p className="text-muted-foreground text-sm">
                No posts yet. Create your first post to get started.
              </p>
            </CardContent>
          </Card>
        ) : (
          <div className="space-y-4">
            {posts.map((post) => (
              <Link
                key={post.id}
                href={`/posts/${post.id}`}
                className="block rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background"
              >
                <Card className="transition-shadow hover:shadow-md">
                  <CardHeader>
                    <CardTitle>{post.title}</CardTitle>
                    <CardDescription className="line-clamp-2">
                      {post.body}
                    </CardDescription>
                  </CardHeader>
                  <CardContent>
                    <time className="text-xs text-muted-foreground">
                      {new Date(post.created_at).toLocaleDateString("en-US", {
                        year: "numeric",
                        month: "long",
                        day: "numeric",
                      })}
                    </time>
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
