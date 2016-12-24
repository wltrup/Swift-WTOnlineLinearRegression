Pod::Spec.new do |s|
  s.name             = 'WTOnlineLinearRegression'
  s.version          = '1.0.3'
  s.summary          = 'WTOnlineLinearRegression efficiently performs linear regression on one-dimensional data, with or without variance in the dependent quantity.'
  s.description      = <<-DESC
    WTOnlineLinearRegression efficiently performs linear regression on one-dimensional data, with or without variance in the dependent quantity. It supports adding and removing data points, as well as a history feature.
                       DESC
  s.homepage         = 'https://github.com/wltrup/Swift-WTOnlineLinearRegression'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wagner Truppel' => 'trupwl@gmail.com' }
  s.source           = { :git => 'https://github.com/wltrup/Swift-WTOnlineLinearRegression.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'WTOnlineLinearRegression/Classes/**/*'
end
