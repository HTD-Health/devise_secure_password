module DeviseSecurePassword
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      included do
        before_action :handle_password_change
      end

      private

      def handle_password_change
        return if warden.nil?

        if !devise_controller? && !ignore_password_expire? && !request.format.nil? && request.format.html?
          Devise.mappings.keys.flatten.any? do |scope|
            if signed_in?(scope) and warden.session(scope)['password_expired']
              # re-check to avoid infinite loop if date changed after login attempt
              if send(:"current_#{scope}").try(:need_change_password?)
                store_location_for(scope, request.original_fullpath) if request.get?
                redirect_for_password_change scope
                return
              else
                warden.session(scope)[:password_expired] = false
              end
            end
          end
        end
      end

      def redirect_for_password_change(scope)
        redirect_to change_password_required_path_for(scope), :alert => I18n.t('change_required', {:scope => 'devise.password_expired'})
      end

      def change_password_required_path_for(resource_or_scope = nil)
        scope       = Devise::Mapping.find_scope!(resource_or_scope)
        change_path = "#{scope}_password_expired_path"
        send(change_path)
      end

      protected

      def ignore_password_expire?
        false
      end
    end
  end
end
