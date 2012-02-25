---
layout: post
title: 在Django中使用二级域名
categories:
- Django
---
最近一直在用Django写东西，感觉非常棒，开发效率非常高，系统本身也很灵活。但是这样一个强大的框架也并非完美，目前，Django还不支持域名的处理，URL的路由并不考虑host信息，因此对于[晒课厅](http://www.shaiketing.com)这样的项目，如果想使用二级域名作为学校的区分，就显得有些困难。

于是我们有必要想个办法解决这个问题。一个比较方便的做法是，使用middleware对URL做一些修改，通过一点技巧来让URL的路由“识别”二级域名。不难想到这样处理：

假设我们有两个二级域名需要放在一个Django项目里，分别是：www.shaiketing.com和thu.shaiketing.com，那么为了使用URL的路由，我们需要让路由系统知道我们访问的是www和thu，而路由系统并不关心host信息，所以我们只要让路由系统看到/www/和/thu/就好。因此，我们实际上是把这两个URL变成了www.shaiketing.com/www/和thu.shaiketing.com/thu/，这样路由系统就知道我们访问的是什么二级域名了。

具体怎么做呢？写一个middleware：

{% highlight python %}
from django.http import HttpResponsePermanentRedirect

class SubdomainMiddleware(object):
    def process_request(self, request):
        domain_parts = request.get_host().split('.')
        if len(domain_parts) == 3:
            request.path_info = '/%s%s' % (domain_parts[0], request.path)
        else:
            return HttpResponsePermanentRedirect('http://www.shaiketing.com')
        return None
{% endhighlight %}

通过这样的middleware，我们就可以将二级域名附加到URL路由用到的<code>request.path\_info</code>里了。

然而，这样做还会有点问题，<code>reverse</code>的时候并没有host信息，所以我们还需要对<code>reverse</code>做一下处理：

{% highlight python %}
from django.conf import settings

from django.core import urlresolvers
def reverse_subdomain(*args, **kwargs):
    path_info = old_reverse(*args, **kwargs)
    parts = path_info[1:].split('/', 1)
    path_info = 'http://%s%s/%s' % (
            parts[0], settings.SESSION_COOKIE_DOMAIN, parts[1])
    return path_info
old_reverse = urlresolvers.reverse
urlresolvers.reverse = reverse_subdomain
{% endhighlight %}

一定要把这段代码加在某个<code>models.py</code>里，加在其他位置都不合适（可以想想为什么？）

现在这个问题应该比较完美的解决了。最后附上<code>urls.py</code>：

{% highlight python %}
from django.conf.urls.defaults import patterns, include, url

urlpatterns = patterns('',
    url(r'^www/', include('www.urls')),
    url(r'^thu/', include('thu.urls')),
)
{% endhighlight %}
