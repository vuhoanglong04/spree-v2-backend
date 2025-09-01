# frozen_string_literal: true

module SerializerConcern
  def confirmed_at
    object&.confirmed_at&.in_time_zone&.strftime("%Y-%m-%d %H:%M:%S")
  end

  def created_at
    object.created_at.in_time_zone.strftime("%Y-%m-%d %H:%M:%S")
  end

  def updated_at
    object.updated_at.in_time_zone.strftime("%Y-%m-%d %H:%M:%S")
  end
end
