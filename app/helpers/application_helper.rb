module ApplicationHelper
  def form_group_tag(errors, &block)
    css_class = 'form-group'
    css_class << ' has error' if errors.any?
    content_tag :div, capture(&block), class: css_class
  end
  
  def user_upgrade?
    if current_user.role == "standard"
      return true
    end
  end
  
  def user_downgrade?
    if current_user.role == "premium"
      return true
    end
  end
  
end
