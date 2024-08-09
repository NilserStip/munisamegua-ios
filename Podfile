# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Seguridad Veintiseis' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Seguridad Veintiseis
  pod 'GoogleMaps'
  pod 'Alamofire', '~> 5.0.0-rc.3'
  pod 'SwiftyUserDefaults', '5.0.0-beta.5'
  pod 'SkyFloatingLabelTextField', '~> 3.0'
  pod 'SideMenu', '~> 6.0'
  pod 'IQKeyboardManagerSwift', '6.5.0'
  pod 'TransitionButton'
  pod 'Nuke', '~> 8.0'
  pod 'ActiveLabel'
  #pod 'Firebase/Auth'
  pod "TTGSnackbar"
  pod 'UIView+Shake'

end

post_install do |installer|
  installer.generated_projects.each do |project|
      project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
          end
      end
  end
end

