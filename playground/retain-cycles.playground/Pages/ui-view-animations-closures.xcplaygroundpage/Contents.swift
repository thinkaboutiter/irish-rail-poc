import UIKit
import PlaygroundSupport

var canvas = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 512, height: 512)))
canvas.backgroundColor = .gray

class Animator {
    
    // MARK: - Initialization
    deinit {
        debugPrint("☠️ \(#file) » \(#function) » \(#line)", separator: "\n")
    }
    
    // MARK: - Animations
    func animateBgColor(to color: UIColor,
                        on view: UIView,
                        for delay: TimeInterval,
                        completion: ((Bool) -> Void)? = nil) {
        UIView
            .animate(
                withDuration: delay,
                animations: {
                    view.backgroundColor = color
                },
                completion: { succes in
                    if succes {
                        /// capturing `self`
                        self.onBgColorAnimationSuccess?(color, view, delay)
                    }
                    else {
                        /// capturing `self`
                        self.onBgColorAnimationFailure?(color, view, delay)
                    }
                    completion?(succes)
                })
    }
    
    // MARK: - Utils
    private var onBgColorAnimationSuccess: ((UIColor, UIView, TimeInterval) -> Void)? = {
        color, view, delay in
        print("""
            animation success
            color: \(color)
            view: \(view)
            delay: \(delay)
            """)
    }
    private var onBgColorAnimationFailure: ((UIColor, UIView, TimeInterval) -> Void)? = {
        color, view, delay in
        print("""
            animation failure
            color: \(color)
            view: \(view)
            delay: \(delay)
            """)
    }
    
}
let containerSide: CGFloat = 64
var view = UIView(
    frame: CGRect(
        origin: CGPoint(
            x: canvas.bounds.midX - containerSide * 0.5,
            y: canvas.bounds.midY - containerSide * 0.5
        ),
        size: CGSize(
            width: containerSide,
            height: containerSide
        )
    )
)
view.backgroundColor = .yellow
var animator: Animator? = Animator()

canvas.addSubview(view)
animator!
    .animateBgColor(to: .red,
                    on: view,
                    for: 1.0)
    { _ in
        animator!
            .animateBgColor(to: .green,
                            on: view,
                            for: 1.0)
            { _ in
                animator!
                    .animateBgColor(to: .blue,
                                    on: view,
                                    for: 1.0)
                    { _ in
                        animator = nil
                    }
                
            }
    }


PlaygroundPage.current.liveView = canvas
