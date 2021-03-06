class Project < ApplicationRecord
  is_impressionable

  # Associations
  belongs_to :user
  has_many :participations, dependent: :destroy
  has_many :contributions, dependent: :nullify
  has_many :questions, dependent: :destroy

  # Validations
  validates :title, presence: true
  validates :end_date, presence: true
  validates :max_participations, presence: true
  validates :category, presence: true
  validates :goal, presence: true
  validates :what_company_looking_for, presence: true
  validates :benefit_to_candidate, presence: true
  # validate :time_valid

  # Possible categories for projects
  CATEGORIES = ['Audio',
                'Accounting',
                'Business Development',
                'Creative Arts',
                'Design',
                'Marketing',
                'Public Relations',
                'Finance',
                'Human Resources',
                'Social Media',
                'Software Development',
                'Translation',
                'Education',
                'Video',
                'Photo',
                'Product development',
                'Sales',
                'Web Development',
                'Writing'
              ]

  def project_open?
    days_left > 0
  end

  def self.expired_projects
    where('end_date < ?', Date.today).order(:end_date)
  end

  def days_left
    days_left = (self.end_date.to_date - DateTime.now.to_date).to_i
  end

  def spaces_left
    space_left = (self.max_participations - self.participations.count).to_i
  end

  # def self.number_participations
  #   Project.participations.countorder(:participations)
  # end

  # Returns the questions asked on a project sorted from newest to oldest
  def sorted_questions
    self.questions.sort_by { |q| q.updated_at }.reverse
  end

  def similar_projects
    category = self.category
    similar_projects = Project.where(category: category)
    return similar_projects.to_a - [self]
  end

  # Returns the number of contributions to a project that are starred
  def count_starred_contributions
    self.contributions.select { |c| c.starred }.count
  end

  private

  def time_valid
    if self.end_date <= DateTime.now
      errors.add(:end_date, "can't be in the past")
    end
  end
end
