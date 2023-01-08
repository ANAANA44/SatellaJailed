import Jinx
import UIKit

struct Tweak {
    static func ctor() {
        let prefs: Preferences = .shared
        
        if #available(iOS 14, *) {
            IPC.shared.observe("AlShario") { _ in
                if prefs.isHidden {
                    return
                }
                
                let rootVC: UIViewController? = UIApplication.shared.windows
                    .filter{ $0.isKeyWindow }
                    .first?
                    .rootViewController
                
                let satellaVC: SatellaViewController = .shared
                
                rootVC?.add(satellaVC)
            }
            
            IPC.shared.post("AlShario")
            
            // UIWindow
            
            BecomeKey().hook(onlyIf: prefs.isGesture)
        }
        
        guard prefs.isEnabled else {
            return
        }
        
        // SKPaymentQueue
        
        AddTransactionObserver().hook(onlyIf: prefs.isObserver)
        CanMakePayments().hook()
        
        // SKPaymentTransaction
        
        ErrorGetter().hook()
        MatchingIdentifier().hook()
        TransactionDate().hook()
        TransactionIdentifier().hook()
        TransactionReceipt().hook(onlyIf: prefs.isReceipt)
        TransactionState().hook()
        
        // SKProductsRequest
        
        if #available(iOS 13, *) {
            SetDelegate().hook()
        } else {
            SetDelegate12().hook()
        }
        
        // URLSession
        
        DataTask().hook(onlyIf: prefs.isReceipt)
        
        // Functions
        
        DyldGetImageName().hook(onlyIf: prefs.isStealth)
        ObjcGetClass().hook(onlyIf: prefs.isStealth)
    }
}

@_cdecl("jinx_entry")
func jinx_entry() {
    Tweak.ctor()
}
