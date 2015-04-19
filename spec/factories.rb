FactoryGirl.define do
  factory :user do
    sequence(:first_name) {|n| "Chandan #{n}"}
    sequence(:last_name) {|n| "Kumar #{n}"}
    sequence(:email) {|n| "chandan.jhun#{n}@gmail.com"}
    password "foobar"
    password_confirmation "foobar"
  end

  factory :media do
    sequence(:url) {|n| "http://example#{n}.com"}
    sequence(:description) {|n| "Description #{n}"}
    user

    factory :is_public do
      permission Media::PERMISSION_HASH[:is_public]
    end

    factory :is_private do
      permission Media::PERMISSION_HASH[:is_private]
    end
  end
end