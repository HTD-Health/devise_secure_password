module DeviseSecurePassword
  class Engine < ::Rails::Engine
    isolate_namespace DeviseSecurePassword

    ActiveSupport.on_load(:action_controller) do
      include DeviseSecurePassword::Controllers::Helpers
    end
  end
end
