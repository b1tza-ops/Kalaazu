package net.bigpoint.darkorbit.drone
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quart;
   import flash.display.MovieClip;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   
   public class DroneManager
   {
      
      public static const logger:ILogger = Log.getLogger("DroneManager");
      
      private var timer:Timer;
      
      private var droneGroupRadius:int;
      
      private var map:Map;
      
      public function DroneManager(param1:Map)
      {
         super();
         this.map = param1;
         this.droneGroupRadius = Main.gameXML.patterns.drones.attribute("groupRadius");
         this.timer = new Timer(25,0);
         this.timer.addEventListener(TimerEvent.TIMER,this.onDroneRotate);
         this.timer.start();
      }
      
      public function cleanup() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onDroneRotate);
         this.map = null;
      }
      
      public function addDrone(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc8_:MovieClip = null;
         var _loc10_:DronePattern = null;
         var _loc11_:BitmapClip = null;
         var _loc6_:MapObject = this.map.getShipManager().getShip(param1);
         if(_loc6_.droneConnector == null)
         {
            _loc6_.initDroneConnector();
         }
         var _loc7_:DroneGroup = _loc6_.droneConnector.getDroneGroup(param2);
         if(_loc7_ == null)
         {
            _loc8_ = new MovieClip();
            _loc8_.mouseEnabled = Main.mouseEventsEnabled;
            _loc8_.mouseChildren = Main.mouseEventsEnabled;
            _loc7_ = new DroneGroup(param2,_loc8_,this.getDroneGroupRadius() * 2);
            _loc6_.droneConnector.addDroneGroup(_loc7_);
            _loc6_.getDroneDisplayClipContainer().addChild(_loc8_);
         }
         var _loc9_:Drone = _loc7_.getDrone(param3);
         if(_loc9_ == null)
         {
            _loc10_ = PatternManager.getDronePattern(param4,param5);
            _loc11_ = new BitmapClip(ResourceManager.getMovieClip("drones",_loc10_.getResKey()),_loc10_.getResKey());
            _loc11_.gotoAndStop(1);
            if(!Settings.displayDrones)
            {
               _loc11_.visible = false;
            }
            _loc9_ = new Drone(param3,_loc10_.getDroneRadius(),_loc11_);
            _loc7_.addDrone(_loc9_);
            _loc7_.getClip().addChild(_loc11_);
         }
      }
      
      public function removeAllDrones() : void
      {
         var _loc2_:MapObject = null;
         var _loc1_:Array = this.map.getShipManager().getShips();
         for each(_loc2_ in _loc1_)
         {
            _loc2_.removeDrones();
         }
      }
      
      private function onDroneRotate(param1:TimerEvent) : void
      {
         var _loc3_:MapObject = null;
         var _loc2_:Array = this.map.getShipManager().getShips();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.droneConnector != null)
            {
               this.updateDronesPosition(_loc3_);
            }
         }
      }
      
      public function updateDronesPosition(param1:MapObject) : void
      {
         var _loc4_:DroneGroup = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Drone = null;
         var _loc9_:BitmapClip = null;
         var _loc10_:int = 0;
         var _loc2_:Array = param1.droneConnector.droneGroups;
         var _loc3_:int = int(_loc2_.length);
         while(--_loc3_ > -1)
         {
            _loc4_ = _loc2_[_loc3_];
            _loc5_ = param1.shipRotation - 180;
            if(_loc4_.lastDroneGroupRotation != _loc5_)
            {
               _loc4_.lastDroneGroupRotation = _loc5_;
               if(_loc4_.position == 0)
               {
                  TweenLite.to(_loc4_,1,{"shortRotation":{"droneGroupRotation":_loc5_}});
               }
               else if(_loc4_.position == 1)
               {
                  TweenLite.to(_loc4_,1,{"shortRotation":{"droneGroupRotation":_loc5_ + 90}});
               }
               else if(_loc4_.position == 2)
               {
                  TweenLite.to(_loc4_,1,{"shortRotation":{"droneGroupRotation":_loc5_ + 180}});
               }
               else if(_loc4_.position == 3)
               {
                  TweenLite.to(_loc4_,1,{"shortRotation":{"droneGroupRotation":_loc5_ + 270}});
               }
               _loc6_ = _loc4_.drones;
               _loc7_ = int(_loc6_.length);
               while(--_loc7_ > -1)
               {
                  _loc8_ = _loc6_[_loc7_];
                  _loc9_ = _loc8_.clip;
                  _loc10_ = param1.shipRotation - 180;
                  if(_loc8_.lastDroneRotation != _loc10_)
                  {
                     _loc8_.lastDroneRotation = _loc10_;
                     if(_loc8_.position == 1)
                     {
                        _loc10_ += 90;
                     }
                     else if(_loc8_.position == 2)
                     {
                        _loc10_ += 180;
                     }
                     else if(_loc8_.position == 3)
                     {
                        _loc10_ += 270;
                     }
                     if(_loc8_.position == 4)
                     {
                        _loc9_.x = int(Math.cos(_loc10_ * Math.PI / 180));
                        _loc9_.y = int(Math.sin(_loc10_ * Math.PI / 180));
                     }
                     else
                     {
                        _loc9_.x = int(_loc8_.droneDimension * Math.cos(_loc10_ * Math.PI / 180));
                        _loc9_.y = int(_loc8_.droneDimension * Math.sin(_loc10_ * Math.PI / 180));
                     }
                     if(!param1.shipPattern.playLoop)
                     {
                        _loc9_.gotoAndStop(param1.lastShipFrame);
                     }
                  }
               }
            }
         }
      }
      
      public function getDroneGroupRadius() : int
      {
         return this.droneGroupRadius;
      }
      
      public function parseDroneString(param1:int, param2:String) : void
      {
         var _loc5_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc3_:Array = param2.split("/");
         var _loc4_:int = int(_loc3_.shift());
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            if(_loc4_ == 1)
            {
               _loc5_ = DroneConnector.POSITION_DOWN;
            }
            else if(_loc4_ == 2)
            {
               if(_loc6_ == 0)
               {
                  _loc5_ = DroneConnector.POSITION_LEFT;
               }
               else if(_loc6_ == 1)
               {
                  _loc5_ = DroneConnector.POSITION_RIGHT;
               }
            }
            else if(_loc4_ == 3)
            {
               if(_loc6_ == 0)
               {
                  _loc5_ = DroneConnector.POSITION_RIGHT;
               }
               else if(_loc6_ == 1)
               {
                  _loc5_ = DroneConnector.POSITION_DOWN;
               }
               else if(_loc6_ == 2)
               {
                  _loc5_ = DroneConnector.POSITION_LEFT;
               }
            }
            else if(_loc4_ == 4)
            {
               if(_loc6_ == 0)
               {
                  _loc5_ = DroneConnector.POSITION_RIGHT;
               }
               else if(_loc6_ == 1)
               {
                  _loc5_ = DroneConnector.POSITION_DOWN;
               }
               else if(_loc6_ == 2)
               {
                  _loc5_ = DroneConnector.POSITION_LEFT;
               }
               else if(_loc6_ == 3)
               {
                  _loc5_ = DroneConnector.POSITION_TOP;
               }
            }
            _loc7_ = _loc3_[_loc6_];
            _loc8_ = _loc7_.split("-");
            _loc9_ = int(_loc8_.shift());
            _loc10_ = 0;
            while(_loc10_ < _loc8_.length)
            {
               _loc11_ = _loc8_[_loc10_];
               _loc12_ = _loc11_.split(",");
               _loc13_ = String(_loc12_[0]).split("");
               _loc14_ = int(_loc13_[0]);
               _loc15_ = int(_loc13_[1]);
               if(_loc9_ == 1)
               {
                  this.addDrone(param1,_loc5_,DroneConnector.POSITION_CENTER,_loc14_,_loc15_);
               }
               if(_loc9_ == 2)
               {
                  if(_loc10_ == 0)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_LEFT,_loc14_,_loc15_);
                  }
                  else if(_loc10_ == 1)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_RIGHT,_loc14_,_loc15_);
                  }
               }
               if(_loc9_ == 3)
               {
                  if(_loc10_ == 0)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_TOP,_loc14_,_loc15_);
                  }
                  else if(_loc10_ == 1)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_RIGHT,_loc14_,_loc15_);
                  }
                  else if(_loc10_ == 2)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_LEFT,_loc14_,_loc15_);
                  }
               }
               if(_loc9_ == 4)
               {
                  if(_loc10_ == 0)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_TOP,_loc14_,_loc15_);
                  }
                  else if(_loc10_ == 1)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_RIGHT,_loc14_,_loc15_);
                  }
                  else if(_loc10_ == 2)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_LEFT,_loc14_,_loc15_);
                  }
                  else if(_loc10_ == 3)
                  {
                     this.addDrone(param1,_loc5_,DroneConnector.POSITION_DOWN,_loc14_,_loc15_);
                  }
               }
               _loc10_++;
            }
            _loc6_++;
         }
      }
      
      public function deployDrones(param1:int) : void
      {
         var _loc5_:DroneGroup = null;
         var _loc6_:int = 0;
         var _loc2_:Ship = this.map.getShipManager().getShip(param1) as Ship;
         var _loc3_:Array = _loc2_.droneConnector.droneGroups;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = _loc5_.droneGroupDimension;
            _loc5_.droneGroupDimension = 0;
            TweenLite.to(_loc5_,1,{
               "delay":1,
               "ease":Quart.easeOut,
               "droneGroupDimension":_loc6_
            });
            _loc4_++;
         }
      }
      
      public function setDroneRadius(param1:int) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:DroneGroup = null;
         var _loc7_:int = 0;
         var _loc2_:Ship = this.map.getShipManager().getHero();
         var _loc3_:DroneConnector = _loc2_.droneConnector;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.droneGroups;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = _loc6_.droneGroupDimension + param1;
               if(_loc7_ > 0 && _loc7_ < 300)
               {
                  TweenLite.to(_loc6_,0.5,{"droneGroupDimension":_loc7_});
               }
               _loc5_++;
            }
         }
      }
      
      public function minimizeDrones() : void
      {
         var _loc2_:DroneConnector = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:DroneGroup = null;
         var _loc1_:Ship = this.map.getShipManager().getHero();
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.droneConnector;
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.droneGroups;
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_];
                  TweenLite.to(_loc5_,1,{
                     "delay":1,
                     "ease":Quart.easeOut,
                     "droneGroupDimension":0
                  });
                  _loc4_++;
               }
            }
         }
      }
   }
}

