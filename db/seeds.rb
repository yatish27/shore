# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

topics = [
  "Building a REST API with Rails",
  "Understanding React Server Components",
  "PostgreSQL Performance Tuning Tips",
  "Getting Started with Tailwind CSS",
  "Authentication Patterns in Modern Web Apps",
  "Database Indexing Strategies",
  "Deploying Rails to Production",
  "TypeScript Best Practices",
  "Caching Strategies for Web Applications",
  "Writing Effective Integration Tests",
  "CSS Grid vs Flexbox: When to Use Each",
  "Managing State in React Applications",
  "Background Job Processing with Solid Queue",
  "Optimizing Database Queries in Rails",
  "Building Accessible Web Forms",
  "Introduction to WebSockets",
  "Ruby Metaprogramming Essentials",
  "Containerizing Rails Applications",
  "GraphQL vs REST: A Practical Comparison",
  "Monitoring and Observability for Rails"
]

bodies = [
  "In this post, we explore the fundamental concepts and practical applications that every developer should understand. Whether you're just getting started or looking to deepen your knowledge, this guide covers the essentials.\n\nFirst, let's look at the core principles. Understanding the underlying architecture helps you make better decisions when building real-world applications. The patterns we discuss here have been battle-tested in production environments.\n\nKey takeaways include proper error handling, performance considerations, and maintainability. These aren't just theoretical concepts — they're practical skills you'll use every day.",

  "Modern web development moves fast, and keeping up with best practices is essential. This post dives into techniques that have proven their worth in production environments across various scales.\n\nWe'll walk through concrete examples, starting with the basics and building up to more advanced patterns. Each section includes code samples you can adapt for your own projects.\n\nThe goal isn't to be comprehensive — it's to give you a solid foundation that you can build on. Focus on understanding the why behind each decision, not just the how.",

  "Performance matters. Users notice when things are slow, and small improvements can have a big impact on user experience. In this post, we look at practical optimization techniques.\n\nWe start with measurement — you can't improve what you don't measure. Then we move into specific strategies for identifying and resolving bottlenecks.\n\nRemember that premature optimization is the root of all evil. Profile first, optimize second, and always verify your changes with real data.",

  "Security should never be an afterthought. This post covers common vulnerabilities and how to prevent them in your applications.\n\nWe examine real-world examples of security issues and walk through the fixes step by step. The patterns here apply regardless of your specific tech stack.\n\nThe most important principle: never trust user input. Validate everything at the boundary, sanitize where appropriate, and use parameterized queries for all database interactions.",

  "Testing is an investment in confidence. Well-written tests let you refactor fearlessly and deploy with peace of mind. Here's how to write tests that actually provide value.\n\nWe focus on testing behavior, not implementation details. This means your tests remain stable even as you refactor the underlying code.\n\nThe testing pyramid is a useful mental model: many unit tests, fewer integration tests, and a handful of end-to-end tests. Each level serves a different purpose."
]

100.times do |i|
  topic = topics[i % topics.length]
  body = bodies[i % bodies.length]
  number = i + 1

  Post.find_or_create_by!(title: "#{topic} (Part #{number})") do |post|
    post.body = body
  end
end

Rails.logger.info "Seeded #{Post.count} posts."
