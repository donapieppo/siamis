module HomeHelper
  def home_section(id)
    content_tag(:div, class: 'home_section') do
      content_tag(:div, class: 'container', id: id) do
        render partial: id
      end + link_to_top
    end 
  end

  def link_to_top
    content_tag :div, style: 'text-align: right; margin-right: 10px' do
      link_to icon('angle-up', size: '32'), '#top', class: 'link_to_top'
    end
  end

  def home_program_title(what, icon = nil)
    %Q|
    <div class="centered">
      <span class="fa-stack fa-lg" style="margin-top: 20px; font-size: 60px; border-radius: 50%; border: 3px solid;">
        <i class="fa fa-#{icon} fa-stack-1x"></i>
      </span>
    </div>
    <h2>#{what}</h2>|.html_safe
  end

  def conference_home_title
    %Q|<h1 class="home_header_title">
      <span>SIAM Conference on</span> <br/>
      <span>IMAGING SCIENCE</span><br/>
      <div class="home_header_title-date">
        <span>June 5-8, 2018</span><br/> 
        <span> Bologna - Italy</span>
      </div>
    </h1>|.html_safe
  end
end

