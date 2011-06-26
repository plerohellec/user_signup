class UsersController < ApplicationController

  # Empty home page
  # It will only show the layout
  def home
    logger.debug "home page requested"
  end

  # GET /users/1
  def show
    @user = User.find(params[:id])
  end

  # GET /users/new
  def new
    @title = "User Sign Up"
    @user = User.new
  end

  # POST /users
  def create
    @user = User.new(params[:user])

    # We need to generate and save the uuid that will be inserted into the URL.
    # It will be used to lookup the user when he clicks on the link.
    @user.generate_uuid

    # start a transaction to be able to rollback the user creation in case
    # the email sending failed.
    res = false
    User.transaction do
      res = @user.save
      res &&= @user.send_confirmation_email if res

      raise ActiveRecord::Rollback unless res
    end

    if res
        flash[:notice] = "An email was sent to #{params[:email]} " +
                              "with registration information."
        redirect_to '/'
    else
      flash[:error] = "Registration failed."
      @title = "User Sign Up"
      render :action => :new
    end

  end

  # GET /users/1/edit
  def edit
    @title = "User Edit"
    @user = User.find(params[:id])
    @jobs = Job.where(:user_id => @user)

    # There needs to be 7 jobs in the instance variable
    # even if they're not all in the database.
    @jobs.size.upto 6 do
      logger.debug "job loop iteration"
      @jobs << Job.new
    end
  end

  # Step 2 of the user sign up
  def register
    @title = "Register"
    @user = User.find(:first,
                      :conditions => { :uuid => params[:uuid] })

    if(!@user)
      flash[:error] = "User not found."
      redirect_to root_path
    end

    # if the user is already registered, we should go straight to the 3rd step
    if @user.is_registered?
      redirect_to edit_user_path(@user)
      return
    end

  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to(edit_user_path, :notice => 'User was successfully updated.')
    else
      # are we in step 2 or 3?
      if(!@user.is_registered?)
        render :action => :register
      else
        render :action => "edit"
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
