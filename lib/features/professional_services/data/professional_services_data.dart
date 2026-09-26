import 'package:flutter/material.dart';

import '../domain/models/professional_service.dart';

const List<ProfessionalService> professionalServices = [
  ProfessionalService(
    id: 'campaign_management',
    title: 'إدارة حملة إشهارية كاملة',
    shortDescription:
    'نتولى إدارة حملتك الإعلانية من البداية إلى النهاية.',
    description:
    'خدمة متكاملة لمساعدتك على تخطيط وتنفيذ ومتابعة حملتك الإعلانية '
        'مع المؤثرين المناسبين وتحليل النتائج بعد انتهاء الحملة.',
    icon: Icons.campaign_outlined,
    priceFrom: '50,000 دج',
    features: [
      'دراسة الهدف من الحملة',
      'اختيار المؤثرين المناسبين',
      'تحديد خطة المحتوى',
      'متابعة تنفيذ الحملة',
      'تحليل النتائج',
      'تقرير نهائي للحملة',
    ],
  ),

  ProfessionalService(
    id: 'influencer_selection',
    title: 'اختيار المؤثرين المناسبين',
    shortDescription:
    'نساعدك على اختيار أفضل المؤثرين حسب نشاطك وجمهورك.',
    description:
    'يقوم فريق المنصة بتحليل نشاطك التجاري والجمهور المستهدف '
        'ثم اقتراح مجموعة من المؤثرين الأكثر توافقاً مع أهداف الحملة.',
    icon: Icons.people_alt_outlined,
    priceFrom: '15,000 دج',
    features: [
      'تحليل النشاط',
      'تحليل الجمهور المستهدف',
      'اختيار مؤثرين حسب المجال',
      'مقارنة نسب التفاعل',
      'اقتراح أفضل الخيارات',
    ],
  ),

  ProfessionalService(
    id: 'marketing_strategy',
    title: 'إعداد استراتيجية تسويقية',
    shortDescription:
    'خطة تسويق احترافية مناسبة لمنتجك أو خدمتك.',
    description:
    'نقوم بإعداد استراتيجية تسويقية متكاملة تشمل تحديد الجمهور، '
        'القنوات المناسبة، نوع المحتوى والميزانية المقترحة.',
    icon: Icons.insights_outlined,
    priceFrom: '25,000 دج',
    features: [
      'تحليل السوق',
      'تحديد الجمهور',
      'اختيار القنوات',
      'خطة محتوى',
      'خطة زمنية',
      'تقدير الميزانية',
    ],
  ),

  ProfessionalService(
    id: 'content_creation',
    title: 'صناعة المحتوى الإعلاني',
    shortDescription:
    'إعداد محتوى احترافي مناسب للحملات والإعلانات.',
    description:
    'يساعدك فريق X Ten في إعداد أفكار ومحتوى إعلاني '
        'متناسب مع طبيعة المنتج والمنصة الاجتماعية المستخدمة.',
    icon: Icons.video_camera_back_outlined,
    priceFrom: '20,000 دج',
    features: [
      'كتابة فكرة الإعلان',
      'كتابة النص الإعلاني',
      'تصميم منشورات',
      'أفكار Reels و Stories',
      'مراجعة المحتوى',
    ],
  ),

  ProfessionalService(
    id: 'analytics',
    title: 'تحليل أداء الحملة',
    shortDescription:
    'تقارير وتحليلات تساعدك على معرفة نتائج حملتك.',
    description:
    'تحليل أداء المؤثرين والحملة الإعلانية باستخدام مؤشرات '
        'المشاهدة والتفاعل والوصول والتحويل.',
    icon: Icons.analytics_outlined,
    priceFrom: '10,000 دج',
    features: [
      'تحليل المشاهدات',
      'تحليل التفاعل',
      'تحليل الوصول',
      'مقارنة المؤثرين',
      'تقرير الأداء',
    ],
  ),

  ProfessionalService(
    id: 'legal',
    title: 'العقود والحماية القانونية',
    shortDescription:
    'إعداد ومراجعة الاتفاقيات بين المعلن والمؤثر.',
    description:
    'خدمة لتسهيل الاتفاق بين الأطراف وحماية حقوق المعلن والمؤثر '
        'من خلال اتفاقيات واضحة ومراحل عمل موثقة.',
    icon: Icons.gavel_outlined,
    priceFrom: 'حسب الطلب',
    features: [
      'إعداد اتفاقية',
      'تحديد الالتزامات',
      'تحديد مراحل التسليم',
      'توثيق الموافقات',
      'حفظ الحقوق',
    ],
  ),

  ProfessionalService(
    id: 'account_manager',
    title: 'مدير حساب مخصص',
    shortDescription:
    'متابعة مباشرة من مستشار متخصص في المنصة.',
    description:
    'نوفر لك مدير حساب لمتابعة الحملات والمشاريع '
        'والتواصل مع المؤثرين وتسهيل جميع خطوات العمل.',
    icon: Icons.support_agent_outlined,
    priceFrom: 'اشتراك شهري',
    features: [
      'متابعة شخصية',
      'دعم مباشر',
      'تنسيق الحملات',
      'متابعة المؤثرين',
      'تقارير دورية',
    ],
  ),
];