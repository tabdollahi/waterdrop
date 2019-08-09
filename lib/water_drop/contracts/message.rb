# frozen_string_literal: true

module WaterDrop
  module Contracts
    # Contract with validation rules for validating that all the message options that
    # we provide to producer ale valid and usable
    # @note Does not validate message itself as it is not our concern
    class Message < Dry::Validation::Contract
      config.messages.load_paths << File.join(WaterDrop.gem_root, 'config', 'errors.yml')

      params do
        required(:topic).filled(:str?, format?: TOPIC_REGEXP)
        required(:payload).filled(:str?)
        optional(:key).maybe(:str?, :filled?)
        optional(:partition).filled(:int?, gteq?: -1)
        optional(:timestamp).maybe(:time?, :int?)
        optional(:headers).maybe(:hash?)
      end

      rule(:headers) do
        next unless value.is_a?(Hash)

        assertion = ->(value) { value.is_a?(String) }

        key.failure(:invalid_key_type) unless value.keys.all?(&assertion)
        key.failure(:invalid_value_type) unless value.values.all?(&assertion)
      end
    end
  end
end
