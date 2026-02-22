# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# This file contains settings for ActionController::ParamsWrapper which
# is enabled by default.

# Disable parameter wrapping for JSON so Inertia form submissions are received
# as flat params, consistent with the inertia-rails react-starter-kit convention.
ActiveSupport.on_load(:action_controller) do
  wrap_parameters format: []
end
