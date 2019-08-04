# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Pomodoro' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'HGCircularSlider'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Google-Mobile-Ads-SDK'
  # Pods for Pomodoro

  target 'PomodoroTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PomodoroUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'PomodoroFoundation' do
  use_frameworks!
end

target 'PomodoroSettings' do
  use_frameworks!
end


target 'SettingsApp' do
  use_frameworks!
end

target 'TimeLine' do
  use_frameworks!
  pod 'UITextView+Placeholder'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
  pod 'RxKeyboard'
end

target 'TimeLineApp' do
  use_frameworks!
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
  pod "LoremIpsum-iOS"
end

inhibit_all_warnings!
