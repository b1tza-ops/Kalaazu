package net.bigpoint.darkorbit.ctb
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.CTBScoreElement;
   import net.bigpoint.darkorbit.gui.elements.CTBScoreGridElement;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.ShipManager;
   
   public class CTBManager
   {
      
      private var homezones:Array = [];
      
      private var guiManager:GuiManager;
      
      private var shipManager:ShipManager;
      
      private var portalLayer:Sprite;
      
      public function CTBManager(param1:GuiManager, param2:ShipManager, param3:Sprite)
      {
         super();
         this.guiManager = param1;
         this.shipManager = param2;
         this.portalLayer = param3;
      }
      
      public function parseCommands(param1:Array) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         switch(param1[3])
         {
            case ServerCommands.CTB_INIT_SCOREBOARD:
               _loc2_ = Main.parseBooleanFromInt(param1[4]);
               if(_loc2_)
               {
                  this.createCTBScoreboard();
               }
               else
               {
                  this.destroyCTBScoreboard();
                  this.cleanup();
               }
               break;
            case ServerCommands.CTB_UPDATE_BEACON_POSITION:
               _loc3_ = int(param1[4]);
               _loc4_ = int(param1[5]);
               this.updateBeaconPosition(_loc3_,_loc4_);
               break;
            case ServerCommands.CTB_UPDATE_SCOREBOARD:
               _loc5_ = Number(param1[4]);
               _loc6_ = Number(param1[5]);
               _loc7_ = Number(param1[6]);
               _loc8_ = [];
               _loc8_.push(_loc5_);
               _loc8_.push(_loc6_);
               _loc8_.push(_loc7_);
               this.updateCTBScoreboard(_loc8_);
               break;
            case ServerCommands.CTB_SET_HOMEZONES:
               _loc3_ = int(param1[4]);
               _loc9_ = int(param1[5]);
               _loc10_ = int(param1[6]);
               this.addHomezone(_loc3_,_loc9_,_loc10_);
               break;
            case ServerCommands.CTB_ATTACH_BEACON_TO_USER:
               _loc11_ = parseInt(param1[4]);
               _loc3_ = int(param1[5]);
               this.shipManager.attachBeaconToShip(_loc11_,_loc3_);
               break;
            case ServerCommands.CTB_REMOVE_BEACON_FROM_USER:
               _loc11_ = int(param1[4]);
               this.shipManager.removeBeaconFromShip(_loc11_);
         }
      }
      
      public function cleanup() : void
      {
         var _loc3_:MapObject = null;
         var _loc4_:HomeZone = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.homezones.length)
         {
            _loc4_ = this.homezones[_loc1_];
            _loc4_.cleanup();
            this.portalLayer.removeChild(_loc4_);
            _loc1_++;
         }
         var _loc2_:Array = this.shipManager.getShips();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.getBeacon() != null)
            {
               _loc3_.removeBeaconClip();
            }
         }
      }
      
      public function addHomezone(param1:int, param2:int, param3:int) : void
      {
         var _loc5_:HomeZone = null;
         var _loc6_:HomeZone = null;
         var _loc4_:HomeZone = new HomeZone(this,param1,param2,param3);
         this.homezones.push(_loc4_);
         this.portalLayer.addChild(_loc4_);
         if(this.homezones.length == 2)
         {
            _loc5_ = this.homezones[0];
            _loc6_ = this.homezones[1];
            if(_loc5_.x < _loc6_.x)
            {
               _loc5_.setDirection(-1);
               _loc6_.setDirection(1);
            }
            else
            {
               _loc5_.setDirection(1);
               _loc6_.setDirection(-1);
            }
            _loc5_.startRotateTimer();
            _loc6_.startRotateTimer();
         }
      }
      
      public function getHomezones() : Array
      {
         return this.homezones;
      }
      
      public function createCTBScoreboard() : void
      {
         var _loc1_:SimpleWindow = null;
         var _loc2_:SimpleContainer = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:CTBScoreElement = null;
         var _loc7_:Array = null;
         var _loc8_:CTBScoreGridElement = null;
         if(this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_CTB) == null)
         {
            _loc1_ = this.guiManager.createWindow(SimpleWindow.WINDOW_CLASS_CTB);
            _loc2_ = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_CTB);
            _loc3_ = 0;
            _loc4_ = 1;
            _loc2_.x = 12;
            _loc2_.y = 35;
            _loc5_ = 1;
            while(_loc5_ < 4)
            {
               _loc6_ = new CTBScoreElement(this.guiManager,_loc5_);
               _loc6_.setTitleYPosition(-4);
               _loc6_.setScoreYPosition(32);
               _loc6_.updateScore(0);
               if(_loc5_ == Hero.factionID)
               {
                  _loc6_.order = 0;
               }
               else
               {
                  _loc6_.order = _loc4_++;
               }
               _loc2_.addElement(_loc6_,SimpleContainer.NO_ALIGN);
               _loc5_++;
            }
            _loc7_ = _loc2_.getAllElements();
            _loc7_.sortOn("order",Array.NUMERIC);
            _loc5_ = 0;
            while(_loc5_ < _loc7_.length)
            {
               _loc6_ = _loc7_[_loc5_];
               _loc6_.x = _loc3_;
               _loc3_ += _loc6_.getBackground().width;
               _loc5_++;
            }
            _loc8_ = new CTBScoreGridElement();
            _loc8_.x = -2;
            _loc8_.y = -3;
            _loc2_.addElement(_loc8_,SimpleContainer.NO_ALIGN);
            _loc1_.addContainer(_loc2_);
         }
      }
      
      public function destroyCTBScoreboard() : void
      {
         var _loc1_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_CTB);
         if(_loc1_ != null)
         {
            this.guiManager.closeWindow(_loc1_);
         }
      }
      
      public function updateBeaconPosition(param1:int, param2:int) : void
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CTBScoreElement = null;
         var _loc3_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_CTB);
         if(_loc3_ != null)
         {
            _loc4_ = param1.toString().split("");
            _loc5_ = int(_loc4_[1]);
            _loc6_ = int(_loc4_[2]);
            _loc7_ = CTBScoreElement(this.guiManager.getScoreElement(SimpleWindow.WINDOW_CLASS_CTB,SimpleContainer.CLASS_CTB,_loc5_));
            if(_loc7_ != null)
            {
               _loc7_.updateBeacon(param1,_loc6_,param2);
            }
         }
      }
      
      public function updateCTBScoreboard(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:CTBScoreElement = null;
         var _loc2_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_CTB);
         if(_loc2_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = CTBScoreElement(this.guiManager.getScoreElement(SimpleWindow.WINDOW_CLASS_CTB,SimpleContainer.CLASS_CTB,_loc3_ + 1));
               if(_loc4_ != null)
               {
                  _loc4_.updateScore(param1[_loc3_]);
               }
               _loc3_++;
            }
         }
      }
   }
}

