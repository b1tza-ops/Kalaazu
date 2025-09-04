package net.bigpoint.darkorbit.combat
{
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.ship.MapObject;
   
   public class TractorBeamJob
   {
      
      public var combatManager:CombatManager;
      
      public var attackerID:int;
      
      public var targetID:int;
      
      public var attackerShip:MapObject;
      
      public var targetShip:MapObject;
      
      public var beam:Sprite;
      
      public var laserLayer:Sprite;
      
      public function TractorBeamJob(param1:CombatManager, param2:int, param3:int)
      {
         super();
         this.combatManager = param1;
         this.attackerID = param2;
         this.targetID = param3;
         this.laserLayer = this.combatManager.getMap().getMain().screenManager.getLaserLayer();
         this.init();
      }
      
      public function init() : void
      {
         var _loc1_:Map = this.combatManager.getMap();
         this.attackerShip = _loc1_.getShipManager().getShip(this.attackerID);
         this.targetShip = _loc1_.getShipManager().getShip(this.targetID);
         this.beam = new Sprite();
         this.beam.filters = [new BlurFilter(2,2,1),new GlowFilter(4461055,1,32,32,8,3)];
         this.laserLayer.addChild(this.beam);
         this.start();
      }
      
      public function start() : void
      {
         var _loc1_:Number = this.random(2) + 1;
         this.beam.graphics.clear();
         this.beam.graphics.moveTo(this.attackerShip.x,this.attackerShip.y);
         this.beam.graphics.lineStyle(_loc1_,16777215,1);
         this.beam.graphics.lineTo(this.attackerShip.x + 200,this.attackerShip.y);
      }
      
      public function cleanup() : void
      {
         this.combatManager.removeTractorBeam(this.attackerID,false);
      }
      
      private function random(param1:int) : int
      {
         return Math.floor(Math.random() * param1);
      }
   }
}

