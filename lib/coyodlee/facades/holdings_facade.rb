module Coyodlee
  module Facades
    class HoldingsFacade
      def initialize(request_facade)
        @request_facade = request_facade
      end

      def all(params={})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'holdings', headers: headers, params: params)
        @request_facade.execute(req)
      end

      def extended_securities_info(params={})
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'holdings/securities', headers: headers, params: params)
        @request_facade.execute(req)
      end

      def holding_type_list
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'holdings/holdingTypeList', headers: headers)
        @request_facade.execute(req)
      end

      def asset_classification_list
        headers = { 'Accept' => 'application/json' }
        req = @request_facade.build(:get, 'holdings/assetClassificationList', headers: headers)
        @request_facade.execute(req)
      end
    end
  end
end
