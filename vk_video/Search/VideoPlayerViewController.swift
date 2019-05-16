//
//  VideoPlayerViewController.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 16/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import UIKit
import BMPlayer

class VideoPlayerViewController: UIViewController {

    @IBOutlet weak var player: BMPlayer!
    
    lazy var video = Video()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let u = URL(string: video.file) {
            self.player.setVideo(resource: BMPlayerResource(url: u, name: video.title, cover: nil, subtitle: nil))
        } else {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.player.play()
    }
}
