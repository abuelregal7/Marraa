# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'
pod 'Cosmos', '~> 15.0'

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end

target 'Marraa' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Marraa
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'KRProgressHUD'
  pod 'SlideMenuControllerSwift'
  pod 'IQKeyboardManagerSwift'
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'NotificationBannerSwift'
  pod 'GoogleSignIn'
  pod 'XLPagerTabStrip', '~> 8.0'
  pod 'SwiftPhotoGallery'
  pod 'YPImagePicker', '~> 3.5.2'

  
end
