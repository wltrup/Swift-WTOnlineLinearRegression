Pod::Spec.new do |s|
  s.name             = 'WTOnlineLinearRegression'
  s.version          = '0.1.0'
  s.summary          = 'WTOnlineLinearRegression XXX.'
  s.description      = <<-DESC
    WTOnlineLinearRegression XXX.
                       DESC
  s.homepage         = 'https://github.com/wltrup/Swift-WTOnlineLinearRegression'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Wagner Truppel' => 'trupwl@gmail.com' }
  s.source           = { :git => 'https://github.com/wltrup/Swift-WTOnlineLinearRegression.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'WTOnlineLinearRegression/Classes/**/*'
end
