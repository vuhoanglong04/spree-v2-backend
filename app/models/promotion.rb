class Promotion < ApplicationRecord
  enum :promotion_type, { percentage: 0, fixed: 1 }
end
