describe Devise::Models::PasswordArchivable do
  before do
    Devise.password_archiving_count = 3
  end

  let(:set_password) do
    ->(user, password) { user.update!(password_confirmation: password, password: password) }
  end

  it 'cannot use the same password' do
    user = create(:user, password: 'Password1!')

    expect{ set_password.call(user, 'Password1!') }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'cannot use archived passwords' do
    user = create(:user, password: 'Password1!')
    set_password.call(user, 'Password2!')
    set_password.call(user, 'Password3!')

    expect{ set_password.call(user, 'Password1!') }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'stores password after password update' do
    user = create(:user, password: 'Password1!')
    set_password.call(user, 'Password2!')
    set_password.call(user, 'Password3!')

    expect(OldPassword.count).to eq 2
  end
end
