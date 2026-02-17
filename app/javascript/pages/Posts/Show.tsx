import { Link, router } from "@inertiajs/react";

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
    <div className="min-h-screen bg-gray-50">
      <div className="max-w-3xl mx-auto px-4 py-12">
        <div className="mb-6">
          <Link
            href="/posts"
            className="text-sm text-indigo-600 hover:text-indigo-800 transition-colors"
          >
            &larr; Back to Posts
          </Link>
        </div>

        <article className="bg-white rounded-lg shadow p-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-2">
            {post.title}
          </h1>

          <time className="block text-xs text-gray-400 mb-6">
            {new Date(post.created_at).toLocaleDateString("en-US", {
              year: "numeric",
              month: "long",
              day: "numeric",
            })}
          </time>

          <div className="prose prose-gray max-w-none text-gray-700 whitespace-pre-wrap mb-8">
            {post.body}
          </div>

          <div className="pt-6 border-t border-gray-100">
            <button
              onClick={handleDelete}
              className="inline-flex items-center px-4 py-2 bg-red-600 text-white text-sm font-medium rounded-lg hover:bg-red-700 transition-colors"
            >
              Delete
            </button>
          </div>
        </article>
      </div>
    </div>
  );
}
