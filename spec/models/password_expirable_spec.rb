describe Devise::Models::PasswordExpirable do
  before do
    Devise.expire_password_after = 1.month
  end

  let(:user) { create(:user, password: 'TestPassword!1') }
  let(:set_password) do
    ->(password) { user.update!(password_confirmation: password, password: password) }
  end

  it 'should update password_changed_at after password change' do
    expect { set_password.call('TestPassword!2') }.to change { user.password_changed_at }
  end

  it 'should expire password after given time' do
    user.update(password_changed_at: Time.now.ago(2.month))

    expect(user.need_change_password?).to be true
  end

  context '#need_change_password!' do
    it 'should expire password' do
      expect(user.need_change_password?).to be false

      user.need_change_password!

      expect(user.need_change_password?).to be true
    end
  end
end
