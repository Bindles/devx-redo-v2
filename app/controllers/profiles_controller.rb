class ProfilesController < ApplicationController
  before_action :set_user_and_profile, only: [ :show, :edit, :update ]

  def update
    ActiveRecord::Base.transaction do
      # Update user details
      if @user.update(user_params)
        # Check if a file is uploaded or a URL is provided
        if profile_params[:avatar_file].present?
          uploaded_file = profile_params[:avatar_file]
          image_url = upload_to_imgbb(uploaded_file)

          if image_url
            @profile.avatar_url = image_url
          else
            raise ActiveRecord::Rollback, "Failed to upload image to ImgBB."
          end
        elsif profile_params[:avatar_url_text].present?
          @profile.avatar_url = profile_params[:avatar_url_text]
        end

        # Update profile attributes (bio, etc.)
        if @profile.update(profile_params.except(:avatar_file, :avatar_url_text))
          redirect_to user_profile_path(@user), notice: "Profile successfully updated."
        else
          raise ActiveRecord::Rollback
        end
      else
        raise ActiveRecord::Rollback
      end
    end

    # Re-render the form if the transaction fails
    render :edit if @user.errors.any? || @profile.errors.any?
  end

  private

  def set_user_and_profile
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  def user_params
    params.require(:user).permit(:username)
  end

  def profile_params
    params.require(:user).require(:profile).permit(:bio, :avatar_file, :avatar_url_text)
  end

  def upload_to_imgbb(file)
    response = HTTParty.post(
      "https://api.imgbb.com/1/upload",
      body: {
        key: "4f66fe834812539df61c11f438b7e147", # Replace with your actual ImgBB API key
        image: Base64.encode64(file.read)
      }
    )

    response.code == 200 ? response.dig("data", "url") : nil
  end
end
