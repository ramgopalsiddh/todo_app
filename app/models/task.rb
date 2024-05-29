class Task < ApplicationRecord
    validates_presence_of :description, :due_date, :title
end
