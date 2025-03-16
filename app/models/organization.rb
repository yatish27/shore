class Organization < ApplicationRecord
  has_many :teams

  validates :name, presence: true

  # Authorization relationships
  has_many :authorization_tuples, -> { where(namespace: "organization") },
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

  def remove_member(user)
    Authorization.remove_relation(self, :member, user)
  end

  def remove_admin(user)
    Authorization.remove_relation(self, :admin, user)
  end

  # Helper methods for checking permissions
  def viewable_by?(user)
    Authorization.check(user, :view, self)
  end

  def manageable_by?(user)
    Authorization.check(user, :manage, self)
  end

  def joinable_by?(user)
    Authorization.check(user, :join, self)
  end
end
