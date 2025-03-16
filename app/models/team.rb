class Team < ApplicationRecord
  belongs_to :organization
  has_many :projects

  validates :name, presence: true

  # Authorization relationships
  has_many :authorization_tuples, -> { where(namespace: "team") },
    foreign_key: :object_id, primary_key: :id do
    def with_relation(relation)
      where(relation: relation)
    end
  end

  # Helper methods for managing permissions
  def add_member(user)
    Authorization.add_relation(self, :member, user)
  end

  def add_admin(user)
    Authorization.add_relation(self, :admin, user)
  end

  def set_organization(organization)
    Authorization.add_relation(self, :organization, organization)
  end

  def remove_member(user)
    Authorization.remove_relation(self, :member, user)
  end

  def remove_admin(user)
    Authorization.remove_relation(self, :admin, user)
  end

  def remove_organization(organization)
    Authorization.remove_relation(self, :organization, organization)
  end

  # Helper methods for checking permissions
  def viewable_by?(user)
    Authorization.check(user, :view, self)
  end

  def manageable_by?(user)
    Authorization.check(user, :manage, self)
  end

  def tasks_assignable_by?(user)
    Authorization.check(user, :assign_tasks, self)
  end
end
