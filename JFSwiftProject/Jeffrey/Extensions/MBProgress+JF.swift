//
// Created by Jeffrey on 2019-04-02.
// Copyright (c) 2019 CrfChina. All rights reserved.
//

import Foundation
import MBProgressHUD

extension MBProgressHUD {
    static func `default`(view: UIView) -> MBProgressHUD {
        let hud = MBProgressHUD(view: view)
        /**内容色，类似tintColor,会改变默认的菊花等颜色和字体颜色（但字体颜色单独设置也还是会生效）*/
        hud.contentColor = UIColor.white
        hud.bezelView.color = UIColor.black
//    hud.backgroundView.blurEffectStyle = UIBlurEffectStyleProminent;
        hud.bezelView.style = .blur;
        /**最小显示时间，默认设置为1秒*/
        hud.minShowTime = 1;
        /**动画样式，缩放*/
        hud.animationType = .zoom;
        /**标题字体，注：label显示title，detailsLabel显示描述，区别在于title无法换行*/
        hud.label.font = UIFont.systemFont(ofSize: 22)
        /**描述字体*/
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(hud)
        return hud
    }

}