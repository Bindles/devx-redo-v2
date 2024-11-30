rails generate devise:controllers users

This will generate the necessary controllers under app/controllers/users/, including registrations_controller.rb.

2. Override Devise’s RegistrationsController
We need to override the Devise::RegistrationsController to permit the username field when users sign up or update their profile.

Open app/controllers/users/registrations_controller.rb and modify it like this:

ruby
Copy code
class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, only: [:edit, :update]

  # Allow the username to be updated along with other fields (email, password)
  def update
    # Check if the current user is the one trying to edit their profile
    if current_user.update(user_params)
      redirect_to user_profile_path(current_user), notice: "Profile updated successfully."
    else
      render :edit
    end
  end

  private

  # Permit the username parameter along with other parameters like email and password
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
In this controller:

We override the update action to allow the username field to be updated.
The user_params method now includes :username as a permitted field.
3. Update the Routes
Next, we need to update your config/routes.rb file to use the custom RegistrationsController for Devise.

In config/routes.rb, modify your Devise routes like this:

ruby
Copy code
devise_for :users, controllers: { registrations: 'users/registrations' }
This ensures that Devise uses your customized RegistrationsController for registration and profile updates.

4. Create/Modify the Views
Now, you need to modify the profile and edit views for the user. You can either override the Devise views by generating them, or you can modify your existing views.

To generate Devise views (if you don’t already have them), run:

## DONT DO THIS STEP UNTIL RDY FOR DEVISE CUSTOM VIEWS
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

6. Search for Friends by username
You can now allow users to search for other users by username. For that, you can create a search form similar to the previous example and pass the search parameter to the controller. Here’s an example of what the search form and action might look like:

In the app/views/friendships/index.html.erb:

erb
Copy code
<h2>Search for Friends</h2>
<%= form_with(url: search_friends_path, method: :get, local: true) do |form| %>
  <%= form.text_field :username, placeholder: "Search by username", class: "form-control" %>
  <%= form.submit "Search", class: "btn btn-primary mt-2" %>
<% end %>

<h2>Your Friends</h2>
<% if @friends.any? %>
  <ul class="list-group">
    <% @friends.each do |friend| %>
      <li class="list-group-item">
        <%= link_to friend.email, user_profile_path(friend.id), class: "text-primary" %>
      </li>
    <% end %>
  </ul>
<% else %>
  <p class="text-muted">You have no friends yet.</p>
<% end %>
And in your FriendshipsController, add the search method:

ruby
Copy code
class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def search
    @users = User.where("username LIKE ?", "%#{params[:username]}%")
  end
end
Conclusion
By overriding Devise’s RegistrationsController and adding the necessary routes and views, we can:

Allow users to edit their username.
Ensure that users can only edit their own profile.
Implement a simple search functionality for users to find friends by their username.
This approach leverages Devise’s built-in features while giving you the flexibility to add custom fields like username.






