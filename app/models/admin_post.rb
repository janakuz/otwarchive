class AdminPost < ActiveRecord::Base
  acts_as_commentable

  attr_protected :content_sanitizer_version
  before_save :update_sanitizer_version
  def update_sanitizer_version
    content_sanitizer_version = ArchiveConfig.SANITIZER_VERSION
  end
  
  validates_presence_of :title
  validates_length_of :title,
    :minimum => ArchiveConfig.TITLE_MIN,
    :too_short=> t('title_too_short', :default => "must be at least %{min} letters long.", :min => ArchiveConfig.TITLE_MIN)

  validates_length_of :title,
    :maximum => ArchiveConfig.TITLE_MAX,
    :too_long=> t('title_too_long', :default => "must be less than %{max} letters long.", :max => ArchiveConfig.TITLE_MAX)
  
  validates_presence_of :content
  validates_length_of :content, :minimum => ArchiveConfig.CONTENT_MIN, 
    :too_short => t('content_too_short', :default => "must be at least %{min} letters long.", :min => ArchiveConfig.CONTENT_MIN)

  validates_length_of :content, :maximum => ArchiveConfig.CONTENT_MAX, 
    :too_long => t('content_too_long', :default => "cannot be more than %{max} characters long.", :max => ArchiveConfig.CONTENT_MAX)
  
  # Return the name to link comments to for this object
  def commentable_name
    self.title
  end
  def commentable_owners
    begin
        [Admin.find(self.admin_id)]
    rescue
      []
    end
  end

end
