class UsersController < ApplicationController

  before_filter :require_user, :only => [:edit, :update]
  before_filter :require_no_user, :only => [:create, :register, :update_for_register]

  before_filter :check_authorization, :only => [:edit, :update]

  # Empty home page
  # It will only show the layout
  def home
    logger.debug "home page requested"
  end

  # GET /users/new
  def new
    @title = "User Sign Up"
    @user = User.new
  end

  # Step 1
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

  # Step 2: find user based on uuid
  def register
    @title = "Register"
    @user = User.find(:first,
                      :conditions => { :uuid => params[:uuid] })

    if(!@user)
      logger.debug "User not found for uuid #{params[:uuid]}"
      flash[:error] = "User not found."
      redirect_to root_path
      return
    end

    # if the user is already registered, we should ask the user to authenticate
    if @user.is_registered?
      flash[:notice] = "You're already registered. Please sign in."
      redirect_to root_path
      return
    end

  end

  # Step 2: save more info and create user session.
  def update_for_register

    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])

      # create a session for the user
      @user_session = UserSession.new(params[:user])

      # failure would be unexpected here
      raise "Cannot create user session" unless @user_session

      logger.debug "logged in #{@user.email}"

      redirect_to(edit_user_path, :notice => 'User was successfully updated.')
    else

      render :action => :register
    end
  end

  # Step 3 and user edit page at the same time
  def edit
    @title = "User Edit"
    @user = User.find(params[:id])
    @jobs = Job.where(:user_id => @user)

    # There needs to be 7 jobs in the instance variable
    # even if they're not all in the database.
    @jobs.size.upto 6 do
      @jobs << Job.new
    end
  end


  # This is both for step 3 and user edit.
  # Steps 3 and user edit are processed the same.
  # Step 3: allow editing of the remaining attributes and job history.
  def update
    @user = User.find(params[:id])

    if @user.update_attributes(params[:user])
      redirect_to(root_path, :notice => 'User was successfully updated.')
    else
      @jobs = @user.jobs
      @jobs.size.upto 6 do
        @jobs << Job.new
      end
      render :action => "edit"
    end
  end

end
