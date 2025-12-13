// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Projek 移动';

  @override
  String get profile => '个人资料';

  @override
  String get editProfile => '编辑资料';

  @override
  String get paymentMethods => '支付方式';

  @override
  String get darkMode => '深色模式';

  @override
  String get notification => '通知';

  @override
  String get security => '安全';

  @override
  String get signOut => '退出';

  @override
  String get language => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get english => 'English';

  @override
  String get mandarin => 'Mandarin (中文)';

  @override
  String get korean => 'Korean (한국어)';

  @override
  String get japanese => 'Japanese (日本語)';

  @override
  String get indonesian => 'Indonesian (Bahasa Indonesia)';

  @override
  String get german => 'German (Deutsch)';

  @override
  String get premium => '高级';

  @override
  String get cart => '购物车';

  @override
  String get basic => '基本';

  @override
  String get comingSoon => '即将推出';

  @override
  String get signIn => '登录';

  @override
  String get signUp => '注册';

  @override
  String get signUpDescription => '使用您的电子邮件注册并继续使用我们的应用程序。';

  @override
  String get enterUsername => '输入您的用户名';

  @override
  String get enterEmail => '输入您的电子邮件';

  @override
  String get enterPassword => '输入您的密码';

  @override
  String get reEnterPassword => '重新输入您的密码';

  @override
  String get agreeToTermsText => '创建此账户，即表示我承认我已阅读并同意';

  @override
  String get termsOfService => '服务条款';

  @override
  String get and => ' 和 ';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get emailAlreadyRegistered => '此电子邮件已被注册 (Firebase)。';

  @override
  String get forgotPassword => '忘记密码';

  @override
  String get insertPin => '输入 PIN';

  @override
  String get forgotPin => '忘记 PIN';

  @override
  String get buildProfile => '建立档案';

  @override
  String get buildYourProfile => '建立您的档案';

  @override
  String get descBuildProfile => '花些时间填写您的档案，以便我们为您创建更个性化和无缝的体验。';

  @override
  String get history => '历史';

  @override
  String get notificationsDeleted => '已删除通知';

  @override
  String get itemsDeletedFromCart => '已从购物车删除项目';

  @override
  String get undo => '撤销';

  @override
  String get clearPurchaseHistory => '清除购买历史';

  @override
  String get cancel => '取消';

  @override
  String get confirmDeleteTitle => '确认删除';

  @override
  String get confirmDeleteCartContent => '您确定要从购物车中删除所选项目吗？';

  @override
  String get confirmDeleteNotifications => '您确定要删除选定的通知吗？';

  @override
  String get delete => '删除';

  @override
  String get selectVoucher => '选择优惠券';

  @override
  String get discount20 => 'DISCOUNT20 - 节省 \$16.3';

  @override
  String get freeship => 'FREESHIP - 免运费';

  @override
  String get failedToDeleteItems => '删除项目失败';

  @override
  String get historyCleared => '历史已清除。';

  @override
  String get noNewCoursesToPurchase => '没有新课程可以购买。';

  @override
  String get courseVideosTitle => '课程视频';

  @override
  String moduleTitle(Object number) {
    return '第 $number 单元 - 介绍';
  }

  @override
  String get video => '视频';

  @override
  String get resource => '资源';

  @override
  String get username => '用户名';

  @override
  String get fullName => '全名';

  @override
  String get dateOfBirth => '出生日期';

  @override
  String get phoneNumber => '电话号码';

  @override
  String get country => '国家';

  @override
  String get gender => '性别';

  @override
  String get male => '男性';

  @override
  String get female => '女性';

  @override
  String get continueButton => '继续';

  @override
  String get pleaseCompleteFields => '请完成所有字段。';

  @override
  String get welcome => '欢迎！';

  @override
  String get toKeepConnected => '为了与我们保持联系，请使用您的个人信息登录。';

  @override
  String get forgotPasswordQuestion => '忘记密码？';

  @override
  String get doNotHaveAccount => '没有账户？';

  @override
  String get alreadyHaveAccount => '已有账户？';

  @override
  String get aboutCourse => '关于课程';

  @override
  String get whatSkillYouGain => '您将学到的技能';

  @override
  String get syllabus => '课程大纲';

  @override
  String get getStarted => '开始';

  @override
  String get whatInterestsYou => '你对什么感兴趣？';

  @override
  String get chooseYourInterest => '选择您的兴趣以开始学习我们的课程。';

  @override
  String get chooseInterest => '选择您的兴趣';

  @override
  String get setYourPIN => '设置您的 PIN';

  @override
  String get pinDescription => '设置安全 PIN 以保护您的账户，确保只有您可以访问它。';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get newPassword => '新密码';

  @override
  String get changePassword => '更改密码';

  @override
  String get changePIN => '更改 PIN';

  @override
  String get setupComplete => '设置完成！';

  @override
  String get certificateTitle => '证书';

  @override
  String get apiDemo => 'API 演示';

  @override
  String get instructor => '讲师';

  @override
  String instructorLabel(Object instructor) {
    return '讲师：$instructor';
  }

  @override
  String status(Object status) {
    return '状态：$status';
  }

  @override
  String get statusLabel => '状态：';

  @override
  String get myCourses => '我的课程';

  @override
  String get myCoursesTitle => '我的课程';

  @override
  String get noCourses => '没有课程';

  @override
  String get purchasedDate => '已购买';

  @override
  String get allCategories => '全部';

  @override
  String get registrationSuccessful => '注册成功。继续建立您的档案。';

  @override
  String get emailValidation => '电子邮件必须是有效的 @gmail.com 地址。';

  @override
  String get passwordValidation => '密码必须至少 8 个字符，包括大写、小写和符号。';

  @override
  String get passwordMismatch => '密码不匹配。';

  @override
  String get agreeTerms => '您必须同意条款和隐私政策。';

  @override
  String get fillAllFields => '请填写所有字段。';

  @override
  String get emailPasswordRequired => '电子邮件和密码不能为空。';

  @override
  String get invalidCredentials => '无效的电子邮件或密码。';

  @override
  String get passwordUpdateSuccess => '密码成功更新。';

  @override
  String get pinUpdateSuccess => 'PIN 成功更新。';

  @override
  String get passwordSecurityTitle => '密码安全';

  @override
  String get resetYourPassword => '重置您的密码';

  @override
  String get contactUs => '联系我们';

  @override
  String get noOrdersFound => '未找到订单';

  @override
  String get reviewSlider => '评论滑块';

  @override
  String get myCertificates => '我的证书';

  @override
  String get noCertificates => '暂无证书';

  @override
  String get emptyCart => '您的购物车是空的';

  @override
  String get databaseReset => '数据库重置';

  @override
  String get resetDatabase => '重置数据库';

  @override
  String get resettingDatabases => '正在重置数据库...';

  @override
  String get readyStatus => '就绪';

  @override
  String get databaseResetSuccess => '数据库成功重置！';

  @override
  String get bestseller => '畅销';

  @override
  String get languageEnglish => 'English';

  @override
  String availableSubtitle(Object subtitle) {
    return '可用字幕：$subtitle';
  }

  @override
  String get youMayLikeTheseCourses => '您可能喜欢这些课程';

  @override
  String get addedToCart => '已加入购物车';

  @override
  String get addedToCartOffline => '已加入购物车（离线）';

  @override
  String get alreadyInCart => '已在购物车中';

  @override
  String get buyCourse => '购买课程';

  @override
  String get priceLabel => '价格';

  @override
  String get itemsLabel => '项目';

  @override
  String get emptyCartDescription => '将您感兴趣的课程添加到您的愿望清单，随时结账开始学习。';

  @override
  String get allNotifications => '全部';

  @override
  String get unread => '未读';

  @override
  String get noNotification => '暂无通知';

  @override
  String get noNotificationDescription => '崭新开始！当有值得关注的内容时，我们会告知您。';

  @override
  String get markAsRead => '标记为已读';

  @override
  String get markAsUnread => '标记为未读';

  @override
  String get reminderSet => '提醒已设置！';

  @override
  String reminderSetOn(Object datetime) {
    return '提醒设置于：$datetime';
  }

  @override
  String get startContinueCourse => '开始/继续课程';

  @override
  String get viewCertificate => '查看证书';

  @override
  String get explore => '探索';

  @override
  String get student => '学生';

  @override
  String get subtitles => '字幕';

  @override
  String get moreOptions => '更多选项';

  @override
  String get back => '返回';

  @override
  String get next => '下一步';

  @override
  String get start => '开始';

  @override
  String get search => '搜索';

  @override
  String get learnPrompt => '您今天想学习什么？';

  @override
  String get trendingNow => '当前热门';

  @override
  String get recommendedForYou => '为您推荐';

  @override
  String get categories => '分类';

  @override
  String get seeAll => '查看全部';

  @override
  String get popularForPrefix => '热门类别：';

  @override
  String get add => '添加';

  @override
  String get remove => '移除';

  @override
  String get shareCourse => '分享课程';

  @override
  String get setReminder => '设置提醒/日程';

  @override
  String get viewCourseDetails => '查看课程详情';

  @override
  String get findYourCourse => '找到您的课程';

  @override
  String get discoverCourses => '发现您真正感兴趣的课程，以轻松有趣的方式开始学习。';

  @override
  String get searchCourse => '搜索课程';

  @override
  String get account => '账户';

  @override
  String get support => '支持';

  @override
  String get contactSupport => '联系支持';

  @override
  String get menu => '菜单';

  @override
  String get clearHistory => '清除歴史';

  @override
  String get clearHistoryConfirm => '你确定要清除你的歴史吗？此操作不能撤销。';

  @override
  String get yourPaymentMethods => '您的支付方式';

  @override
  String get paymentSuccessful => '支付成功！';

  @override
  String get addNewCard => '添加新卡';

  @override
  String get certificate => '证书';

  @override
  String get contact => '联系';

  @override
  String get videoPlay => '播放视频';

  @override
  String get areYouSureSignOut => '你确定要退出吗';

  @override
  String get save => '保存';

  @override
  String get uploadChangePhoto => '上传/更换照片';

  @override
  String get cardNumber => '卡号';

  @override
  String get expiryDate => '到期日期';

  @override
  String get cvvLabel => 'CVV';

  @override
  String get enterCardNumber => '请输入卡号';

  @override
  String get enterExpiryDate => '请输入到期日期';

  @override
  String get enterCVV => '请输入CVV';

  @override
  String get saveCardDetails => '保存此卡及详细信息以便更快支付';

  @override
  String get addCard => '添加卡片';

  @override
  String get profileUpdatedSuccessfully => '个人资料更新成功。';

  @override
  String get noActiveSession => '无活跃会话。请重新登录。';

  @override
  String get cardAlreadyAdded => '此卡已添加。';

  @override
  String get videoPlayer => '视频播放器';

  @override
  String get certificateOfAchievement => '成就证书';

  @override
  String get viewCourseClicked => '查看课程已点击';

  @override
  String get searchForACourse => '搜索课程';

  @override
  String get subtitleClicked => '字幕已点击';

  @override
  String get previousClicked => '上一个已点击';

  @override
  String get nextClicked => '下一个已点击';

  @override
  String get completed => '已完成';

  @override
  String get cancelled => '已取消';

  @override
  String get historyEmptyDescription => '浏览您喜欢的课程，将它们加入购物车，准备好学习新知识时再结账。';

  @override
  String get takePhoto => '拍照';

  @override
  String get chooseFromGallery => '从相册选择';

  @override
  String get permissionNotGrantedTitle => '需要权限';

  @override
  String get permissionNotGrantedMessage => '此功能需要权限。请在设置中授予权限。';

  @override
  String get openSettings => '打开设置';

  @override
  String get selectInterestsDescription => '选择最让你兴奋的技术主题，我们将围绕你真正想探索的内容构建你的旅程。';

  @override
  String get selectAtLeastOneInterest => '请至少选择一个兴趣。';
}
