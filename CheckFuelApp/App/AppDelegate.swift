import UIKit
import Firebase
import FirebaseMessaging
import AppsFlyerLib


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("🚀 AppDelegate start")
        FirebaseApp.configure()
        
         UNUserNotificationCenter.current().delegate = self
         UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
         print("🔔 Push permission: \(granted)")
         DispatchQueue.main.async { UIApplication.shared.registerForRemoteNotifications() }
         }
         Messaging.messaging().delegate = TokenStore.shared
         
        
        TokenStore.shared.start()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        print("✅ Firebase configured")
        
        
        AppsFlyerLib.shared().appsFlyerDevKey = "mpNYjAVqWiS5DMw4sBXsRG"
        AppsFlyerLib.shared().appleAppID     = "6670198961"
        AppsFlyerLib.shared().delegate       = self
       // AppsFlyerLib.shared().isDebug        = true // пока тестируешь
        
        AppsFlyerLib.shared().start()
        
        // Генерация UUID + AdServices token
        let uuid = DeviceIDProvider.persistedLowerUUID()
        let att = AdServicesTokenProvider.fetchBase64Token()
        
        // Лог сессии в Realtime DB
        FirebaseLogger.logSession(uuid: uuid, attToken: att)
        
        // Передадим контекст в StartGateService (чтобы логировать дальнейшие события)
        StartGateService.shared.configureSession(uuid: uuid, attToken: att)
        
        // Окно и стартовый VC
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LaunchViewController()
        window?.makeKeyAndVisible()
        print("✅ UIWindow + LaunchViewController set")

        
        return true
    }
    
    func application(_ application: UIApplication,
                     supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        let m = OrientationManager.shared.mask
        print("🧭 supportedInterfaceOrientations → \(m)")
        return m
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("✅ APNs token set for FirebaseMessaging")
    }
    
}

final class OrientationManager {
    static let shared = OrientationManager()
    private init() {}
    
    var mask: UIInterfaceOrientationMask = .all
}

extension AppDelegate: MessagingDelegate, UNUserNotificationCenterDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("✅ FCM token: \(fcmToken ?? "nil")")
        // отправь на свой backend если нужно
    }
}

extension AppDelegate: AppsFlyerLibDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        print("✅ AppsFlyer conversion data: \(conversionInfo)")
    }
    func onConversionDataFail(_ error: Error) {
        print("❌ AppsFlyer conversion error: \(error.localizedDescription)")
    }
}
