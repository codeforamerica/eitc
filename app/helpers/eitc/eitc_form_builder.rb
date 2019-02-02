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
  end
end

