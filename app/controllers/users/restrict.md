4. Create/Modify the Views
Now, you need to modify the profile and edit views for the user. You can either override the Devise views by generating them, or you can modify your existing views.

To generate Devise views (if you don’t already have them), run:

bash
Copy code
rails generate devise:views
This will generate the Devise views inside app/views/devise/.

In the edit.html.erb view for users (app/views/devise/registrations/edit.html.erb), you can add a username field to the form like this:

erb
Copy code
<%= form_for(resource, as: resource_name, url: registration_path(resource_name)) do |f| %>
  <div class="form-group">
    <%= f.label :username %>
    <%= f.text_field :username, class: "form-control", value: resource.username %>
  </div>

  <div class="form-group">
    <%= f.label :email %>
    <%= f.email_field :email, class: "form-control" %>
  </div>

  <div class="form-group">
    <%= f.label :password %>
    <%= f.password_field :password, class: "form-control", autocomplete: "new-password" %>
  </div>

  <div class="form-group">
    <%= f.label :password_confirmation %>
    <%= f.password_field :password_confirmation, class: "form-control", autocomplete: "new-password" %>
  </div>

  <div class="form-group">
    <%= f.submit "Update", class: "btn btn-primary" %>
  </div>
<% end %>
This will display a form with fields for the username, email, password, and password_confirmation.

5. Restricting Access to Own Profile
To ensure that users can only edit their own profiles, you can add a before_action in the Users::RegistrationsController to check if the current_user is trying to update their own profile. However, in this case, we don’t need to explicitly check that since Devise already restricts access to the registration and profile pages for the logged-in user.

But if you need a more explicit check, you could add it as follows:

ruby
Copy code
before_action :ensure_correct_user, only: [:edit, :update]

private

def ensure_correct_user
  unless current_user == User.find(params[:id])
    redirect_to user_profile_path(current_user), alert: "You can only edit your own profile."
  end
end
This ensures that users can’t access other users’ edit pages by modifying the id parameter in the URL.