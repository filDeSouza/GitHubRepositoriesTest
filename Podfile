# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'GitHubRepositories' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GitHubRepositories
	pod 'RxSwift'
  pod 'RxCocoa'
  pod 'ProgressHUD'
  pod 'Alamofire'

  target 'GitHubRepositoriesTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GitHubRepositoriesUITests' do
    # Pods for testing
  end

end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
        end
    end
end