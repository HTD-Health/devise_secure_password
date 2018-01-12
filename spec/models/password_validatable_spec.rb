require 'yaml'
require 'i18n'

I18n.backend.store_translations(:en, YAML.load_file(File.open('./config/locales/en.yml'))['en'])

describe Devise::Models::PasswordValidatable do
  before do
    Devise.password_regex = /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!"#$%&'()*+,-.\/:;<=>?@\\\[\]^_`{|}~])/
  end

  it 'password must contain lowercase letter' do
    user = build(:user, password: 'TESTPASSWORD123!')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.password_format')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'password must contain uppercase letter' do
    user = build(:user, password: 'testpassword1!')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.password_format')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'password must contain digit' do
    user = build(:user, password: 'TestPassword!')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.password_format')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'password must contain special character' do
    user = build(:user, password: 'TestPassword1')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.password_format')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'should save user with valid password' do
    user = build(:user, password: 'TestPassword!1')

    expect(user.valid?).to be true
    expect{ user.save }.to change { User.count }.by 1
  end
end
