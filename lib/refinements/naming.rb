# frozen_string_literal: true

module Refinements
  module Naming
    refine Symbol do
      def classify
        to_s.split('_').map(&:capitalize).join
      end
    end
  end
end
