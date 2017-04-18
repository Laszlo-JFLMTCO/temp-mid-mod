require 'rails_helper'

# As an authenticated user viewing the main page (links#index), I should see a simple form to submit a link.
# A link includes:
# A valid URL for the link
# A title for the link

describe 'User adding a new link', js:true do
  let!(:test_user) {
    test_email = 'test@email.com'
    test_password = 'password'
    test_user = User.create(email: test_email, password: test_password)
  }

  before(:each) do
    visit signin_path

    fill_in 'user[email]', with: test_user.email
    fill_in 'user[password]', with: 'password'
    click_on 'Sign In'
  end

  describe 'With correct details' do
    it 'can save it' do
      test_title = 'Test title'
      test_url = 'https://urlockbox-laszlo.herokuapp.com'
      fill_in 'link[title]', with: test_title
      fill_in 'link[url]', with: test_url
      click_on 'Save Link'

      expect(page).to have_current_path(links_path)
      expect(page).to have_content(test_title)
      expect(page).to have_content(test_url)
      expect(page).to have_button('Edit')
    end
  end

  describe 'With incorrect details' do
    it 'will show an error message' do
      test_title = 'Test title'
      test_url = 'invalidURL'
      fill_in 'link[title]', with: test_title
      fill_in 'link[url]', with: test_url
      click_on 'Save Link'

      expect(page).to have_current_path(links_path)
      expect(Link.count).to eq(0)
      expect(page).to have_content('Url Invalid')
    end

    it 'will save after correction' do
      test_title = 'Test title'
      test_invalid_url = 'invalidURL'
      test_valid_url = 'https://urlockbox-laszlo.herokuapp.com'

      fill_in 'link[title]', with: test_title
      fill_in 'link[url]', with: test_invalid_url
      click_on 'Save Link'

      fill_in 'link[title]', with: test_title
      fill_in 'link[url]', with: test_valid_url
      click_on 'Save Link'

      expect(page).to have_current_path(links_path)
      expect(page).to have_content(test_title)
      expect(page).to have_content(test_valid_url)
      expect(Link.first.url).to eq(test_valid_url)
      expect(Link.first.title).to eq(test_title)
    end
  end

end