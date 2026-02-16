import { Link } from "@inertiajs/react";

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
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-3xl mx-auto px-4 py-12">
        <div className="flex items-center justify-between mb-8">
          <h1 className="text-2xl font-bold text-gray-900">Posts</h1>
          <Link
            href="/posts/new"
            className="inline-flex items-center px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded-lg hover:bg-indigo-700 transition-colors"
          >
            New Post
          </Link>
        </div>

        {posts.length === 0 ? (
          <div className="bg-white rounded-lg shadow p-12 text-center">
            <p className="text-gray-500 text-sm">
              No posts yet. Create your first post to get started.
            </p>
          </div>
        ) : (
          <div className="space-y-4">
            {posts.map((post) => (
              <Link
                key={post.id}
                href={`/posts/${post.id}`}
                className="block bg-white rounded-lg shadow p-6 hover:shadow-md transition-shadow"
              >
                <h2 className="text-lg font-semibold text-gray-900 mb-1">
                  {post.title}
                </h2>
                <p className="text-sm text-gray-600 line-clamp-2 mb-3">
                  {post.body}
                </p>
                <time className="text-xs text-gray-400">
                  {new Date(post.created_at).toLocaleDateString("en-US", {
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })}
                </time>
              </Link>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
