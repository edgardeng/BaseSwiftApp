//
//  ClientManager.swift
//  BaseSwiftApp
//
//  Created by 邓曦曦 on 16/3/30.
//  Copyright © 2016年 Edgar Deng. All rights reserved.
//

import Foundation
import Alamofire

class ClientManager: AnyObject {
    
    func request(){
        
        Alamofire.request(.GET, "https://api.500px.com/v1/photos").responseJSON() {
            (_, _, data, _) in
            println(data)
        }
        Optional({
            error = "Consumer key missing.";
            status = 401;
        })
    }
    
    

    
    
}

/*
面来解释一下那些代码到底做了些什么：

· Alamofire.request(_:_)接收两个参数：method和URLString。其中，method 通常是.GET、.POST；URLString通常是您想要访问的内容的 URL。其将返回一个Alamofire.Request对象。

· 通常情况下，您只需将请求对象链接到响应方法上。例如，在上面的代码中，请求对象简单地调用了responseJSON()方法。当网络请求完毕后，responseJSON()方法会调用我们所提供的闭包。在我们的示例中，我们只是简单的将经过解析的 JSON 输出到控制台中。

· 调用responseJSON方法意味着您期望获得一个 JSON 数据。在我们的示例中，Alamofire 试图解析响应数据并返回一个 JSON 对象。或者，您可以使用responsePropertyList来请求获得一个属性列表，也可以使用responseString来请求获得一个初始字符串。在本教程后面，您将了解更多关于响应序列化方法的使用方式。

您可以从控制台中看到输出的响应数据，服务器报告您需要一个名为consumer key的东西。在我们继续使用 Alamofire 之前，我们需要从 500px 网站的 API 中获取一个密钥。

获取消费者密钥

前往https://500px.com/signup，然后使用您的邮箱免费注册，或者使用您的 Facebook 、Twitter 或者 Google 帐号登录。

一旦您完成了注册流程，那么前往https://500px.com/settings/applications并单击"Register your application"。

您会看到如下所示的对话框：

133.jpg

红色大箭头指向的那些文本框里面的内容都是必填的。使用Alamofire Tutorial作为Application Name，然后使用iOS App作为Description。目前您的应用还没有Application URL，但是您可以随意输一个有效的网址来完成应用注册，您可以使用raywenderlich.com^_^。

最后，在Developer’s Email中输入您的邮箱地址，然后单击复选框来接受使用协议。

接着，单击 Register按钮，您会看到一个如下所示的框：

122.jpg

单击See application details链接，然后它会弹出详细信息，这时候您就可以定义您的消费者密钥了，如下所示：

111.jpg

从该页面中复制出您的消费者密钥，然后返回 Xcode，然后用如下代码替换掉目前为止您唯一添加的代码：

1
2
3
4
Alamofire.request(.GET, "https://api.500px.com/v1/photos", parameters: ["consumer_key": "PASTE_YOUR_CONSUMER_KEY_HERE"]).responseJSON() {
(_, _, JSON, _) in
println(JSON)
}
请确保您已经用复制的消费者密钥来替换掉PASTE_YOUR_CONSUMER_KEY_HERE。

生成并运行您的应用，这时您会在控制台中看见海量的输出：

100.jpg

上述所有的输出意味着您成功地下载到了含有一些照片信息的 JSON。

JSON 数据中包含了一些图片集的属性、一些页面信息，以及一个图片数组。这里是我得到的搜索结果（您的可能会略有不同）：

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
{
"feature": "popular",
"filters": {
"category": false,
"exclude": false
},
"current_page": 1,
"total_pages": 250,
"total_items": 5000,
"photos": [
{
"id": 4910421,
"name": "Orange or lemon",
"description": "",
.
.
.
}
},
{
"id": 4905955,
"name": "R E S I G N E D",
"description": "From the past of Tagus River, we have History and memories, some of them abandoned and disclaimed in their margins ...",
.
.
.
}
]
}
现在我们已经拥有了 JSON 数据，接下来我们就可以好好地利用它了。

使用如下代码替换掉viewDidLoad()中的 println(JSON)方法：

1
2
3
4
5
6
7
8
9
let photoInfos = (JSON!.valueForKey("photos") as [NSDictionary]).filter({
($0["nsfw"] as Bool) == false
}).map {
PhotoInfo(id: $0["id"] as Int, url: $0["image_url"] as String)
}

self.photos.addObjectsFromArray(photoInfos)

self.collectionView.reloadData()
上述代码将 JSON 数据转变为了更易于管理的`PhotoInfo`数组对象。这些对象只是简化掉了图片 ID 和 URL 属性的存储桶(bucket)。您同样可以发现代码过滤掉了一些……呃……您不希望出现的一些图片。

上述代码同样也重新加载了集合视图。初始项目的示例代码基于我们刚刚填充的`photos`，来创建集合视图的单元。

生成并运行您的应用，这时加载控件加载一会儿便消失。如果您仔细观察的话，您会发现一堆灰黑色方形单元：

099.jpg

离我们的目标越来越接近了，加油！

我们仍然定位到PhotoBrowserCollectionViewController.swift，在`collectionView(_: cellForItemAtIndexPath:)`方法中的return cell前加上如下的代码：

1
2
3
4
5
6
7
8
let imageURL = (photos.objectAtIndex(indexPath.row) as PhotoInfo).url

Alamofire.request(.GET, imageURL).response() {
(_, _, data, _) in

let image = UIImage(data: data! as NSData)
cell.imageView.image = image
}
上述的代码为`photos`数组中的图片创建了另外的 Alamofire 请求。由于这是一个图片请求，因此我们使用的是一个简单的request方法，其在NSData的blob 中返回响应。接下来我们直接把数据放入到一个UIImage的实例中，然后反过来将实例放入早已存在于示例项目中的imageView 当中。

再一次生成并运行您的应用，这时应当出现一个图片集合，与下图相似：

088.jpg

对于 Alamofire 的工作效果想必您现在已经心中有数，但是您不会想在每次从服务器请求数据的时候，要不停的复制、粘贴 API 地址，以及添加消费者密钥。除了这一点非常让人不爽外，如果 API 地址发生了改变，那么您可能不得不再次创建一个新的消费者密钥。

幸运的是，Alamofire对于这个问题有着良好的解决方案。

创建请求路由

打开Five100px.swift,然后找到struct Five100px，其中定义了enum ImageSize。这是一个简单的基于 500px.com 的 API 文件的结构体。

在使用 Alamofire 之前，您需要在文件顶部添加下述的必要声明：

1
import Alamofire
现在，在struct Five100px中的enum ImageSize上方添加下述代码：

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
enum Router: URLRequestConvertible {
static let baseURLString = "https://api.500px.com/v1"
static let consumerKey = "PASTE_YOUR_CONSUMER_KEY_HERE"

case PopularPhotos(Int)
case PhotoInfo(Int, ImageSize)
case Comments(Int, Int)

var URLRequest: NSURLRequest {
let (path: String, parameters: [String: AnyObject]) = {
switch self {
case .PopularPhotos (let page):
let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
return ("/photos", params)
case .PhotoInfo(let photoID, let imageSize):
var params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
return ("/photos/\(photoID)", params)
case .Comments(let photoID, let commentsPage):
var params = ["consumer_key": Router.consumerKey, "comments": "1", "comments_page": "\(commentsPage)"]
return ("/photos/\(photoID)/comments", params)
}
}()

let URL = NSURL(string: Router.baseURLString)
let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
let encoding = Alamofire.ParameterEncoding.URL

return encoding.encode(URLRequest, parameters: parameters).0
}
}
这就是我们所创建的路由，它为我们的 API 调用方法创建合适的URLString实例。它是一个简单的遵守URLRequestConertible协议的enum类型，这个协议是在 Alamofire 当中定义的。当有枚举类型采用该协议的时候，该类型就必须含有一个名为URLRequest的NSURLRequest类型变量。

这个路由含有两个静态常量：API 的baseURLString以及consumerKey。（最后一次声明，请`PASTE_YOUR_CONSUMER_KEY_HERE`替换为您自己的消费者密钥）现在，这个路由可以在必要的时候向最终的`URLString`中添加消费者密钥。

您的应用拥有三个 API 终结点(endpoint)：一个用来取出热门照片列表，一个用来取出某个特定照片的具体信息，一个用来取出某个照片的评论。路由将会借助三个相应的`case`声明来处理这三个终结点，每个终结点都会接收一到两个参数。

我们已经定义了`var URLRequest: NSURLRequest`作为计算(computed)属性。这意味着每次我们使用`enum`的时候，它都会构造出基于特定`case`和其参数的最终 URL。

这里有一个示例代码片段，说明了上述的逻辑关系：

1
2
3
4
Five100px.Router.PhotoInfo(10000, Five100px.ImageSize.Large)
// URL: https://api.500px.com/v1/photos/10000?consumer_key=xxxxxx&image_size=4
// https://api.500px.com/v1  +  /photos/10000  +  ?consumer_key=xxxxxx&image_size=4
// = baseURLString  +  path  +  encoded parameters
在上面的示例中，代码路由通过照片信息 API 的终结点来寻找一个 ID 为10000的大尺寸图片。注释行将 URL 的结构进行了拆分。在这个示例中，URL 由三个部分组成：`baseURLString`、`path`(?前面的那一部分)以及`[String: AnyObject]`字典，其中包含有传递给 API 终结点的参数。

对于`path`来说，返回元组的第一个元素可以用以下的字符串形式返回：

1
"/photos/\(photoID)" // "/photos/10000"
和响应解析类似，请求参数可以被编码为 JSON、属性列表或者是字符串。通常情况下使用简单的字符串参数，和上面我们所做的类似。

如果您打算在您自己的项目中使用路由，您必须对它的运行机制相当熟悉。为此，请尝试搞清楚要如何构造出以下的 URL：

https://api.foursquare.com/v2/users/{USER_ID}/lists?v=20131016&group=created

您是怎么做的呢？如果您不是百分百确定答案，请花一点时间来分析下面的代码，直到您完全搞明白其工作原理：

> 解决方案：

1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
static let baseURLString = "https://api.foursquare.com/v2"

case UserLists(Int)

var URLRequest: NSURLRequest {
let (path: String, parameters: [String: AnyObject]) = {
switch self {
case . UserLists (let userID):
let params = ["v": "20131016", "group": "created"]
return ("/users/\(userID)/lists", params)
}
}()
.
.
.
这里您需要为枚举添加其他的 case，比如说用户列表，它们都设置有合适的参数和路径。

加载更多图片

好的，现在应用目前显示的照片只有一个页面，但是我们想要浏览更多照片以找到我们心仪的内容。多多益善对吧？

打开PhotoBrowserCollectionViewController.swift，然后在 let refreshControl = UIRefreshControl()语句下方添加如下代码：

1
2
var populatingPhotos = false
var currentPage = 1
这里我们定义了两个变量，来记录当前是否在更新照片，以及当前我们正在浏览的是哪一个照片页面。

接下来，用以下代码替换当前`viewDidLoad()`的声明：

1
2
3
4
5
6
7
override func viewDidLoad() {
super.viewDidLoad()

setupView()

populatePhotos()
}
这里我们用populatePhotos()函数来替换了先前的 Alamofire 请求。之后我们就要实现populatePhotos()函数的声明。

同样的，在`handleRefresh()`上方添加两个函数，如下所述：

4444.jpg

啊……好长一段代码，对吧？下面是对每个注释部分的详细解释：

1. 一旦您滚动超过了 80% 的页面，那么scrollViewDidScroll()方法将会加载更多的图片。

2.populatePhotos()方法在currentPage当中加载图片，并且使用populatingPhotos作为标记，以防止还在加载当前界面时加载下一个页面。

3. 这里我们首次使用了我们创建的路由。只需将页数传递进去，它将为该页面构造 URL 字符串。500px.com 网站在每次 API 调用后返回大约50张图片，因此您需要为下一批照片的显示再次调用路由。

4. 要注意，.responseJSON()后面的代码块：completion handler(完成处理方法)必须在主线程运行。如果您正在执行其他的长期运行操作，比如说调用 API，那么您必须使用 GCD 来将您的代码调度到另一个队列运行。在本示例中，我们使用`DISPATCH_QUEUE_PRIORITY_HIGH`来运行这个操作。

5. 您可能会关心 JSON 数据中的photos关键字，其位于数组中的字典中。每个字典都包含有一张图片的信息。

6. 我们使用 Swift 的filter函数来过滤掉 NSFW 图片（Not Safe For Work）

7. map函数接收了一个闭包，然后返回一个PhotoInfo对象的数组。这个类是在Five100px.swift当中定义的。如果您查看这个类的源码，那么就可以看到它重写了isEqual和hash这两个方法。这两个方法都是用一个整型的id属性，因此排序和唯一化（uniquing）PhotoInfo对象仍会是一个比较快的操作

8. 接下来我们会在添加新的数据前存储图片的当前数量，使用它来更新collectionView.

9. 如果有人在我们滚动前向 500px.com 网站上传了新的图片，那么您所获得的新的一批照片将可能会包含一部分已下载的图片。这就是为什么我们定义var photos = NSMutableOrderedSet()为一个组。由于组内的项目必须唯一，因此重复的图片不会再次出现

10. 这里我们创建了一个NSIndexPath对象的数组，并将其插入到collectionView.

11. 在集合视图中插入项目，请在主队列中完成该操作，因为所有的 UIKit 操作都必须运行在主队列中

生成并运行您的应用，然后缓慢向下滑动图片。您可以看到新的图片将持续加载：

SlowScroll-179x320.png

不断加快滑动的速度，注意到问题没有？对的，滚动操作不是很稳定，有些许迟钝的感觉。这并不是我们想要提供给用户的体验，但是我们在下一节中就可以修正这个问题了。

创建自定义响应序列化方法(Serializer)

您已经看到，我们在 Alamofire 中使用所提供的 JSON、字符串，以及属性列表序列化方法是一件非常简单的事情。但是有些时候，您可能会想要创建自己的自定义相应序列化。例如，您可以写一个响应序列化方法来直接接收UIIMage，而不是将UIImage转化为NSData来接收。

在本节中，您将学习如何创建自定义响应序列化方法。

打开Five100px.swift，然后在靠近文件顶部的地方，也就是import Alamofire语句下面添加如下代码：

49.jpg

要创建一个新的响应序列化方法，我们首先应当需要一个类方法，其返回Serializer闭包（比如说上面所写的imageResponseSerializer()）。这个闭包在 Alamofire 中被类型命名，其接收三个参数并返回所示的两个参数，如下所示：

1
public typealias Serializer = (NSURLRequest, NSHTTPURLResponse?, NSData?) -> (AnyObject?, NSError?)
类方法（例如imageResponseSerializer()）接收底层的NSURLSession请求以及和响应对象一起的基本NSData数据实现方法（从服务器传来的），来作为参数。该方法接下来使用这些对象来序列化，并将其输入到一个有意义的数据结构中，然后将其从方法中返回，它同样也会返回在这个过程中发生的错误。在我们的示例中，我们使用UIImage来将数据转化为图片对象。

通常情况下，当您创建了一个响应序列化方法后，您可能还会向创建一个新的响应处理方法来对其进行处理，并让其更加易用。我们使用.responseImage()方法来完成这项任务。这个方法的操作很简单：它使用completionHandler，一个以闭包形式的代码块。一旦我们从服务器中序列化了数据，那么这个代码块将会运行。我们所需要做的就是在响应处理方法中调用 Alamofire 自己的通用.response()响应处理方法。

让我们开始让它工作起来。打开PhotoBrowserCollectionViewController.swift，然后在PhotoBrowserCollectionViewCell中的imageView属性下面，添加如下一个属性：

1
var request: Alamofire.Request?
这个属性会为这个单元存储 Alamofire 的请求来加载图片

现在将collectionView(_: cellForItemAtIndexPath:)的内容替换为下面所示的代码：

50.jpg

生成并运行您的应用，再次滚动图片，您会发现滚动变得流畅了。

为什么会流畅呢？

那么我们到底做了些什么来让滚动变得流畅了呢？其关键就是collectionView(_: cellForItemAtIndexPath:)中的代码。但是在我们解释这段代码之前，我们需要向您解释网络调用的异步性。

Alamofire 的网络调用是异步请求方式。这意味着提交网络请求不会阻止剩余代码的执行。网络请求可能会执行很长时间才能得到返回结果，但是您不会希望在等待图片下载的时候 UI 被冻结。

也就是说，实现异步请求是一个极大的挑战。如果在发出请求之后到从服务器接收到响应的这段时间中，UI 发生了改变的话怎么办？

例如，UICollectionView拥有内部的单元出列机制。创建新的单元对系统来说开销很大，因此集合视图将重用不在屏幕上显示的现有单元，而不是不停创建新的单元。

这意味着同一个单元对象，会被不停地重复使用。因此在发出 Alamofire 请求之后到接收到图片信息响应之前，用户将单元滚动出屏幕并且删除图片的操作将成为可能。单元可能会出列，并且准备显示另一个图片。

在上述的代码中，我们完成了两件事来解决这个问题。第一件事是，当一个单元出列后，我们通过设值为nil的方法来清除图片。这个操作确保我们不会显示原先的图片；第二件事是，我们的请求完成处理方法将检查单元的 URL 是否和请求的 URL 相等。如果不相等的话，显然单元已经拥有了另外的图片，那么完成处理方法将不会浪费其生命周期来为单元设置错误的图片
*/