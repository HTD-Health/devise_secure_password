describe Devise::PasswordExpiredController do
  include Devise::Test::ControllerHelpers
  render_views

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]

    sign_in(create(:user, password: 'TestPassword1!', password_changed_at: 3.months.ago))
  end

  it 'should render show', render: true do
    get :show

    expect(response.body).to include 'Renew your password'
  end

  it 'should update password' do
    put :update, params: {
      user: {
        current_password: 'TestPassword1!',
        password: 'TestPassword2!',
        password_confirmation: 'TestPassword2!'
      }
    }

    expect(response).to redirect_to root_path
  end
end
