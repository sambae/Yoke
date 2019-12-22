build:
	swift build \
	-Xswiftc "-sdk" \
	-Xswiftc "`xcrun -sdk iphonesimulator --show-sdk-path`" \
	-Xswiftc "-target" \
	-Xswiftc "x86_64-apple-ios13.3-simulator"

test:
	xcodebuild test -destination 'name=iPhone 11 Pro' -scheme 'Yoke' | xcpretty

clean_test:
	xcodebuild clean test -destination 'name=iPhone 11 Pro' -scheme 'Yoke' | xcpretty
