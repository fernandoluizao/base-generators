module <%= layout_name.classify %>Helper
  mattr_accessor :default_secondary_navigation_path
  @@default_secondary_navigation_path = 'common/secondary_navigation'
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end
  def nav_link(title, url, options = {})
    link = link_to(title, url)
    # solo si LockDown me deja!
    unless link.blank?
      # Activo el item? 
      options = params[:controller].include?(options[:controller] || title.underscore) ? {:class => "active"}  : {}
      haml_tag :li, options do
        haml_concat link
      end
    end
  end
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
  def show_content_if(content, &block)
    if content.present?
      yield(content)
    end
  end
  def sidebar_link(name, options = {}, html_options = nil)
    content_tag(:li, link_to(name, options, html_options))
  end
  def navigation_block(nav = nil)
    render(:partial => (nav||@@default_secondary_navigation_path))
  end
  def flashes
    render :partial => 'common/flashes'
  end
  def block(title, options = {}, &block)
    content = capture(&block)
    out = render :partial => 'common/block', :locals => { 
      :title => title, 
      :content => content, 
      :options => options
    }
    out
  end
  def block_form(title, &block)
    content = capture(&block)
    out = render :partial => 'common/block_form', :locals => { :title => title, :content => content}
    out
  end
end
