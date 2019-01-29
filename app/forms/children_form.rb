class ChildrenForm < Form
  CHILD_OPTIONS = %w[0 1 2 3]

  set_attributes_for :eitc_estimate, :children

  validates :children, inclusion: { in: CHILD_OPTIONS }

  def save
    record.update(attributes_for(:eitc_estimate))
  end
end