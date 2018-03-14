require_relative 'utils'

module Coyodlee
  class Client
    include Utils

    def initialize(session)
      @session = session
    end

    def get_accounts
      HttpWrapper.get(
        url: build_url('/accounts'),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_account_details(account_id:, container:)
      params = [:container]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([container])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url("/accounts/#{account_id}"),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def update_account(account_id:, body:)
      HttpWrapper.put(
        url: build_url("/accounts/#{account_id}"),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json,
          content_type: :json
        }
      )
    end

    def delete_account(id:)
      HttpWrapper.delete(
        url: build_url("/accounts/#{account_id}"),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def add_manual_account(body:)
      HttpWrapper.post(
        url: build_url("/accounts"),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_investment_options(_include: '', account_recon_type: '', account_id: '')
      params = [:_include, :account_recon_type, :account_id]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .map { |sym| sub_underscore sym.to_s }
                  .zip([_include, account_recon_type, account_id])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/accounts/investmentPlan/investmentOptions'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_historical_balances(
          include_cf: '',
          account_id: '',
          from_date: '',
          to_date: '',
          interval: '',
          account_recon_type: '',
          skip: '',
          top: ''
        )
      params = [:include_cf, :account_id, :from_date, :to_date, :interval, :account_recon_type, :skip, :top]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([include_cf, account_id, from_date, to_date, interval, account_recon_type, skip, top])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/accounts/historicalBalances'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_holdings(
          _include: '',
          account_id: '',
          provider_account_id: '',
          asset_classification__asset_classification_type: '',
          classification_value: '',
          account_recon_type: ''
        )
      params = [:_include, :account_id, :provider_account_id, :asset_classification__asset_classification_type, :classification_value, :account_recon_type]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .map { |sym| sub_underscore sym.to_s }
                  .map { |sym| sub_double_underscore sym.to_s }
                  .zip([_include, account_id, provider_account_id, asset_classification__asset_classification_type, classification_value, account_recon_type])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/holdings'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_extended_securities_info(holding_id: '')
      params = [:holding_id]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([holding_id])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/holdings/securities'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_holding_type_list
      HttpWrapper.get(
        url: build_url('/holdings/holdingTypeList'),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_asset_classification_list
      HttpWrapper.get(
        url: build_url('/holdings/assetClassificationList'),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_provider_details(provider_id:, provider_account_id:)
      params = [:provider_account_id]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([provider_account_id])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.post(
        url: build_url("/providers/#{provider_id}"),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_providers(
          priority: '',
          capability: '',
          additional_data_set: '',
          name: '',
          skip: '',
          top: '',
          classification: ''
        )
      params = [:priority, :capability, :additional_data_set, :name, :skip, :top, :classification]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .map { |sym| sub_underscore sym.to_s }
                  .map { |sym| sub_double_underscore sym.to_s }
                  .zip([priority, capability, additional_data_set, name, skip, top, classification])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/providers'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def verify_provider_account(body:)
      HttpWrapper.put(
        url: build_url('/providerAccounts/verification'),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_verification_status(provider_account_id:)
      HttpWrapper.get(
        url: build_url("/providerAccounts/verification/#{provider_account_id}"),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def update_provider_account(body:)
      HttpWrapper.put(
        url: build_url('/provideAccounts'),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def delete_provider_account(provider_account_id:)
      HttpWrapper.delete(
        url: build_url("/providerAccounts/#{provider_account_id}"),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_provider_account_details(provider_account_id:, _include: '')
      params = [:provider_account_id, :_include]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([provider_account_id, _include])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url("/providerAccounts/#{provider_account_id}"),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_provider_accounts
      HttpWrapper.get(
        url: build_url('/providerAccounts'),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def add_provider_account(provider_id:, body:)
      params = [:provider_id]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([provider_id])
                  .reject { |query, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.post(
        url: build_url('/providerAccounts'),
        params: params,
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_transactions_count(params={})
      params = params
                  .map { |sym, val| [uncapitalized_camelize(sym.to_s), val] }
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/transactions/count'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_transaction_categorization_rules
      HttpWrapper.get(
        url: build_url('/transactions/categories/rules'),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def create_transaction_categorization_rule(body:)
      HttpWrapper.post(
        url: build_url('/transactions/categories/rules'),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def update_transaction_categorization_rule(rule_id:, body:)
      HttpWrapper.put(
        url: build_url("/transactions/categories/rules/#{rule_id}"),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def delete_transaction_categorization_rule(rule_id:)
      HttpWrapper.delete(
        url: build_url("/transactions/categories/rules/#{rule_id}"),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def run_transaction_categorization_rule(rule_id:)
      params = { action: 'run'}
      HttpWrapper.post(
        url: build_url("/transactions/categories/rules/#{rule_id}"),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def run_all_transaction_categorization_rules
      params = { action: 'run'}
      HttpWrapper.post(
        url: build_url('/transactions/categories/rules'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def delete_transaction_category(category_id:)
      HttpWrapper.delete(
        url: build_url("/transactions/categories/#{category_id}"),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def update_transaction_category(category_id:, container:, category_name:, transaction_id:)
      params = [:container, :category_name, :transaction_id]
                  .map { |sym, val| [uncapitalized_camelize(sym.to_s), val] }
                  .zip([container, category_name, transaction_id])
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.put(
        url: build_url("/transactions/categories/#{category_id}"),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_transaction_category_list
      HttpWrapper.get(
        url: build_url('/transactions/categories'),
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def create_category(body:)
      HttpWrapper.post(
        url: build_url('/transactions/categories'),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def update_category(body:)
      HttpWrapper.put(
        url: build_url('/transactions/categories'),
        body: body,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_transactions(params={})
      params = params
                  .map { |sym, val| [uncapitalized_camelize(sym.to_s), val] }
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/transactions'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_statements(params={})
      params = params
                  .map { |sym, val| [uncapitalized_camelize(sym.to_s), val] }
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/statements'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_transaction_summary(group_by:, params: {})
      params = params
                  .merge({ group_by: group_by })
                  .map { |sym, val| [uncapitalized_camelize(sym.to_s), val] }
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/derived/transactionSummary'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_holding_summary(params={})
      params = params
                  .map { |sym, val| [uncapitalized_camelize(sym.to_s), val] }
                  .map { |sym, val| [sub_underscore(sym.to_s), val] }
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/derived/holdingSummary'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_networth_summary(params={})
      params = params
                  .map { |sym, val| [uncapitalized_camelize(sym.to_s), val] }
                  .map { |sym, val| [sub_underscore(sym.to_s), val] }
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/derived/networth'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_extract_events(event_name:, from_date:, to_date:)
      params = [:event_name, :from_date, :to_date]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([event_name, from_date, to_date])
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/dataExtracts/events'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_user_data(login_name:, from_date:, to_date:)
      params = [:login_name, :from_date, :to_date]
                  .map { |sym| uncapitalized_camelize sym.to_s }
                  .zip([login_name, from_date, to_date])
                  .reject { |_, value| value.to_s.strip.empty? }
                  .to_h
      HttpWrapper.get(
        url: build_url('/dataExtracts/userData'),
        params: params,
        headers: {
          authorization: @session.auth_header,
          accept: :json
        }
      )
    end

    def get_access_tokens(fin_app_id:)
      res = HttpWrapper.get(
        url: build_url("/user/accessTokens"),
        params: {
          appIds: fin_app_id
        },
        headers: {
          authorization: @session.auth_header,
          accpet: :json
        }
      )
    end
  end
end
