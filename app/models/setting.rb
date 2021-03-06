class Setting < ApplicationRecord
  validates :name, presence: true
  validate :special_settings

  default_scope { order(:name) }
  scope :editable, -> { where(editable: true) }

  before_create :set_slug
  before_update :set_slug

  def self.of(slug)
    find_by(slug: slug)
  end

  private

  def set_slug
    self.slug = name.downcase.gsub(/\W/, '_').gsub(/__/, '_').gsub(/(^_|_$)/, '')
  end

  def special_settings
    # allow blank
    # TODO: this is a mess
    blankable_settings = /Custom CSS|Footer Show|Header Show|Rel Me|Site Title|Site Description|Public Key|Keybase Proof|Syndication|Google Site Verification|Home Page/

    return true if name&.match?(blankable_settings)

    # only one of three values
    if name == 'Text Direction'
      errors.add(:content, "must be 'ltr' (left to right) or 'rtl' (right to left) or 'auto'") unless /ltr|rtl|auto/i.match?(content)
    elsif content.blank?
      errors.add(:content, 'can not be blank')
    end
  end
end
