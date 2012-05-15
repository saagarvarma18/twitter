require 'spec_helper'

describe "Users" do
   describe "signup" do

    describe "failure" do

      it "should not make a new user" do
        lambda do
        debugger
        visit root_path
        fill_in "Name", :with=>""
        fill_in "Email", :with=>""
        fill_in "Password", :with=>""
        fill_in "Password confirmation", :with=>""
        click_button
        response.should render_template("users")
        end.should_not change(User,:count)
      end

    end
  end
end
