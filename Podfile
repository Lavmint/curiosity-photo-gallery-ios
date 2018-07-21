platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

workspace 'cpg'
project 'cpg-ios/cpg-ios.xcodeproj'
project 'cpg-lib/wcpg-lib.xcodeproj'

target 'CuriosityPhotoGallery' do
    project 'cpg-ios/cpg-ios.xcodeproj'
    pod 'RxSwift',    '~> 4.0'
    pod 'RxCocoa',    '~> 4.0'
    pod 'NVActivityIndicatorView', '~> 4.3.0'
end
