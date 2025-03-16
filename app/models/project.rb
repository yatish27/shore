class Project < ApplicationRecord
  belongs_to :team

  validates :name, presence: true
  validates :budget, numericality: { greater_than_or_equal_to: 0 }

  # Authorization relationships
  has_many :authorization_tuples, -> { where(namespace: "project") },
    foreign_key: :object_id, primary_key: :id do
    def with_relation(relation)
      where(relation: relation)
    end
  end

  # Helper methods for managing permissions
  def add_viewer(user)
    Authorization.add_relation(self, :viewer, user)
  end

  def add_contributor(user)
    Authorization.add_relation(self, :contributor, user)
  end

  def add_manager(user)
    Authorization.add_relation(self, :manager, user)
  end

  def set_team(team)
    Authorization.add_relation(self, :team, team)
  end

  def remove_viewer(user)
    Authorization.remove_relation(self, :viewer, user)
  end

  def remove_contributor(user)
    Authorization.remove_relation(self, :contributor, user)
  end

  def remove_manager(user)
    Authorization.remove_relation(self, :manager, user)
  end

  def remove_team(team)
    Authorization.remove_relation(self, :team, team)
  end

  # Helper methods for checking permissions
  def viewable_by?(user)
    Authorization.check(user, :view, self)
  end

  def contributable_by?(user)
    Authorization.check(user, :contribute, self)
  end

  def manageable_by?(user)
    Authorization.check(user, :manage, self)
  end

  def expenses_approvable_by?(user)
    Authorization.check(user, :approve_expenses, self)
  end
end
