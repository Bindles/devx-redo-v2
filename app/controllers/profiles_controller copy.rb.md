class ProfilesController < ApplicationController
  before_action :set_user_and_profile, only: [ :show, :edit, :update ]

  def update
    # Start a transaction for both updates
    ActiveRecord::Base.transaction do
      # Update the user
      if @user.update(user_params)
        # Now update the profile, if the user update was successful
        if @profile.update(profile_params)
          redirect_to user_profile_path(@user), notice: "Profile was successfully updated."
        else
          raise ActiveRecord::Rollback
        end
      else
        raise ActiveRecord::Rollback
      end
    end

    # If the transaction failed, we re-render the edit page
    render :edit if @user.errors.any? || @profile.errors.any?
  end

  private

  def set_user_and_profile
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  def user_params
    params.require(:user).permit(:username)  # Only permit username for user
  end

  def profile_params
    params.require(:user).require(:profile).permit(:bio, :avatar_url)  # Ensure profile attributes are permitted correctly
  end
end
