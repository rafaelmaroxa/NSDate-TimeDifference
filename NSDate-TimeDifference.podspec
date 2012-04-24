Pod::Spec.new do |s|
  s.name     = 'NSDate-TimeDifference'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'Returns a string with the elapsed time from the current time.'
  s.homepage = 'https://github.com/ootake/NSDate-TimeDifference/'
  s.author   = {  'satoshi ootake'     => 'ootake1@gmail.com' }
  s.source   = { :git => 'git@github.com:ootake/NSDate-TimeDifference.git' , :commit => 'a684d2e4a9c636a158e866656e426dfc65e963e5' }
  s.source_files = 'NSDate+TimeDifference/NSDate+TimeDifference.{h,m}'
  s.platform = :ios
  s.clean_paths = 'NSDate+TimeDifferenceExample.xcodeproj' , 'NSDate+TimeDifferenceExample'
  s.requires_arc = true
end
