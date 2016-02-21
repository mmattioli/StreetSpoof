# StreetSpoof

Using a Mac with OS X, we spoof various MAC addresses on a specific SSID to
simulate StreetPasses on a Nintendo 3DS handheld device. Many of the concepts
here are derived from [relaymyhome](https://github.com/taintedzodiac/relaymyhome).

# Usage

Internet Sharing must be enabled and configured on your Mac, this requires that
you have both a wireless and wired internet connection available. Once you have
connected your computer to a wired network, do the following:

1. Open __System Preferences__
2. Select __Sharing__
3. Select __Internet Sharing__
4. Set __Share your connection from:__ to `Ethernet`, and check off `WiFi` in
the __To computers using__ box.
5. Click the __Wi-Fi Options__ button, enter `NZ@McD1` as the Network Name,
leave __Channel__ `default` and ensure __Security__ is set to `None`
6. Finally, check off __Internet Sharing__ and click __Start__ at the prompt
