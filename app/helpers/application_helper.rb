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
  
  def markdown(text)
    options = {
      filter_html:     true,
      hard_wrap:       true,
      link_attributes: { rel: 'nofollow', target: "_blank" },
      space_after_headers: true,
      fenced_code_blocks: true
    }

    extensions = {
      autolink:           true,
      superscript:        true,
      disable_indented_code_blocks: true,
      tables: true,
      underline: true,
      highlight: true,
      strikethrough: true
    }

    renderer = Redcarpet::Render::HTML.new(options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end
  
  def other_users
    g = User.all.reject{|user| @wiki.users.include?(user) || user == current_user}
  end
  
end
