module Coyodlee
  module Facades
    class DocumentsFacade
      def initialize(request_facade)
        @request_facade = request_facade
      end

      def all(params={})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'documents', params: params, headers: headers)
        @request_facade.execute(req)
      end

      def download(id:)
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, "documents/#{id}", headers: headers)
        @request_facade.execute(req)
      end

      def delete(id:)
        req = @request_facade.build(:delete, "documents/#{id}")
        @request_facade.execute(req)
      end
    end
  end
end
