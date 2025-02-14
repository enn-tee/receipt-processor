ActionDispatch::Request.parameter_parsers[:json] = lambda { |raw_post|
  data = ActiveSupport::JSON.decode(raw_post)
  data.deep_transform_keys!(&:underscore)
  data
}
