# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

def common_pods
  pod 'SwiftLint', '0.43.1'
  pod 'SDWebImage', '5.12.1'
end

target 'OCS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for OCS
  common_pods
  
  target 'OCSTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
