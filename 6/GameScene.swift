//
//  GameScene.swift
//  6
//
//  Created by Lily Ewing on 3/6/22.
//

import SpriteKit
import GameplayKit

private let kAnimalNodeName = "movable"

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "Background")
    var selectedNode = SKSpriteNode()
    //let backgroundColor = SKColor.white
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        //1 set up background, give name for use later
        self.background.name = "background"
        self.background.anchorPoint = CGPoint.zero //set anchor point to lower L of image (0,0), by default anchor point is center of the node
        //2 adding background to node hierarchy, pos defaults to (0,0) @ lower L corner
        self.addChild(background)
        
        let cat = SKSpriteNode(imageNamed: "Cat")
        cat.name = kAnimalNodeName
        cat.position = CGPoint(x: 100, y: size.height/2)
        background.addChild(cat)
        
        
        let dog = SKSpriteNode(imageNamed: "Dog")
        dog.name = kAnimalNodeName
        dog.position = CGPoint(x: 300, y: size.height/2) //so confused, not always show up on screen??
        background.addChild(dog)
        
        let squirrel = SKSpriteNode(imageNamed: "Squirrel")
        squirrel.name = kAnimalNodeName
        squirrel.position = CGPoint(x: 500, y: size.height/2)
        background.addChild(squirrel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>,  with event: UIEvent?) {
        let touch = touches.first!
        let positionInScene = touch.location(in:self)

        selectNodeForTouch(touchLocation:positionInScene)

    }
    
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * .pi)
    }

    func selectNodeForTouch(touchLocation: CGPoint) {
      // 1 finds the node @ touchLocation
      let touchedNode = atPoint(touchLocation)

      if touchedNode is SKSpriteNode {
        // 2 If the node found is a SKSpriteNode instance, check if same as prev selected (if yes, return & do nothing) If no:
        if !selectedNode.isEqual(touchedNode) {
          selectedNode.removeAllActions() //remove all actions
            selectedNode.run(SKAction.rotate(toAngle:0.0,duration: 0.1)) //set it to unrotated state

          selectedNode = touchedNode as! SKSpriteNode
        }
      }
    }

    //make sure don't scroll beyond bounds of background image
    func boundLayerPos(aNewPosition: CGPoint) -> CGPoint {
      let winSize = size
      var retval = aNewPosition
      retval.x = CGFloat(min(retval.x, 0))
      retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
      retval.y = position.y
      
      return retval
    }

    func panForTranslation(translation: CGPoint) {
      let position = selectedNode.position
      
      if selectedNode.name! == kAnimalNodeName {
        selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
          
      } else {
        let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
          background.position = self.boundLayerPos(aNewPosition: aNewPosition)
      }
    }
    
    //figure out how much touch has moved since last time, if animal selected, will move animal by that amount, if no will move layer so can scroll L > R
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first! //unwrapping optional type 'UITouch?' by Force-unwrap using '!' to abort execution if the optional value contains 'nil'
        let positionInScene = touch.location(in:self)
        let previousPosition = touch.previousLocation(in:self)
        let translation = CGPoint(x: positionInScene.x - previousPosition.x, y: positionInScene.y - previousPosition.y)
      
        panForTranslation(translation:translation)
    }


    
}
