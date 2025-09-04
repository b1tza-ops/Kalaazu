package net.bigpoint.darkorbit.menu
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.greensock.TweenLite;
   import com.greensock.easing.Elastic;
   import com.greensock.easing.Expo;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.ButtonSlot;
   import net.bigpoint.darkorbit.gui.CPUItem;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.resolution.ResolutionPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class QuickMenu extends Sprite
   {
      
      public static var predefinedActions:Array;
      
      public static const logger:ILogger = Log.getLogger("QuickMenu");
      
      public static const HORIZONTAL_ORDER:int = 0;
      
      public static const HORIZONTAL_COMPACT_ORDER:int = 1;
      
      public static const VERTICAL_ORDER:int = 2;
      
      public static const VERTICAL_COMPACT_ORDER:int = 3;
      
      public static var slotOrder:int = HORIZONTAL_ORDER;
      
      private var menuManager:MenuManager;
      
      private var actionSlotCount:int;
      
      private var dragger:MovieClip;
      
      private var rotator:MovieClip;
      
      private var quickstartSlots:Array = [];
      
      private var slotWidth:int;
      
      private var slotHeight:int;
      
      private var gap:int;
      
      private var lastPosition:Point = new Point();
      
      public var predefinedActionsSet:Boolean;
      
      private var compactHorizontalPositions:Array = [];
      
      private var compactVerticalPositions:Array = [];
      
      public function QuickMenu(param1:MenuManager)
      {
         super();
         this.menuManager = param1;
         this.compactHorizontalPositions[0] = new Point(0,0);
         this.compactHorizontalPositions[1] = new Point(17,-29);
         this.compactHorizontalPositions[2] = new Point(17,29);
         this.compactHorizontalPositions[3] = new Point(34,0);
         this.compactHorizontalPositions[4] = new Point(51,-29);
         this.compactHorizontalPositions[5] = new Point(51,29);
         this.compactHorizontalPositions[6] = new Point(68,0);
         this.compactHorizontalPositions[7] = new Point(85,-29);
         this.compactHorizontalPositions[8] = new Point(85,29);
         this.compactHorizontalPositions[9] = new Point(102,0);
         this.compactVerticalPositions[0] = new Point(0,0);
         this.compactVerticalPositions[1] = new Point(-17,29);
         this.compactVerticalPositions[2] = new Point(17,29);
         this.compactVerticalPositions[3] = new Point(0,58);
         this.compactVerticalPositions[4] = new Point(-17,87);
         this.compactVerticalPositions[5] = new Point(17,87);
         this.compactVerticalPositions[6] = new Point(0,116);
         this.compactVerticalPositions[7] = new Point(-17,145);
         this.compactVerticalPositions[8] = new Point(17,145);
         this.compactVerticalPositions[9] = new Point(0,174);
      }
      
      public function onMouseUp() : void
      {
         var _loc1_:ConnectionManager = null;
         if(this.lastPosition.x != this.x || this.lastPosition.y != this.y)
         {
            if(this.checkPosition())
            {
               _loc1_ = this.menuManager.getGuiManager().getMain().getConnectionManager();
               _loc1_.sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.SET_SLOTMENU_POSITION + ServerCommands.SETTING_KEY_SEPERATOR + Settings.resolutionID,this.x + ServerCommands.SETTING_PROPERTY_SEPERATOR + this.y]);
               this.lastPosition.x = this.x;
               this.lastPosition.y = this.y;
            }
         }
      }
      
      public function checkPosition() : Boolean
      {
         var _loc1_:int = this.menuManager.getSlotWidth();
         if(this.x < 0 || this.x + _loc1_ > ScreenManager.getScreenWidth() || this.y < 0 || this.y + 20 > ScreenManager.getScreenHeight() - 0)
         {
            TweenLite.to(this,0.5,{
               "ease":Elastic.easeOut,
               "x":this.lastPosition.x,
               "y":this.lastPosition.y
            });
            return false;
         }
         return true;
      }
      
      public function init() : void
      {
         var _loc4_:Point = null;
         var _loc6_:ButtonSlot = null;
         this.actionSlotCount = Main.gameXML.menu.@actionSlots;
         this.gap = Main.gameXML.menu.@gap;
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         var _loc2_:Bitmap = _loc1_.getEmbededBitmap("slot");
         this.slotWidth = _loc2_.width;
         this.slotHeight = _loc2_.height;
         this.dragger = _loc1_.getEmbededMovieClip("dragger");
         this.dragger.x = -7;
         this.dragger.y = -14;
         this.dragger.buttonMode = true;
         this.dragger.gotoAndStop(1);
         this.dragger.addEventListener(MouseEvent.MOUSE_DOWN,this.onQuickMenuDragger);
         this.dragger.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverDragger);
         this.dragger.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutDragger);
         this.addChild(this.dragger);
         this.dragger.visible = false;
         this.rotator = _loc1_.getEmbededMovieClip("rotator");
         this.rotator.x = -7;
         this.rotator.y = 32;
         this.rotator.buttonMode = true;
         this.rotator.gotoAndStop(1);
         this.rotator.addEventListener(MouseEvent.MOUSE_DOWN,this.onQuickMenuRotator);
         this.rotator.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOverRotator);
         this.rotator.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOutRotator);
         this.addChild(this.rotator);
         this.rotator.visible = false;
         var _loc3_:ResolutionPattern = PatternManager.resolutionPatterns[Settings.resolutionID];
         _loc4_ = _loc3_.getSlotMenuPosition();
         if(_loc4_ != null)
         {
            this.x = _loc4_.x;
            this.y = _loc4_.y;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.actionSlotCount)
         {
            _loc6_ = new ButtonSlot("slot",this.menuManager.getGuiManager(),_loc5_ + 1);
            this.addChild(_loc6_.getMC());
            this.quickstartSlots.push(_loc6_);
            _loc5_++;
         }
         this.sortSlots(slotOrder);
      }
      
      public function sortSlots(param1:int, param2:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ButtonSlot = null;
         var _loc6_:Point = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:Number = 0;
         switch(param1)
         {
            case HORIZONTAL_ORDER:
               TweenLite.to(this.rotator,0.2,{
                  "ease":Expo.easeOut,
                  "x":-7,
                  "y":29
               });
               _loc4_ = 0;
               while(_loc4_ < this.actionSlotCount)
               {
                  _loc5_ = this.quickstartSlots[_loc4_];
                  _loc7_ = _loc4_ * this.slotWidth + _loc4_ * this.gap;
                  if(param2)
                  {
                     TweenLite.to(_loc5_.getMC(),0.3,{
                        "ease":Expo.easeOut,
                        "x":_loc7_,
                        "y":0,
                        "delay":_loc3_,
                        "onStart":this.onSlotMove
                     });
                     _loc3_ += 0.05;
                  }
                  else
                  {
                     _loc5_.getMC().x = _loc7_;
                     _loc5_.getMC().y = 0;
                  }
                  _loc4_++;
               }
               slotOrder = HORIZONTAL_ORDER;
               break;
            case HORIZONTAL_COMPACT_ORDER:
               TweenLite.to(this.rotator,0.2,{
                  "ease":Expo.easeOut,
                  "x":-7,
                  "y":29
               });
               _loc4_ = 0;
               while(_loc4_ < this.actionSlotCount)
               {
                  _loc5_ = this.quickstartSlots[_loc4_];
                  _loc6_ = this.compactHorizontalPositions[_loc4_];
                  if(param2)
                  {
                     TweenLite.to(_loc5_.getMC(),0.3,{
                        "ease":Expo.easeOut,
                        "x":_loc6_.x,
                        "y":_loc6_.y,
                        "delay":_loc3_,
                        "onStart":this.onSlotMove
                     });
                     _loc3_ += 0.05;
                  }
                  else
                  {
                     _loc5_.getMC().x = _loc6_.x;
                     _loc5_.getMC().y = _loc6_.y;
                  }
                  _loc4_++;
               }
               slotOrder = HORIZONTAL_COMPACT_ORDER;
               break;
            case VERTICAL_ORDER:
               TweenLite.to(this.rotator,0.2,{
                  "ease":Expo.easeOut,
                  "x":21,
                  "y":-14
               });
               _loc4_ = 0;
               while(_loc4_ < this.actionSlotCount)
               {
                  _loc5_ = this.quickstartSlots[_loc4_];
                  _loc8_ = _loc4_ * this.slotWidth + _loc4_ * this.gap;
                  if(param2)
                  {
                     TweenLite.to(_loc5_.getMC(),0.3,{
                        "ease":Expo.easeOut,
                        "x":0,
                        "y":_loc8_,
                        "delay":_loc3_,
                        "onStart":this.onSlotMove
                     });
                     _loc3_ += 0.05;
                  }
                  else
                  {
                     _loc5_.getMC().x = 0;
                     _loc5_.getMC().y = _loc8_;
                  }
                  _loc4_++;
               }
               slotOrder = VERTICAL_ORDER;
               break;
            case VERTICAL_COMPACT_ORDER:
               TweenLite.to(this.rotator,0.2,{
                  "ease":Expo.easeOut,
                  "x":21,
                  "y":-14
               });
               _loc4_ = 0;
               while(_loc4_ < this.actionSlotCount)
               {
                  _loc5_ = this.quickstartSlots[_loc4_];
                  _loc6_ = this.compactVerticalPositions[_loc4_];
                  if(param2)
                  {
                     TweenLite.to(_loc5_.getMC(),0.3,{
                        "ease":Expo.easeOut,
                        "x":_loc6_.x,
                        "y":_loc6_.y,
                        "delay":_loc3_,
                        "onStart":this.onSlotMove
                     });
                     _loc3_ += 0.05;
                  }
                  else
                  {
                     _loc5_.getMC().x = _loc6_.x;
                     _loc5_.getMC().y = _loc6_.y;
                  }
                  _loc4_++;
               }
               slotOrder = VERTICAL_COMPACT_ORDER;
         }
      }
      
      private function onSlotMove() : void
      {
         AudioManager.playSoundEffect(33);
      }
      
      private function onMouseOverDragger(param1:MouseEvent) : void
      {
         this.dragger.gotoAndStop(2);
      }
      
      private function onMouseOutDragger(param1:MouseEvent) : void
      {
         this.dragger.gotoAndStop(1);
      }
      
      private function onMouseOverRotator(param1:MouseEvent) : void
      {
         this.rotator.gotoAndStop(2);
      }
      
      private function onMouseOutRotator(param1:MouseEvent) : void
      {
         this.rotator.gotoAndStop(1);
      }
      
      public function updateCPUButtonsInSlotMenu() : void
      {
         var _loc1_:ButtonSlot = null;
         var _loc2_:ActionButton = null;
         var _loc3_:CPUItem = null;
         for each(_loc1_ in this.quickstartSlots)
         {
            _loc2_ = _loc1_.getActionButton();
            if(_loc2_ == null)
            {
               continue;
            }
            switch(_loc2_.getActionID())
            {
               case SuperActionButton.ACTIVATION_CPU_JUMP:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_JUMP];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.SELECT_CPU_JUMP_TARGET:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_ADVANCED_JUMP];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_AIM:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_AIM];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_AROL:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_AROL];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_RLLB:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_RLLB];
                  _loc2_.updateTooltip();
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_CLOAK:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_CLOAK];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_ROBOT:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_ROBOT];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                     _loc2_.updateTooltip();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_HM7:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_HM7];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_DRONE_REPAIR];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_AMMOBUY:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_AMMOBUY];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_ROCKETBUY:
                  _loc3_ = Hero.cpuItems[CPUItem.TYPE_ROCKETBUY];
                  if(_loc3_ == null)
                  {
                     _loc2_.lockButton();
                  }
                  else
                  {
                     _loc2_.unlockButton();
                  }
                  break;
            }
         }
      }
      
      private function onQuickMenuDragger(param1:MouseEvent) : void
      {
         this.startDrag();
      }
      
      private function onQuickMenuRotator(param1:MouseEvent) : void
      {
         if(slotOrder == HORIZONTAL_ORDER)
         {
            this.sortSlots(HORIZONTAL_COMPACT_ORDER,true);
         }
         else if(slotOrder == HORIZONTAL_COMPACT_ORDER)
         {
            this.sortSlots(VERTICAL_ORDER,true);
         }
         else if(slotOrder == VERTICAL_ORDER)
         {
            this.sortSlots(VERTICAL_COMPACT_ORDER,true);
         }
         else if(slotOrder == VERTICAL_COMPACT_ORDER)
         {
            this.sortSlots(HORIZONTAL_ORDER,true);
         }
         var _loc2_:ConnectionManager = this.menuManager.getGuiManager().getMain().getConnectionManager();
         _loc2_.sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.SET_SLOTMENU_ORDER + ServerCommands.SETTING_KEY_SEPERATOR + Settings.resolutionID,slotOrder.toString()]);
      }
      
      public function hideMenuDragger() : void
      {
         this.dragger.visible = false;
         this.rotator.visible = false;
      }
      
      public function showMenuDragger() : void
      {
         this.dragger.visible = true;
         this.rotator.visible = true;
      }
      
      public function showSlots() : void
      {
         var _loc1_:ButtonSlot = null;
         for each(_loc1_ in this.quickstartSlots)
         {
            if(!_loc1_.getMC().visible)
            {
               _loc1_.getMC().visible = true;
            }
         }
      }
      
      public function hideSlots() : void
      {
         var _loc1_:ButtonSlot = null;
         for each(_loc1_ in this.quickstartSlots)
         {
            if(!_loc1_.isAllocated())
            {
               _loc1_.getMC().visible = false;
            }
         }
      }
      
      public function refreshQuickmenu() : void
      {
         var _loc1_:ButtonSlot = null;
         var _loc2_:ActionButton = null;
         for each(_loc1_ in this.quickstartSlots)
         {
            _loc2_ = _loc1_.getActionButton();
            if(_loc2_ != null)
            {
               if(this.menuManager.isButtonBlacklisted(_loc2_.getActionID()))
               {
                  _loc1_.setVisibility(false);
               }
               else
               {
                  _loc1_.setVisibility(true);
               }
            }
         }
      }
      
      public function updateCooldownButtonsArray() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this.quickstartSlots.length)
         {
            if(this.quickstartSlots[_loc1_].getActionButton() != null)
            {
               if(Boolean(this.quickstartSlots[_loc1_].getActionButton().isTechButton) || this.quickstartSlots[_loc1_].getActionButton().cooldownButtonType == ActionButton.COOLDOWN_TYPE_SKILL)
               {
                  this.menuManager.actionButtonsWithCooldowns.push(this.quickstartSlots[_loc1_].getActionButton());
               }
            }
            _loc1_++;
         }
      }
      
      public function updateQuickmenu() : void
      {
         var _loc1_:ActionButton = null;
         var _loc2_:ButtonSlot = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.predefinedActionsSet)
         {
            return;
         }
         this.predefinedActionsSet = true;
         var _loc3_:int = int(this.menuManager.rocketIDToButtonID[Settings.selectedRocket]);
         if(predefinedActions != null)
         {
            _loc4_ = 0;
            while(_loc4_ < predefinedActions.length)
            {
               _loc5_ = int(predefinedActions[_loc4_]);
               if(_loc5_ != -1)
               {
                  if(!this.menuManager.isButtonBlacklisted(_loc5_))
                  {
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_JUMP)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_JUMP] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_JUMP,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.SELECT_CPU_JUMP_TARGET)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_ADVANCED_JUMP] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.SELECT_CPU_JUMP_TARGET,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_AIM)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_AIM] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_AIM,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_AROL)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_AROL] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_AROL,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_RLLB)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_RLLB] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_RLLB,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_CLOAK)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_CLOAK] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_CLOAK,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_ROBOT)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_ROBOT] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_ROBOT,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_HM7)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_HM7] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_HM7,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_DRONE_REPAIR] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_AMMOBUY)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_AMMOBUY] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_AMMOBUY,false);
                        }
                     }
                     if(_loc5_ == SuperActionButton.ACTIVATION_CPU_ROCKETBUY)
                     {
                        if(Hero.cpuItems[CPUItem.TYPE_ROCKETBUY] == null)
                        {
                           this.menuManager.setButtonAccess(SuperActionButton.ACTIVATION_CPU_ROCKETBUY,false);
                        }
                     }
                     _loc1_ = this.menuManager.createActionButton(_loc5_);
                     if(_loc1_ != null)
                     {
                        _loc2_ = this.quickstartSlots[_loc4_];
                        _loc2_.addActionButton(_loc1_);
                        if(_loc1_.actionID == _loc3_)
                        {
                           _loc1_.setSelected();
                        }
                     }
                  }
               }
               _loc4_++;
            }
         }
         this.updateCooldownButtonsArray();
         this.menuManager.updateTechs();
      }
      
      public function activateSlot(param1:int) : void
      {
         var _loc3_:ActionButton = null;
         var _loc2_:ButtonSlot = this.quickstartSlots[param1];
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getActionButton();
            if(_loc3_ != null && !(_loc3_.isCooldownActive() || _loc3_.isLocked()))
            {
               this.menuManager.proccessAction(_loc3_.getActionID(),_loc3_.getEnvironment());
            }
         }
      }
      
      public function getQuickstartSlots() : Array
      {
         return this.quickstartSlots;
      }
   }
}

