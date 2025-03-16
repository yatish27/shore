class Document < ApplicationRecord
  belongs_to :folder, optional: true

  validates :name, presence: true

  # Authorization relationships
  has_many :authorization_tuples, -> { where(namespace: "document") },
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

  def add_team(team)
    Authorization.add_relation(self, :team, team)
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

  def remove_team(team)
    Authorization.remove_relation(self, :team, team)
  end

  # Helper methods for checking permissions
  def viewable_by?(user)
    Authorization.check(user, :view, self)
  end

  def editable_by?(user)
    Authorization.check(user, :edit, self)
  end

  def deletable_by?(user)
    Authorization.check(user, :delete, self)
  end

  def commentable_by?(user)
    Authorization.check(user, :comment, self)
  end
end
