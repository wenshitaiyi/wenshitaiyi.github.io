---
layout: post
title: 2024-06-15-MixPlorer使用
subtitle: 
aliases: 
date: 2024-06-15 18:44:39
author: 雯饰太一
header-img: img/post-bg-default.jpeg
tags:
  - mixplorer
  - 手机软件
  - 文件管理
typora-copy-images-to: ../img/post
typora-root-url: ../
---
> 该软件极度强悍，无所不能。

手机中的Telegram数据缓存目录位于Android/data/com.telegram.xxx下，但系统自带的图库无法访问这个目录。文件资源管理器可以看到内容，但没有图库的网格布局，这让我很苦恼。为了解决问题，尝试了其他图库浏览器，功能更强大，但同样无法访问。这可能是由于Android版本升级后权限变更导致。

尝试了代理系统资源管理器或授权图库浏览器访问Telegram数据目录，均未成功。使用了Shizuku软件，可以在无需root的情况下执行需要root权限的操作，但未找到下载的图库浏览器，方案放弃。

后来发现MiXplorer软件，支持多种资源展示，如列表和网格，甚至可以调整网格大小。MiXplorer内置的图像浏览器初步使用效果与系统图库相似，但功能更强大，对系统资源分类整合，如视频和音乐，并可添加目录到书签快速访问。

MiXplorer操作提示较少，初次使用可能有些门槛，翻译了官方文档以便更好理解和使用。

原文链接：[MiXplorer: Q&A and FAQ (User Manual) | XDA Forums](https://xdaforums.com/t/mixplorer-q-a-and-faq-user-manual.3308582/post-65157342)

翻译之后的文章如下：（好吧，我没有翻译，现在的AI翻译实在是太麻烦了，直接把结果贴在最后把）

emm，最后也没有放结果，还是直接去背英文单词吧。我觉得英文应该不是问题。

在使用软件的过程中，想要管理书签，但是书签的操作一直不是很明白，看完介绍文档之后，才知道：
- 创建书签：选中文件夹之后，右上角点开菜单，然后【添加至】，可以添加到书签
- 书签分组： 从左到右滑动可以对书签或者是分组进行编辑
	- 仅支持两级目录，不过应该也足够了
- 书签移动：长按图标可以上下移动
	- 长按文字会直接打开指定的书签

**ii. UI, NAVIGATION, VIEW CONFIGURATION, BOOKMARKS, TABS  
1) Primary UI Components  
2) Navigation  
3) Drawer (Bookmarks/History)  
4) Tabs  
5) Views (file folder list)  
6) "Home" page - described in MiX Nugget** - Home Page - [https://xdaforums.com/showpost.php?p=82781209&postcount=1168](https://xdaforums.com/showpost.php?p=82781209&postcount=1168)  
  
--------------------------------------  
**1) Primary UI Components**  
  
The names of various UI objects may be referenced throughout documentation (and are helpful to know when configuring theme). Here are the names of a few primary UI components along with the specific name for their background colors in the theme configuration. This is just as a reference point for the documentation. For more about skins and themes see that post.  
  
Status Bar: TINT_STATUS_BAR  
Main Bar: BG_BAR_MAIN  
Tab Bar: BG_BAR_TAB  
Tab Indicator: TINT_TAB_INDICATOR  
Selected Tab: TINT_TAB_INDICATOR_SELECTED  
Page: BG_PAGE  
Tools bar: BG_BAR_TOOLS  
Navigation Bar: TINT_NAVIGATION_BAR  
  
I) Action Bar: BG_BAR_ACTION The Action Bar appears in place of the Main Bar when one or more items is selected.  
  
J) Drawer: The Drawer can be opened by tapping Hamburger in Main Bar or swiping the Page from left edge toward right and takes it’s background color from BG_BAR_MAIN.  
  
--------------------------------------  
**2) Navigation **
  
To navigate through folders**; Tap the name of he folder you want to enter, or select a bookmark or history item. Note: Tapping the icon to the left will select and highlight the folder.  
  
**To go to the previously accessed folder:**; Press back button.  
  
**To go anywhere in the path you are browsing**: Tap the Location button in Main bar then tapping the part of the folder tree you want to go to.  
  
**To go to a manually entered location**: Long press the Address in the Main bar then tap “Enter the path”.  
Note the other things that can be done from this menu (The items in lists like this may change as MiXplorer evolves):  
- Copy path  
- Copy name  
- Enter the path  
- Create shortcut  
- Clear thumbnails cache  
- Properties  
  
**To search for items**: Tap the search icon, then you can start typing what you want to find in current folder.  
**To filter the search:** tap the leaning-hamburger, then select an option.  
**To search recursively (into sub-folders)**: Tap the right-angle arrow icon, then choose options and search criteria. See this FAQ Nugget for recursive and advanced search options: [https://xdaforums.com/t/mixplorer-q-a-and-faq-user-manual.3308582/post-82781351](https://xdaforums.com/t/mixplorer-q-a-and-faq-user-manual.3308582/post-82781351)  
  
**Regex**: Regex is a fairly powerful method of using expressions (wild-cards and variables) to do searches, and can also be used for renaming files.  
Harvesting information in this post [https://xdaforums.com/showpost.php?p=71218953&postcount=118](https://xdaforums.com/showpost.php?p=71218953&postcount=118)  
  
**To change the View level of details**: Tap the View button, then select an option.  
**To Add a file or folder**: Tap the Add button  
**To refresh the View**: Tap the Refresh button (or tap the Tab title, or tap the Location button in Main bar then tap the location).  
**To sort the view**: Tap the Sort button (A-Z icon)  
  
**To show or hide an item flagged as hidden**: With no items selected, tap overflow menu then tap "Show Hidden" or "Don't show hidden".  
**To exit MiXplorer**: Long-press Back button.  
  
------------------------------------  
**3) Bookmarks/History (Drawer)  
  
To open the Drawer for Bookmarks and History**: Tap hamburger in Main Bar, or swipe from the left edge toward right.  
  
**To create a Bookmark to a location on the device**: Navigate to the location, then long press the Location in the Main (top) Bar, then tap "Add to...", then tap "Bookmarks"; or Navigate to one level above the folder, then long press the folder in the file/folder list, then tap overflow menu, then tap "Add to...", then tap "Bookmarks". :  
  
**To create a Bookmark to a network share, server or cloud**: Open Drawer, then tap hamburger, then tap Add storage, then select and configure the type of storage. Note: The available cloud storage options may change over time. Here are examples of 2 common types of network bookmarks:  
  
1) **To access shared folder (SMB share) on PC or other computer on same local network.**:  
- Have a shared folder on a computer with file sharing and network discovery enabled.  
- Open MiXplorer on device connected to same network.  
- Bookmarks Drawer  
- Hamburger button  
- Add Storage  
- Custom  
- Search local  
- Enter credentials  
- If the search finds no shares there may be an issue with the sharing on the host or network between devices but you could try manual configuration.  

2) **To access an FTP Server on another device:**  
- Have an FTP server to connect to.  
- Bookmarks Drawer  
- Hamburger button  
- Add Storage  
- Custom  
- Enter server details (`ftp://<ipaddress>:<port>, user-name password`)  

**Notes about network and cloud bookmarks**:  

- When you create a connection to local network share or cloud via `<Bookmark Drawer - hamburger - Add storage>`, a Bookmark will automatically be created.  
  
- Depending on the type of network location, when you browse the network location you may or may not be able to create bookmarks to locations within that tree as described above. This should work for SMB shares on a computer or folders on another Android device accessed via MiXplorer FTP and might work for others.  
  
- When you save an off-device bookmark, some context sensitive additional configuration variables may or may not be added to the "Advance settings" field, which in some cases can be edited manually later.  
  
**To Delete or modify a bookmark**: Open the Drawer, then swipe the bookmark name to the right, then select appropriate action.  
  
**To rearrange bookmarks**: Open the Drawer, then tap and drag a bookmark by it’s icon up or down.  
  
**Sections** are labels which can be added to the bookmark list to organize bookmarks into groups. Tapping a bookmark section will expand or collapse the bookmarks between that section and the next section below it. Sections can be edited and moved in the same manner as bookmarks. Note: Moving a section will not bring the bookmarks under it to the new location - just the section itself. Arrangements of the groups must be done manually.  
  
**To create a custom category (similar to custom bookmark for a search) in the bookmark list**: Open 'All files' - Tap on the search button - Recursively - Enter file-name extensions eg; *.zip|*.rar|*.txt - Press GO - Long press the address bar - Add to bookmarks.  
  
**To reset the search-all-by=type folders (archive, apk,image, video, etc) if they are gray and don't work:** If you are updating from an older version of MiXplorer you may have to click on bookmark menu and choose "reset default" (which should preserve your own bookmarks) to recreate the new versions of the search bookmarks, then you can delete the gray ones.  
  
**Bookmark functions via the Bookmarks Menu**: Add storage Reset defaults; Remove all, Export. Note: To import bookmarks, open the exported .micfg file with MiXplorer and select import.  
  
**To switch between Bookmarks and History** : Open Drawer then tap the Bookmarks or History label in top Bar.  
  
**To clear history**: Open Drawer to History, then tap mini-hamburger.  
  
--------------------------------------  
**4) Tabs**  
  
1st Tab is left-most. Last Tab is right-most. New tabs will open to the right of the active tab.  
  
General Tab functions can be accessed via the tab menu and are context sensitive, based on Tab bar visibility and tab arrangement.  
  
Some functions can can be accessed by long pressing on a Tab when the Tab Bar is visible.  
  
**To refresh a Tab’s view**: Swipe down, or tap on the name in the Tab Bar, or tap the location name in main bar then tap it again in the drop down.  
  
**To open a new tab**:  
- Open Bookmarks/History  
- Long press on the item that you want to open in a new tab  
or  
- Select a folder in the main page  
- Tap the overflow menu in the action bar  
- Tap "Open in new tab",  
or;  
- Tap the Tab menu then tap "Add new tab"  
or;  
- When on last (right-most) tab, Swipe from right edge to left (depends on "Settings" - ""More Settings" - "Swiping in first and last...")  
  
  
**Save single tab as default tab or to save a group of tabs (Note: "Save" may occasionally be referred to as "Pin")**  
  
**To save an individual Tab be opened to a specific location at each app start (default tab)**  
- Have only one tab opened.  
- Navigate to desired location.  
- Long press on Tab Title then tap "Set as default".  
- Open the Tab drop-down menu, select, "Save tabs", Tap "Now" (leave "On Exit" un-selected).  
  
**To save a group of tabs (tab-set) to be opened at each app start**:  
- Create the tabs, and open each to the location of your choice.  
- To set the default tab (to be active at app start) long press on Tab Title then tap "Set as default".  
- Open the Tab drop-down menu, select, "Save tabs", Tap "Now" (leave "On Exit" un-selected).  
Note: View detail level and sort order should be remembered per tab.  
  
**To have MiXplorer save the tab-set that is in place at each app close (to be opened at next app app start)**:  
- Open the Tab menu.  
- Select check box: "On Exit".  
  
**To reset tabs to whatever was last saved by 'Save tabs - Now" or by "Save tabs - On exit"**:  
- Open the Tab menu then tap Reset tabs. Each Tab's view level and sort order should be remembered and not be reset by this action.  
  
  
**5) Views (file folder list)**  
  
There are many ways to configure the file/folder list views using the "View" and "Sort" buttons which appear in the Tools bar at the bottom (in the default skin and configuration). Here are a few of the more notable functions:  
  
- "View" button - "Recursive data": When "Recursive data" is enabled (and after a refresh of the view) MiXplorer will calculate and show the quantity of items and storage space uses in sub-folders.  
  
- "View" button - "Reset defaults": When "Reset defaults" is enabled then pinch zoom settings can be reset to default for each drive independently by going to root of drive, then selecting a view mode (eg "Detailed"). To maintain the different zoom levels disable "Reset defaults".  
  
- "Pin" an item to top of list: A folder or file can be "Pinned" so it stays at the top of the list view regardless of sort options. To pin/unpin an item: Select it then open menu then select pin/unpin. Similarly, apps in the "Open with" list can be pinned to the top of that list by long pressing the app then tapping "Pin"  
  
- Create a custom thumbnail: To create a custom thumbnail for a folder (which would be used when "Auto folder preview" is enabled in main settings) put the image you want to use for the thumbnail in the folder and rename it to .preview.  
  
- Gallery style view for search folders: For the search folders which show all of a certain file type (eg Audio, Document, Image, Video), there is a gallery style view which shows all images of the designated type on the device but grouped in folders by location similar to the way most default gallery apps work. To enable this mode: Tap the "Sort" button then enable "By parent". To show all items in one list without the folders, disable "By parent"  
  
- App, User App, System App: When viewing contents of the "App" search bookmark, tapping on Location allows choice of App (all), User App, System App. To create a custom bookmark to any of those: Tap the Location in Main Bar, then select desired view (App, User App, or System App) then long press location and "Add to" bookmarks.  
  
**6) "Home" page**  
  
A full page panel containing locations with details, described in more detail here: MiX Nugget - Home Page - [https://xdaforums.com/showpost.php?p=82781209&postcount=1168](https://xdaforums.com/showpost.php?p=82781209&postcount=1168)  
  
**View Customization** (more in Skins/Themes)  
  
**Disable Thumbnails (folder specific}:** Place image in folder > rename to .nothumbnail  
**Custom Folder Icon (folder specific):** Place image in folder > rename to .foldericon  
**Custom Folder Icon Preview (folder specific)**: Place image in folder > rename to. preview  
  
Notes:  
- Some image properties may not function properly. Icons can be optimized here: [https://tinypng.com/](https://tinypng.com/)  
- Some of these may depend on a related setting within the app (eg .preview file and setting "Auto folder preview")