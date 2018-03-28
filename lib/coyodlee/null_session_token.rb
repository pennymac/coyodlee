module Coyodlee
  class NullSessionToken
    def present?
      false
    end

    def to_s
      ''
    end
  end
end
