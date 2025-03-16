namespace :authorization do
  desc "Test the authorization engine with sample data"
  task test: :environment do
    # Clear existing test data
    puts "Clearing existing test data..."
    Document.destroy_all
    # Delete folders in reverse order of depth to handle foreign key constraints
    Folder.where.not(parent_id: nil).order(created_at: :desc).destroy_all
    Folder.destroy_all
    User.destroy_all

    # Create users
    puts "Creating users..."
    admin = User.create!(name: "Admin User")
    editor = User.create!(name: "Editor User")
    viewer = User.create!(name: "Viewer User")
    unrelated = User.create!(name: "Unrelated User")
    puts "Created users: #{User.pluck(:name).join(', ')}"

    # Create folder structure
    puts "Creating folder structure..."
    root_folder = Folder.create!(name: "Root Folder")
    subfolder = Folder.create!(name: "Subfolder", parent: root_folder)
    deep_subfolder = Folder.create!(name: "Deep Subfolder", parent: subfolder)
    puts "Created folders: #{Folder.pluck(:name).join(', ')}"

    # Create documents
    puts "Creating documents..."
    root_doc = Document.create!(name: "Root Document", folder: root_folder)
    sub_doc = Document.create!(name: "Subfolder Document", folder: subfolder)
    deep_doc = Document.create!(name: "Deep Document", folder: deep_subfolder)
    puts "Created documents: #{Document.pluck(:name).join(', ')}"

    # Set up authorization relations
    puts "Setting up authorization relations..."

    # Admin has owner access to root folder
    Authorization.add_relation(root_folder, :owner, admin)
    puts "Added admin as owner of root folder"

    # Editor has editor access to subfolder
    Authorization.add_relation(subfolder, :editor, editor)
    puts "Added editor as editor of subfolder"

    # Viewer has viewer access to deep subfolder
    Authorization.add_relation(deep_subfolder, :viewer, viewer)
    puts "Added viewer as viewer of deep subfolder"

    # Test permission checks
    puts "\nTesting permissions..."

    # Test direct permissions
    puts "\nDirect permission checks:"
    puts "Admin can view root folder: #{Authorization.check(admin, :view, root_folder)}"
    puts "Admin can edit root folder: #{Authorization.check(admin, :edit, root_folder)}"
    puts "Admin can admin root folder: #{Authorization.check(admin, :admin, root_folder)}"

    puts "Editor can view subfolder: #{Authorization.check(editor, :view, subfolder)}"
    puts "Editor can edit subfolder: #{Authorization.check(editor, :edit, subfolder)}"
    puts "Editor can admin subfolder: #{Authorization.check(editor, :admin, subfolder)}"

    puts "Viewer can view deep subfolder: #{Authorization.check(viewer, :view, deep_subfolder)}"
    puts "Viewer can edit deep subfolder: #{Authorization.check(viewer, :edit, deep_subfolder)}"
    puts "Viewer can admin deep subfolder: #{Authorization.check(viewer, :admin, deep_subfolder)}"

    # Test inherited permissions
    puts "\nInherited permission checks:"
    puts "Admin can view subfolder (inherited): #{Authorization.check(admin, :view, subfolder)}"
    puts "Admin can edit subfolder (inherited): #{Authorization.check(admin, :edit, subfolder)}"
    puts "Admin can admin subfolder (inherited): #{Authorization.check(admin, :admin, subfolder)}"

    puts "Admin can view deep subfolder (inherited): #{Authorization.check(admin, :view, deep_subfolder)}"
    puts "Admin can edit deep subfolder (inherited): #{Authorization.check(admin, :edit, deep_subfolder)}"
    puts "Admin can admin deep subfolder (inherited): #{Authorization.check(admin, :admin, deep_subfolder)}"

    puts "Editor can view deep subfolder (inherited): #{Authorization.check(editor, :view, deep_subfolder)}"
    puts "Editor can edit deep subfolder (inherited): #{Authorization.check(editor, :edit, deep_subfolder)}"

    # Test document permissions
    puts "\nDocument permission checks:"
    puts "Admin can view root document: #{Authorization.check(admin, :view, root_doc)}"
    puts "Admin can edit root document: #{Authorization.check(admin, :edit, root_doc)}"
    puts "Admin can delete root document: #{Authorization.check(admin, :delete, root_doc)}"

    puts "Editor can view subfolder document: #{Authorization.check(editor, :view, sub_doc)}"
    puts "Editor can edit subfolder document: #{Authorization.check(editor, :edit, sub_doc)}"
    puts "Editor can delete subfolder document: #{Authorization.check(editor, :delete, sub_doc)}"

    puts "Viewer can view deep document: #{Authorization.check(viewer, :view, deep_doc)}"
    puts "Viewer can edit deep document: #{Authorization.check(viewer, :edit, deep_doc)}"

    # Test negative permissions
    puts "\nNegative permission checks:"
    puts "Unrelated user can view root folder: #{Authorization.check(unrelated, :view, root_folder)}"
    puts "Unrelated user can view subfolder: #{Authorization.check(unrelated, :view, subfolder)}"
    puts "Unrelated user can view deep subfolder: #{Authorization.check(unrelated, :view, deep_subfolder)}"

    puts "Viewer cannot edit root folder: #{!Authorization.check(viewer, :edit, root_folder)}"
    puts "Editor cannot admin root folder: #{!Authorization.check(editor, :admin, root_folder)}"

    puts "\nAuthorization test completed!"
  end
end
