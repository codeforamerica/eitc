module Eitc
  class EitcFormBuilder < Cfa::Styleguide::CfaFormBuilder
    def eitc_input_field(
        method,
        label_text,
        type: "text",
        help_text: nil,
        options: {},
        classes: [],
        prefix: nil,
        postfix: nil,
        autofocus: nil,
        optional: false,
        notice: nil
    )
      text_field_options = standard_options.merge(
          autofocus: autofocus,
          type: type,
          class: (classes + ["text-input"]).join(" "),
          ).merge(options).merge(error_attributes(method: method))

      text_field_options[:id] ||= sanitized_id(method)
      options[:input_id] ||= sanitized_id(method)

      text_field_html = text_field(method, text_field_options)

      label_and_field_html = eitc_label_and_field(
          method,
          label_text,
          text_field_html,
          help_text: help_text,
          prefix: prefix,
          postfix: postfix,
          optional: optional,
          options: options,
          notice: notice,
          wrapper_classes: classes,
          )

      html_output = <<~HTML
        <div class="form-group#{error_state(object, method)}">
        #{label_and_field_html}
      #{errors_for(object, method)}
        </div>
      HTML
      html_output.html_safe
    end

    def eitc_label_and_field(
        method,
        label_text,
        field,
        help_text: nil,
        prefix: nil,
        postfix: nil,
        optional: false,
        options: {},
        notice: nil,
        wrapper_classes: []
    )
      if options[:input_id]
        for_options = options.merge(
            for: options[:input_id],
            )
        for_options.delete(:input_id)
        for_options.delete(:maxlength)
      end

      formatted_label = label(
          method,
          eitc_label_contents(label_text, help_text, optional),
          (for_options || options),
          )
      formatted_label += notice_html(notice).html_safe if notice

      formatted_label + formatted_field(prefix, field, postfix, wrapper_classes).html_safe
    end

    def eitc_label_contents(label_text, help_text, optional = false)
      label_text = <<~HTML
      <h1 class="form-question">#{label_text + optional_text(optional)}</h1>
      HTML

      if help_text
        label_text << <<~HTML
        <p class="text--help">#{help_text}</p>
        HTML
      end

      label_text.html_safe
    end

    def eitc_fieldset_label_contents(label_text:, help_text:, legend_class:, h1: false, optional: false)
      if h1
        label_text = "<h1 class=\"form-question\">#{label_text}</h1>"
      end

      label_html = <<~HTML
        <legend class="form-question #{legend_class}">
          #{label_text + optional_text(optional)}
        </legend>
      HTML

      if help_text
        label_html += <<~HTML
          <p class="text--help with-padding-med">#{help_text}</p>
        HTML
      end

      label_html.html_safe
    end

    def eitc_checkbox_set(method, collection, label_text: "", legend_class: "", none_option: "", help_text: nil, only_question: true)
      checkbox_html = collection.map do |item|
        <<~HTML.html_safe
          <label class="checkbox">
            #{check_box(item[:method], {multiple: true}, item[:checked_value], item[:unchecked_value])}  #{item[:label]}
          </label>
        HTML
      end.join.html_safe

      if none_option.present?
        none_check_box_html = <<~HTML
          <label class="checkbox">
            #{check_box(method, {id: "none__checkbox"}, nil, nil)} #{none_option}
          </label>
        HTML
      else
        none_check_box_html = ""
      end

      <<~HTML.html_safe
        <fieldset class="input-group form-group#{error_state(object, method)}">
          #{eitc_fieldset_label_contents(
                label_text: label_text,
                help_text: help_text,
                legend_class: legend_class,
                h1: only_question
          )}
          #{checkbox_html}
          #{none_check_box_html}
          #{errors_for(object, method)}
        </fieldset
      HTML
    end
  end
end

