Pod::Spec.new do |spec|
  spec.name         = 'ADTransitionController'
  spec.version      = '1.1.1'
  spec.authors      = 'Applidium'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'http://applidium.github.io/ADTransitionController/'
  spec.summary      = 'Drop-in replacement for UINavigationController with custom transition animations.'
  spec.platform     = 'ios', '6.0'
  spec.authors      = { 'Applidium' => 'https://github.com/applidium/' }
  spec.source       = { :git => 'https://github.com/applidium/ADTransitionController.git', :tag => "v#{spec.version}" }
  spec.source_files = 'ADTransitionController/**/*.{h,m}'
  spec.exclude_files = 'TransitionDemo/**/*.{h,m}'
  spec.frameworks   = 'QuartzCore'
  spec.requires_arc = true
end