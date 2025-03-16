class Folder < ApplicationRecord
  belongs_to :parent, class_name: "Folder", optional: true
  has_many :children, class_name: "Folder", foreign_key: :parent_id, dependent: :destroy
  has_many :documents, dependent: :destroy

  validates :name, presence: true

  # Authorization relationships
  has_many :authorization_tuples, -> { where(namespace: "folder") },
    foreign_key: :object_id, primary_key: :id do
    def with_relation(relation)
      where(relation: relation)
    end
  end

  # Helper methods for managing permissions
  def add_viewer(user)
    Authorization.add_relation(self, :viewer, user)
  end

  def add_editor(user)
    Authorization.add_relation(self, :editor, user)
  end

  def add_owner(user)
    Authorization.add_relation(self, :owner, user)
  end

  def add_admin(user)
    Authorization.add_relation(self, :admin, user)
  end

  def remove_viewer(user)
    Authorization.remove_relation(self, :viewer, user)
  end

  def remove_editor(user)
    Authorization.remove_relation(self, :editor, user)
  end

  def remove_owner(user)
    Authorization.remove_relation(self, :owner, user)
  end

  def remove_admin(user)
    Authorization.remove_relation(self, :admin, user)
  end

  # Helper methods for checking permissions
  def viewable_by?(user)
    Authorization.check(user, :view, self)
  end

  def editable_by?(user)
    Authorization.check(user, :edit, self)
  end

  def admin_by?(user)
    Authorization.check(user, :admin, self)
  end

  def document_creatable_by?(user)
    Authorization.check(user, :create_document, self)
  end
end
