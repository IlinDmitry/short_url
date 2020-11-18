class Url < ApplicationRecord
  validates_presence_of :original_url
  validates_uniqueness_of :short_url

  before_create :set_short_url

  def set_short_url
    self.short_url = SecureRandom.alphanumeric(10) unless short_url.present?
  end

  def increase_stats!
    with_lock do
      self.stats += 1
      save!
      Rails.cache.write(short_url, self.stats)
    end
  end

  def self.get_stats(short_url)
    Rails.cache.fetch(short_url) do
      url = find_by(short_url: short_url)
      return url.stats if url.present?

      0
    end
  end
end
