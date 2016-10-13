module ApplicationHelper

  def form_group_tag(errors, &block)
    #  css_class = 'form-group'
    #  css_class << ' has-error' if errors.any?
    if errors.any?
      content_tag :div, capture(&block), class: 'form-group has-error'
    else
     content_tag :div, capture(&block), class: 'form-group'
    end
  end
end
