---
layout: post
title: 运行于Apache下的Django与IE的兼容性问题
categories:
- Django
- apache
---
这个标题很难写到位。现象是这样的：

用Django的runserver，IE访问页面并使用AJAX没有任何问题。但是一旦使用apache \+ mod\_python，IE就无法使用AJAX了，而其他浏览器一切正常。

经过抓包，错误信息如下：

{% highlight bash %}
Request Method: POST 
Request URL:  
Django Version: 1.3 
Exception Type: AttributeError 
Exception Value: 'NoneType' object has no attribute 'startswith' 
Exception Location: /usr/local/lib/python2.6/site-packages/django/http/__init__.py in _load_post_and_files, line 269
{% endhighlight %}

<code>django/http/__init__.py</code>文件的第269行是
{% highlight python %}
if self.META.get('CONTENT_TYPE', '').startswith('multipart'):
{% endhighlight %}

按理说除非<code>META</code>是<code>None</code>，否则这里不应该有问题，但这里偏偏就除了问题，因此还是可以通过修改代码解决：

{% highlight python %}
content_type = self.META.get('CONTENT_TYPE', '')
if content_type is None: content_type = ''
if content_type.startswith('multipart'):
{% endhighlight %}

这样就能正常工作了。

我猜测出现这一问题的原因是apache对IE的AJAX请求的header做了特殊处理，导致这里丢失了信息。欢迎在下方讨论~

**今天把mod\_python换成了mod\_wsgi，没有这个问题了**
