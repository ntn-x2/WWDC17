//
//  LiveView.swift
//
//  Created by Antonio Antonino on 28/03/2017.
//  Copyright © 2017 diiaablo. All rights reserved.
//

import PlaygroundSupport

PlaygroundPage.current.liveView = PhotosCollectionViewController(photos: PhotoLoader.photosResources, updateInterval: 2, options: .transitionCrossDissolve)
