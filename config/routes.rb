Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "detections", to: "detections#create"
    end
  end
end