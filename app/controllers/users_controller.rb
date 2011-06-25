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
      render :action => :new
    end

  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end


  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
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
