CarrierWave.configure do |config|
  config.azure_storage_account_name = Rails.application.secrets.azure_name
  config.azure_storage_access_key = Rails.application.secrets.azure_key
  # config.azure_storage_blob_host = 'YOUR STORAGE BLOB HOST' # optional
  config.azure_container = 'contentimage'
  # config.asset_host = 'YOUR CDN HOST' # optional
end
