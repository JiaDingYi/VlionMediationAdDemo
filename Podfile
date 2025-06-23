source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'

target 'VlionMediationAdDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Ads-CN-Beta', '6.9.0.7', :subspecs => ['CSJMediation', 'BUAdTestMeasurement']
  pod 'VlionMediationAd', '1.0.2'
  # GDT
  pod 'GDTMobSDK', '4.15.40'
  pod 'GMGdtAdapter-Beta', '4.15.40.1'
  # baidu
  pod 'BaiduMobAdSDK', '5.39'
  pod 'GMBaiduAdapter-Beta', '5.39.0'
  # ks
  pod 'KSAdSDK', '3.3.76'
  pod 'GMKsAdapter-Beta', '3.3.76.1'
  # menta
  pod 'BUMentaCustomAdapter', '6.00.34'
  
  pod 'SDWebImage'
  pod 'Masonry'

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
         end
    end
  end
end
