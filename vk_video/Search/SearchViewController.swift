//
//  SearchViewController.swift
//  vk_video
//
//  Created by Maxim Zakopaylov on 13/05/2019.
//  Copyright © 2019 Maxim Zakopaylov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Nuke
import SVPullToRefresh

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searhBar: UISearchBar!
    @IBOutlet weak var activityLoading: UIActivityIndicatorView!
    
    let viewModel = SearchViewModel()
    
    lazy var videos = BehaviorRelay<[Video]>(value: [])
    lazy var selectedVideo = Video()
    lazy var query = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.addInfiniteScrolling { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.videos.value.count > 19 && strongSelf.videos.value.count % 20 == 0 {
                strongSelf.viewModel
                    .searchVideo(query: strongSelf.query, count: strongSelf.videos.value.count + 20)
                    .asObservable()
                    .do(onNext: { (_) in
                        strongSelf.tableView.infiniteScrollingView.stopAnimating()
                    })
                    .bind(to: strongSelf.videos)
                    .disposed(by: strongSelf.viewModel.disposeBag)
            } else {
                strongSelf.tableView.infiniteScrollingView.stopAnimating()
            }
        }
        
        self.videos
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "VideoCell", cellType: VideoCell.self)) { row, video, cell in
                if let url =  URL(string: video.preview) {
                    Nuke.loadImage(with: url, into: cell.previewImage)
                }
                cell.nameTitle.text = video.title
                cell.descriptionTitle.text = video.desc
            }.disposed(by: viewModel.disposeBag)
        
        self.tableView
            .rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let strongSelf = self else { return }
                if let urlPlayer = URL(string: strongSelf.videos.value[indexPath.row].player) {
                    UIApplication.shared.open(urlPlayer, options: [:], completionHandler: nil)
                }
            }).disposed(by: viewModel.disposeBag)
        
        searhBar
            .rx.text
            .orEmpty
            .debounce(0.2, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                guard let strongSelf = self else { return }
                strongSelf.query = query
                strongSelf.activityLoading.startAnimating()
                strongSelf.viewModel
                    .searchVideo(query: query)
                    .asObservable()
                    .do(onNext: { (_) in
                        strongSelf.activityLoading.stopAnimating()
                    })
                    .bind(to: strongSelf.videos)
                    .disposed(by: strongSelf.viewModel.disposeBag)
            })
            .disposed(by: viewModel.disposeBag)
    }

}
