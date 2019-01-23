platform :ios, '11.0'
use_frameworks!
workspace 'Rental.xcworkspace'

def base_pods
  pod 'RxSwiftExt'
  pod 'RxViewController'
  pod 'RxFlow'
  pod 'Reusable'
end

target 'NAXT Mobile Data Entity Framework' do
  project '../NMDEF.iOS/NAXT Mobile Data Entity Framework.xcodeproj'
  base_pods
end

target 'Rental' do
  project './Rental.xcodeproj'
  base_pods
  pod 'ActionSheetPicker-3.0'
  pod 'TextImageButton', '~> 0.2'
end
