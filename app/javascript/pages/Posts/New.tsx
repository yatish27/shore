import { Link, useForm } from "@inertiajs/react";

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

        <div className="bg-white rounded-lg shadow p-8">
          <h1 className="text-2xl font-bold text-gray-900 mb-6">New Post</h1>

          <form onSubmit={handleSubmit} className="space-y-6">
            <div>
              <label
                htmlFor="title"
                className="block text-sm font-medium text-gray-700 mb-1"
              >
                Title
              </label>
              <input
                id="title"
                type="text"
                value={form.data.title}
                onChange={(e) => form.setData("title", e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 text-sm"
              />
              {fieldErrors?.title && (
                <p className="mt-1 text-sm text-red-600">
                  {Array.isArray(fieldErrors.title)
                    ? fieldErrors.title[0]
                    : fieldErrors.title}
                </p>
              )}
            </div>

            <div>
              <label
                htmlFor="body"
                className="block text-sm font-medium text-gray-700 mb-1"
              >
                Body
              </label>
              <textarea
                id="body"
                rows={8}
                value={form.data.body}
                onChange={(e) => form.setData("body", e.target.value)}
                className="w-full px-3 py-2 border border-gray-300 rounded-lg shadow-sm focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 text-sm"
              />
              {fieldErrors?.body && (
                <p className="mt-1 text-sm text-red-600">
                  {Array.isArray(fieldErrors.body)
                    ? fieldErrors.body[0]
                    : fieldErrors.body}
                </p>
              )}
            </div>

            <div className="flex items-center gap-3">
              <button
                type="submit"
                disabled={form.processing}
                className="inline-flex items-center px-4 py-2 bg-indigo-600 text-white text-sm font-medium rounded-lg hover:bg-indigo-700 transition-colors disabled:opacity-50"
              >
                Create Post
              </button>
              <Link
                href="/posts"
                className="text-sm text-gray-500 hover:text-gray-700 transition-colors"
              >
                Cancel
              </Link>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
