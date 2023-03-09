# frozen_string_literal: true

class Evergreen
  module Mixins
    # Convenience methods to search for data
    # and initialize objects based on the results
    module RetrievalMethods
      def get_bib_record(id)
        Evergreen::BibRecord.new(id: id, configuration: configuration, idl: idl)
      end
    end
  end
end
