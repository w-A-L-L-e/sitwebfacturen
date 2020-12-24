module ApplicationHelper
  
  #this pretties up our show pages (bootstrap does not handle empty strings nicely)
  def s( str )
    if str.blank?
      "&nbsp;".html_safe
    else
      str
    end
  end



  def to_euro( amount )
    number_to_currency(amount, :unit=>'€').to_s
  end

  #def to_euro( amount )
  #  "&euro; ".html_safe+amount.to_s
  #end

  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end



  # allow dynamic add/remove with some jquery code, look in application.js
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + 
      link_to(name, "#", :class => "btn btn-danger link_to_remove_fields" )
  end
  
  def link_to_add_fields(name, f, association)
    new_object = f.object.class.reflect_on_association(association).klass.new
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
      render(association.to_s.singularize + "_fields", :f => builder)
    end

    #we now have: name, fields and association to pass as data entries
    link_to(name, "#", "data-association" => "#{association}" , "data-content" => "#{fields}", :class => "btn btn-primary link_to_add_fields" )
  end

end
