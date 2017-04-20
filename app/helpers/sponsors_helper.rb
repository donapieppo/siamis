module SponsorsHelper
  def sponsor_div(name, url, image)
    content_tag :div, class: "sponsor" do 
      link_to url, target: "_new" do 
        "<h4>#{name}</h4>".html_safe +
        content_tag(:div, image_tag("sponsors/#{image}"))
      end
    end
  end
end
