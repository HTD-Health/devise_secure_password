require 'yaml'
require 'i18n'

I18n.backend.store_translations(:en, YAML.load_file(File.open('./config/locales/en.yml'))['en'])

describe Devise::Models::PasswordUncommonable do
  it 'should prohibit using password from top 100_000 most common passwords list' do
    user = build(:user, password: '1qaz!QAZ')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.commonly_used')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid

    user = build(:user, password: 'ZAQ!2wsx')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.commonly_used')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'should prohibit using password from list provided by user' do
    create(:common_password, password: 'TestPassword1!')
    create(:common_password, password: '1!TestPassword')

    user = build(:user, email: 'first_name_last_name@gmail.com', password: 'TestPassword1!')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.commonly_used')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid

    user = build(:user, email: 'first_name_last_name@gmail.com', password: '1!TestPassword')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.commonly_used')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
  end

  it 'should prohibit using password similar to email' do
    user = build(:user, email: 'first_name_last_name@gmail.com', password: '!First_name_last_name@gmail.com1')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.email_as_password')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid

    user = build(:user, email: 'first_name_last_name@gmail.com', password: 'First_name_last_name1')

    expect(user.valid?).to be false
    expect(user.errors.messages[:password]).to eq [I18n.t('errors.messages.email_as_password')]
    expect{ user.save! }.to raise_error ActiveRecord::RecordInvalid
  end
end
