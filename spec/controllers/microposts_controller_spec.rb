require 'spec_helper'

describe MicropostsController do
	render_views
	
	describe "access control" do
	
		it "should deny access to 'create'" do
			post :create
			response.should redirect_to(signin_path)
		end
	
		it "should deny access to 'destroy'" do
			delete :destroy, :id => 1
			response.should redirect_to(signin_path)
		end
	end

	describe "sidebar" do

		before(:each) do
			 @user = test_sign_in(Factory(:user))
			 @attr1 = { :content => "Lorem ipsum dolor sit amet"}
			 @attr2 = { :content => "I hope that this test works!"}
		end
	
		it "should have a user name" do
			post :create
			response.should have_selector('span', :content => @user.name)
		end
	
		it "should have a gravatar" do
			post :create
			response.should have_selector('img', :class => "gravatar")
		end	

		it "should have a micropost count" do
			post :create
			response.should have_selector('span', :class => "microposts")
		end
		
		it "should pluralize micropost count" do
			post :create
			response.should have_selector('span', :content => "0 microposts")
			post :create, :micropost => @attr1
			post :create
			response.should have_selector('span', :content => "1 micropost")
			post :create, :micropost => @attr2
			post :create
			response.should have_selector('span', :content => "2 microposts")
		end
	end

	describe "POST 'create'" do
	
	  before(:each) do
	    @user = test_sign_in(Factory(:user))
	  end
	
		describe "failure" do
		
			before(:each) do
				@attr = { :content => "" }
			end
		
			it "should not create a micropost" do
				lambda do
					post :create, :micropost => @attr
				end.should_not change(Micropost, :count)
			end
			
			it "should re-render the home page" do
				post :create, :micropost => @attr
				response.should render_template('pages/home')
			end 
		end

		describe "success" do
		
			before(:each) do
				@attr = { :content => "Lorem ipsum dolor sit amet"}
			end
		
			it "should create a micropost" do
				lambda do
					post :create, :micropost => @attr
				end.should change(Micropost, :count).by(1)
			end

			it "should redirect to the root path" do
				post :create, :micropost => @attr
				response.should redirect_to(root_path)
			end

			it "should have a flash success message" do
				post :create, :micropost => @attr
				flash[:success].should =~ /micropost created/i
			end
		
		end
	end

	describe "DELETE 'destroy'" do
	
		describe "for an unauthorized user" do
		
		  before(:each)do
		    @user = Factory(:user)
		    wrong_user = Factory(:user, :email => Factory.next(:email))
		    @micropost = Factory(:micropost, :user => @user)
				test_sign_in(wrong_user)
		  end
		
			it "should deny access" do
				delete :destroy, :id => @micropost
				response.should redirect_to(root_path)
			end
		end
		
		describe "for an authorized user" do

			before(:each) do
				@user = test_sign_in(Factory(:user))
				@micropost = Factory(:micropost, :user => @user)
			end
		
			it "should destroy the micropost" do
				lambda do
					delete :destroy, :id => @micropost
					flash[:success].should =~ /deleted/i
					response.should redirect_to(root_path)
				end.should change(Micropost, :count).by(-1)
			end	
		end
	end
end
