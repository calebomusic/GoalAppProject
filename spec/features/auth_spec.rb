require 'spec_helper'
require 'rails_helper'

feature 'features', type: :feature do
  feature "the signup process" do

    scenario "has a new user page" do
      visit('/users/new')
      expect(page).to have_content "Sign Up"
    end

    feature "signing up a user" do

      scenario "shows username on the homepage after signup" do
        visit('/users/new')
        fill_in 'username', with: "BillyBob"
        fill_in 'password', with: "password"
        click_on "Sign Up"
        expect(page).to have_content "BillyBob"
      end

      scenario "re-renders sign up page on invalid sign up" do
        visit('/users/new')
        fill_in 'username', with: "BillyBob"
        fill_in 'password', with: ""
        click_on "Sign Up"
        expect(page).to have_content "Password is too short"
        expect(page).to have_content "Sign Up"
      end
    end
  end

  feature "logging in" do
    before { FactoryGirl.create(:user) }

    scenario "shows username on the homepage after login" do
      visit('/session/new')
      fill_in 'username', with: "BillyBob"
      fill_in 'password', with: "password"
      click_on "Sign In"
      expect(page).to have_content "BillyBob"
    end

    scenario "re-renders sign in page on invalid sign in" do
      visit('/session/new')
      fill_in 'username', with: "BillyBob"
      fill_in 'password', with: ""
      click_on "Sign In"
      expect(page).to have_content "Invalid credentials"
      expect(page).to have_content "Sign In"
    end
  end

  feature "logging out" do
    before { FactoryGirl.create(:user) }

    scenario "begins with a logged out state" do
      visit('/session/new')
      expect(page).to have_button 'Sign In'
      expect(page).not_to have_content 'BillyBob'
    end

    scenario "doesn't show username on the homepage after logout" do
      visit('/session/new')
      fill_in 'username', with: "BillyBob"
      fill_in 'password', with: "password"
      click_on "Sign In"
      save_and_open_page
      click_button "Sign Out"
      expect(page).not_to have_content "BillyBob"
    end
  end
end
