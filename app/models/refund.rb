class Refund < ApplicationRecord
  enum :status, {
    pending: 0,
    succeeded: 1,
    failed: 2,
    canceled: 3
  }
end
