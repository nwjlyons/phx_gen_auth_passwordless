<%= form_for @changeset, Routes.sign_in_code_path(@conn, :check), [as: :sign_in_code], fn f -> %>
  <%= error_tag f, :code %>
  <%= text_input f, :code, placeholder: "000000", autofocus: true %>
  <%= submit "Check" %>
<% end %>
