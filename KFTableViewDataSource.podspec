Pod::Spec.new do |s|

  s.name          = "KFTableViewDataSource"
  s.version       = "1.0.1"
  s.summary       = "TableView数据源处理类"
  s.homepage      = "https://github.com/moliya/KFTableViewDataSource"
  s.license       = "MIT"
  s.author        = {'Carefree' => '946715806@qq.com'}
  s.source        = { :git => "https://github.com/moliya/KFTableViewDataSource.git", :tag => s.version}
  s.requires_arc  = true
  s.platform      = :ios, '9.0'

  s.source_files  = "Sources/*.{h,m}"
  
end
