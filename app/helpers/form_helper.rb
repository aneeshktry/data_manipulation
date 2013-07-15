module FormHelper

  def generate_label(object, attribute)
    if object
      I18n.translate("models.#{object.class.name.underscore}.#{attribute}.label")
    else
      return ""
    end
  end

  def label_id(object, attribute,suffix="")
    "#{object.class.name.underscore.gsub("/","_")}_#{attribute}_#{object && object.new_record? ? "new" : object && object.id.to_s}_#{suffix}"
  end

  def display_label(object, attribute, mandatory, label=nil, show_error=true, width_class="width-40")
    if object
      label = label || generate_label(object, attribute)
      id = label_id(object, attribute,"LABEL")
      cls_name = "grid-label"
      if show_error && object.errors[attribute].any?
        cls_name =  "grid-error-label"
      end

      ## Adding a star to indicate that the field is mandatory
      ## This is added only if mandatory == true
      mandatory_span = ""
      if mandatory
        mandatory_span = content_tag :span, "*", :class=>"mandatory"
      end

      label_span = content_tag :span, label, :class=>cls_name

      return content_tag :div, raw("#{label_span}#{mandatory_span}"), :class=>"form-grid-cell #{width_class}", :id=>id

    else
      return ""
    end
  end

  def display_field(object, attribute, field, show_error=true, width_class="width-15")

    id = label_id(object, attribute,"FIELD")
    #puts "#{object.errors[attribute]}"

    cls_name = "FORM_FIELD"
    if show_error && object && object.errors[attribute].any?
      cls_name = "grid-error-field"
      msg = object.errors[attribute]
      msg = msg[0] if msg.is_a?(Array)
      error_message = content_tag("div", msg , :class => "error-message", :id=>id + "_msg" )
      return content_tag :div, ( field + error_message ), :class=>"form-grid-cell #{width_class} #{cls_name}", :id=>id
    end
    return content_tag :div, field, :class=>"form-grid-cell #{width_class} #{cls_name}", :id=>id

  end

  def display_grid_row(object, attribute, field, mandatory, label=nil, show_error=true, location=false, label_width_class="width-40", field_width_class="width-15")

    #    id = label_id(object, attribute,"ROW")
    if location
      label_cell = display_label(object, :location_id, mandatory, generate_label(object.location, "#{attribute}_id"), show_error, label_width_class)
    else
      label_cell = display_label(object, attribute, mandatory, label, show_error, label_width_class)
    end

    if location
      field_cell = display_field(object.location, "#{attribute}_id", field, show_error, field_width_class)
    else
      field_cell = display_field(object, attribute, field, show_error, field_width_class)
    end

    clear_tag = content_tag :div, "", :class=>"cl"
    row_content = label_cell + field_cell + clear_tag
    return content_tag(:div, (row_content), :class=>"form-grid-row")

  end

  def display_one_by_one(object, attribute, field, mandatory, label_text=nil, show_error=true)

    label_text = label_text || label(object, attribute)
    label_div = content_tag :div, label_text, :class=>"float-left"
    field_div = content_tag :div, field
    error_div =  ""
    mandatory_div = content_tag :div, "*"
    clear_5_tag = content_tag :div, "", :class=>"cl-5"
    if show_error && object.errors[attribute].any?
      error_div =  content_tag(:div, object.errors[attribute][0], :class=>"error-message")
      label_div = content_tag :div, label_text, :class=>"float-left grid-error-label"
      mandatory_div = content_tag :div, "*", :class=>"mandatory"
      field_div = content_tag :div, field, :class=>"grid-error-field"
    end
    mandatory_span = ""
    if mandatory
      mandatory_span = content_tag :span, "*", :class=>"margin-left-5 mandatory"
    end

    if label_text == ""
      row_content = field + clear_5_tag + error_div + clear_5_tag
    else
      row_content = label_div + raw("#{mandatory_span}") + clear_5_tag + field + clear_5_tag + error_div + clear_5_tag
    end

    return content_tag(:div, (row_content), :class=>"")

  end
  
end