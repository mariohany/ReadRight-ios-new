//
//  OnBoardingVC.swift
//  readright
//
//  Created by concarsadmin-mh on 08/12/2021.
//

import AVFoundation
import UIKit

class OnBoardingVC : UIViewController {
    
    var tourText:[String] = []
    var tourTitle:[String] = []
    var audioPlayer: AVAudioPlayer?
    var currentSlide: Int = 0
    @IBOutlet weak private var nextBtn: UIButton!
    @IBOutlet weak private var prevBtn: UIButton!
    @IBOutlet weak private var slideTitle: UILabel!
    @IBOutlet weak private var slideText: UILabel!
    @IBOutlet weak private var slideNumber: UILabel!
    @IBOutlet weak private var slideImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadOnBoardingTexts()
        slideNumber.text = "\(Helpers.arabicCharacter(englishNumber: Constants.TOUR_SLIDES)) / \(Helpers.arabicCharacter(englishNumber: currentSlide+1))"
        slideImage.image = UIImage(named: String(format:"%d", currentSlide+1))
        slideTitle.text = tourTitle[currentSlide]
        slideText.text = tourText[currentSlide]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "نظرة عامة"
        self.navigationController?.navigationBar.topItem?.title = "نظرة عامة"
    }
    
    @IBAction private func playVoiceOver(){
        if let audioPlayer = audioPlayer {
            if !audioPlayer.isPlaying {
                audioPlayer.currentTime = 0;
                audioPlayer.play()
            }else{
                audioPlayer.stop()
                self.audioPlayer = nil
            }
        }else{
            audioPlayer = Helpers.getAudioPlayer(fileName: Constants.TOUR_VOICE_OVER_ARRAY[currentSlide])
            audioPlayer?.play()
        }
    }
    
    @IBAction private func pressNextBtn(){
        next()
        audioPlayer = nil
    }
    
    @IBAction private func pressPrevBtn(){
        prev()
        audioPlayer = nil
    }
    
    
    func next(){
        if(currentSlide < Constants.TOUR_SLIDES - 1){
            currentSlide += 1;
            self.slideNumber.text = "\(Helpers.arabicCharacter(englishNumber: Constants.TOUR_SLIDES)) / \(Helpers.arabicCharacter(englishNumber: currentSlide+1))"
            self.slideImage.image = UIImage(named: String(format:"%d", currentSlide+1))
            self.slideText.text = tourText[currentSlide]
            self.slideTitle.text = tourTitle[currentSlide]
        }
    }
    
    func prev(){
        if(currentSlide > 0){
            currentSlide -= 1;
            self.slideNumber.text = "\(Helpers.arabicCharacter(englishNumber: Constants.TOUR_SLIDES)) / \(Helpers.arabicCharacter(englishNumber: currentSlide+1))"
            self.slideImage.image = UIImage(named: String(format:"%d", currentSlide+1))
            self.slideText.text = tourText[currentSlide]
            self.slideTitle.text = tourTitle[currentSlide]
            
        }
    }
    
    func loadOnBoardingTexts(){
        tourTitle.append("مرحباً بك في علاج إقراء لتكون")
        tourTitle.append("المعلومات الشخصية")
        tourTitle.append("الإختبارات")
        tourTitle.append("الإختبارات")
        tourTitle.append("اختبار القراءة")
        tourTitle.append("اختبار القراءة")
        tourTitle.append("اختبار القراءة")
        tourTitle.append("اختبار المجال البصري")
        tourTitle.append("اختبار المجال البصري")
        tourTitle.append("اختبار المجال البصري")
        tourTitle.append("اختبار المجال البصري")
        tourTitle.append("اختبار الإهمال البصري")
        tourTitle.append("اختبار الإهمال البصري")
        tourTitle.append("تقييم أنشطة الحياة اليومية")
        tourTitle.append("تقييم أنشطة الحياة اليومية")
        tourTitle.append("تقييم أنشطة الحياة اليومية")
        tourTitle.append("اختبار البحث النظري")
        tourTitle.append("اختبار البحث النظري")
        tourTitle.append("اختبار البحث النظري")
        tourTitle.append("العلاج")
        tourTitle.append("العلاج")
        tourTitle.append("العلاج")
        tourTitle.append("العلاج")
        tourTitle.append("العلاج")
        tourTitle.append("العلاج")
        tourTitle.append("العلاج")
        tourTitle.append("النتائج")
        tourTitle.append("النتائج")
        tourTitle.append("مساعدة")
        
        tourText.append("لقد قمت بالتسجيل للعلاج باستخدام خيار (التسجيل) علي أول الشاشة. وفى المستقبل إذا كنت بحاجة إلى استخدام التطبيق، حدد قسم (تسجيل الدخول) من أجل الدخول على حسابك مع جميع النتائج المحفوظة.")
        tourText.append("من الممكن استعراض المعلومات الشخصية وجهات الاتصال ودراسة الحالة وتغييرها على تبويب (حسابي).")
        tourText.append("قبل أن تبدأ العلاج، تحتاج إلى إجراء ستة اختيارات. كما سيُطلب منك بأن تكرر هذه الاختبارات بعد كل خمس ساعات من العلاج من أجل تقييم التقدم المحرز الخاص بك.")
        tourText.append("يتم إجراء الاختبارات واحداً تلو الآخر في تسلسل واحد. وبعد أن تنتهي من إجراء جميع الاختبارات الستة، سوف يتم نقلك تلقائياً إلى قسم العلاج.")
        tourText.append("يتم إجراء اختبار القراءة مرتين خلال جلسة اختبار واحدة. وسوف يُعرض لك ٣ فقرات. يرجى قراءة كل كلمة في الفقرة.")
        tourText.append("عندما تنتهي من القراءة، سوف تحتاج لإجابة السؤال.")
        tourText.append("سوف يقيس هذا الاختبار سرعتك قي القراءة. وعليك أن تتوقع بأن ترى التحسنات بعد ٢٠ ساعة من العلاج، بالرغم أنك قد ترى التغيرات قبل ذلك.")
        tourText.append("سوف يقيس هذاالاختبار المجال البصري لديك، يرجى قراءة واتباع التعليمات التي تظهر قبل الاختبار بعناية.")
        tourText.append("يرجى النظر إلى الصليب الأحمر في كل الأوقات، فسوف يومض وبعد ذلك ستظهر بعض النقاط لفترة وجيزة.")
        tourText.append("سوف يُظهر لك بعد ذلك أربعة أنماط للنقطة، يرجى اختيار النمط الذي رأيته بعناية. وإذا لم تكن متأكداً، استخدم زر (كرر).")
        tourText.append("توضح النتائج المجال البصري لديك. وليس من المحتمل أن تتحسن هذه النتائج، لأن العلاج يهدف إلي تحسين حركات العين القارئة وليس المجال البصري للمريض.")
        tourText.append("يهدف هذا الاختبار إلى معرفة ما إذا كنت تستطيع العثور على الاهداف المتناثرة علي كامل المجال البصري لديك. ويجب أن تنقر فقط على كل الأهداف التي بها فجوة عند القمة. وانقر فوق كل هدف مرة واحدة فقط. ")
        tourText.append("عندما تنقر فوق الهدف الصحيح، سوف يومض بلون أخضر لفترة وجيزة. لديك ٥ دقائق فقط للعثور على جميع الأهداف. و في نهاية الاختبار سوف يُظهر لك نسبة الأهداف التي حددت موقعها بشكل صحيح.")
        tourText.append("يهدف الاختبار لمعرفة كيف تؤثر مشكلتك البصريةعلى حياتك. نريد منك أن تقيّم أي صعوبات قد تكون لديك مع المجالات الستة المحددة. وسوف يُطلب منك بأن تقيمها واحدة تلو الأخرى عن طريق الإجابة بنعم أو لا.")
        tourText.append("بإختيارك لا، سوف يتم نقلك إلى المجال التالي. وبإختيارك نعم، سوف تحتاج إلى تقييم مدى الصعوبة في هذا المجال باستخدام شريط الصعوبات.")
        tourText.append("إذا فاتك شيء، يمكنك العودة، انقر فوق المجال وغير تقييمه باستخدام زر (التغيير).")
        tourText.append("يهدف هذا الاختبار إلى معرفة مدى السرعة التي يمكنك بها أن تعثر على الأهداف على طاولة مزدحمة. وفي كل مرة عليك أن تجد هدفاً جديداً")
        tourText.append("إذا قمت باختيار هدف غير الهدف الصحيح يتم تمييزه باللون الأحمر. وتحتاج إلى مواصلة البحث من أجل العثور على الهدف الصحيح.")
        tourText.append("إذا قمت باختيار الهدف الصحيح سيتم تمييزه باللون الأخضر وسوف يُظهر لك الهدف التالي.")
        tourText.append("يمكنك إما أن تختار كتباً من المكتبة أو مقالات حية. وبمجرد أن تختار النص، سيتم تمرير النص أمامك خلال نافذة القراءة.")
        tourText.append("استخدم الشريط المنزلق من أجل ضبط سرعة النص المتحرك بحيث يمكنك القراءة بشكل مريح.")
        tourText.append("عندما تأخذ قسطا من الراحة من القراءة، من المهم جداً أن تحدد زر (الإيقاف المؤقت) من أجل وقف حركة النص. لأن إذا لم تفعل سيفترض التطبيق بأنك مازلت تقراء النص بشكل نشط! ومن أجل المواصلة، حدد زر(التشغيل).")
        tourText.append(" حدد زر (إعادة التشغيل) إذا كنت تريد تشغيل النص من البداية مرة أخرى. ويمكنك قراءة نفس الفصل عدة مرات كما يحلو لك.")
        tourText.append("يظهر لك شريط تقدمك حتى يوضح أين تكون خلال الفصل. ويمكنك ضبطه إذا كنت تريد القفز إلى نقطة معينة من النص.")
        tourText.append("من أجل تغيير لون النص ولون الخلفية حدد زر (الضبط).")
        tourText.append("يمكنك أن تختار لون النص وخلفية النص من بين عدة ألوان معينة مسبقاً.")
        tourText.append("من أجل التحقق من مقدار وقت العلاج به لهذا اليوم أو للأيام السابقة، انتقل إلى قسم (العلاج بالقراءة) في تبويب (النتائج).")
        tourText.append("يمنك أن تعرف نتائج جميع الاختبارات التي أجريتها باستخدام هذا التطبيق من خلال تبويب (النتائج).")
        tourText.append("حدد (نظرة عامة) من شريط التبويب إذا كنت تحتاج إلي تشغيل هذه الجولة مرة أخرى. أو حدد (مساعدة) للحصول على مزيد من المعلومات حول التطبيق.")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer = nil
    }
}
