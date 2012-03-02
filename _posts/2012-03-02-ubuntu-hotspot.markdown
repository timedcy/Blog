---
layout: post
title: Ubuntu 11.10中共享WiFi
categories:
- Ubuntu
---
如果用过Ubuntu 11.10，大家都会注意到在网络设置中的“无线”里有一项叫做“Use as hotspot”，看起来这是共享WiFi的地方。然而，包括我在内的很多人都没能成功的使用这一功能。经过Google，今天终于成功了，方法如下：

1. 打开网络设置->Wireless->Use as hotspot->Configure

2. 切换到IPv6选项卡，选择“Ignore”，然后保存

3. 再次打开“Use as hotspot”即可，如果还不行，运行<code>sudo killall dnsmasq</code>或者重启应该就可以了。
