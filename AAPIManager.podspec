Pod::Spec.new do |s|
s.platform = :ios
s.ios.deployment_target = '12.0'
s.name = "AAPIManager"
s.summary = "AAPIManager suggest a layer call api same Moya"
s.requires_arc = true

s.version = "0.0.1"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "Hoan Phan" => "phanvanhoan54cntt@gmail.com" }
s.homepage = "https://github.com/hoanphan/APIManager"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/hoanphan/APIManager.git",
             :tag => "#{s.version}" }

s.framework = "Foundation"
s.dependency 'RxSwift'
s.dependency 'ObjectMapper'
s.dependency 'Alamofire'
s.dependency 'RxCocoa'
s.dependency 'RxAlamofire'

s.source_files = "AAPIManager/**/*.{swift}"
s.swift_version = "4.2"

end
