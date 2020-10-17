<%= form_for @changeset, Routes.sign_in_code_path(@conn, :create), [as: :sign_in_code], fn f -> %>
  <%= error_tag f, :email %>
  <%= text_input f, :email, placeholder: "name@example.com", autofocus: true %>
  <%= submit "Email sign in code" %>
<% end %>
