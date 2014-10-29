module ApplicationHelper
  def hidden_form_inputs(method)
    <<-HTML.html_safe
      <input type="hidden" name="authenticity_token" value="#{form_authenticity_token}">
      <input type="hidden" name="_method" value="#{method}">

    HTML
  end
end
