FactoryGirl.define do
  sequence :email do |seq|
    "email#{seq}@user.com"
  end

  factory :user do
    email
    password 'klsfdl@32423'
    password_confirmation 'klsfdl@32423'

    factory :admin do
      admin true
    end
  end
end
