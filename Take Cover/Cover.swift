//
//  Cover.swift
//  Take Cover
//
//  Created by Alexander Warren on 3/25/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit

class Cover: SKSpriteNode {

    var place: CGPoint
    var sizeNess: CGSize
    //var customTexture: SKTexture?
    
    init(place: CGPoint, sizeNess: CGSize, texture: SKTexture) {
        //let customTexture = texture
        let texture = SKTexture(imageNamed: "thingy")
        self.place = place
        self.sizeNess = sizeNess
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        //self.texture = texture
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
