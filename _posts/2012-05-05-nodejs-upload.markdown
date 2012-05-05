---
layout: post
title: node.js中文件上传的一种方法
categories:
- node.js
---
使用node.js处理上传文件，容易想到的做法是使用express来处理post数据，然后将数据存在文件系统中。但在千寻中，这种方法看起来并不够理想。千寻中，我们一直在使用socket.io作为通讯的媒介。因此，在这里，我们需要考虑使用一种能直接利用socket.io完成通讯的做法。

通过查阅phonegap的文档，我们发现phonegap提供了一个名为<code>navigator.camera.getPicture</code>的接口，通过使用这个接口，我们可以得到经过base64格式编码的图像数据，我们只需要将这个数据通过socket.io发给服务器即可。

进一步查阅node.js的文档，我们发现，Buffer类可以实现base64的编解码，使用这个类即可轻松完成我们所需的任务。摘录部分服务器端代码如下：

{% highlight javascript %}
function updatePortrait(data, callback){
    socket.get('uid', function (err, uid) {
        if (!uid) return;
        var decodedImage = new Buffer(data, 'base64');
        fs.writeFile('../client/portraits/' + uid +'.jpg', decodedImage,
            function (err) { callback(err); });
    });
}
{% endhighlight %}
