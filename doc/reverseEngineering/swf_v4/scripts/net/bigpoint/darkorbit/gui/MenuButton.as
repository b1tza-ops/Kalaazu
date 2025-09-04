package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.menu.ActionButton;
   import net.bigpoint.darkorbit.menu.ActionButtonPattern;
   import net.bigpoint.darkorbit.menu.MainMenu;
   import net.bigpoint.darkorbit.menu.SuperActionButton;
   import net.bigpoint.darkorbit.net.models.skills.SkillDesignNames;
   
   public class MenuButton
   {
      
      public static var MENUBUTTON_LASER:int = 0;
      
      public static var MENUBUTTON_ROCKET:int = 1;
      
      public static var MENUBUTTON_EXPLOSIVE:int = 2;
      
      public static var MENUBUTTON_CPU:int = 3;
      
      public static var MENUBUTTON_EXTRAS:int = 4;
      
      private var id:int;
      
      private var middleMenu:MainMenu;
      
      private var mc:MovieClip;
      
      private var actionIDs:Array;
      
      private var subAction:Boolean;
      
      private var actionNormal:Bitmap;
      
      private var actionHover:Bitmap;
      
      private var actionDisabled:Bitmap;
      
      private var actionSelected:Bitmap;
      
      private var preselected:Boolean;
      
      private var languageKey:String;
      
      public function MenuButton(param1:int, param2:String, param3:Boolean, param4:String, param5:String, param6:String, param7:MainMenu, param8:String = null)
      {
         super();
         var _loc9_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         this.id = param1;
         this.subAction = param3;
         this.middleMenu = param7;
         this.languageKey = param8;
         this.actionNormal = _loc9_.getEmbededBitmap(param4);
         this.actionHover = _loc9_.getEmbededBitmap(param5);
         this.actionSelected = _loc9_.getEmbededBitmap(param6);
         this.actionDisabled = _loc9_.getEmbededBitmap("comb00_deactivated.png");
         this.actionSelected.x = -1;
         this.actionSelected.y = -2;
         this.actionHover.alpha = 0;
         this.actionSelected.alpha = 0;
         this.mc = new MovieClip();
         this.mc.buttonMode = true;
         this.mc.addChild(this.actionNormal);
         this.mc.addChild(this.actionHover);
         this.mc.addChild(this.actionSelected);
         this.mc.addChild(_loc9_.getEmbededBitmap(param2));
         this.mc.addChild(this.actionDisabled);
         if(!param7.getMenuManager().isMenuButtonBlacklisted(param1))
         {
            this.actionDisabled.visible = false;
         }
         this.actionIDs = [];
         this.mc.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.mc.addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOver);
         this.mc.addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOut);
         if(param8 != null)
         {
            TooltipControl.getInstance().addToolTip(this.mc,BPLocale.getText(param8));
         }
      }
      
      private function handleMouseOver(param1:MouseEvent) : void
      {
         if(!this.actionDisabled.visible)
         {
            TweenLite.to(this.actionHover,0.5,{"alpha":1});
         }
      }
      
      private function handleMouseOut(param1:MouseEvent) : void
      {
         if(!this.actionDisabled.visible)
         {
            TweenLite.to(this.actionHover,0.5,{"alpha":0});
         }
      }
      
      public function updateButtonsInPool() : void
      {
         var _loc2_:int = 0;
         var _loc3_:ButtonSlot = null;
         var _loc6_:ActionButtonPattern = null;
         var _loc7_:ActionButton = null;
         var _loc8_:Boolean = false;
         var _loc9_:CPUItem = null;
         var _loc10_:CPUItem = null;
         var _loc11_:CPUItem = null;
         var _loc12_:CPUItem = null;
         var _loc13_:CPUItem = null;
         var _loc14_:CPUItem = null;
         var _loc15_:CPUItem = null;
         var _loc16_:CPUItem = null;
         var _loc17_:CPUItem = null;
         var _loc18_:CPUItem = null;
         var _loc19_:CPUItem = null;
         var _loc1_:Array = this.middleMenu.getPoolSlots();
         _loc2_ = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            _loc7_ = _loc3_.getActionButton();
            if(_loc7_ != null)
            {
               this.middleMenu.getMenuManager().removeActionButton(_loc7_);
               _loc3_.removeActionButton();
            }
            if(!_loc3_.isAllocated())
            {
               _loc3_.getMC().visible = false;
            }
            _loc2_++;
         }
         var _loc4_:Array = this.middleMenu.getMenuManager().actionButtonPatterns;
         var _loc5_:int = 1;
         this.middleMenu.getMenuManager().actionButtonsWithCooldowns = [];
         this.middleMenu.getMenuManager().getQuickMenu().updateCooldownButtonsArray();
         _loc2_ = 0;
         for(; _loc2_ < _loc4_.length; _loc2_++)
         {
            _loc6_ = _loc4_[_loc2_] as ActionButtonPattern;
            if(this.middleMenu.getMenuManager().isButtonBlacklisted(_loc6_.actionID))
            {
               continue;
            }
            if(_loc6_.getMenuID() != this.id)
            {
               continue;
            }
            if(_loc6_.canActivate)
            {
               _loc3_ = _loc1_[0];
               _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
               continue;
            }
            if(_loc6_.isAlwaysExist())
            {
               _loc3_ = _loc1_[_loc5_];
               _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
               _loc5_++;
               if(_loc3_.getActionButton().isTechButton)
               {
                  this.middleMenu.getMenuManager().actionButtonsWithCooldowns.push(_loc3_.getActionButton());
               }
               continue;
            }
            switch(_loc6_.actionID)
            {
               case SuperActionButton.ACTIVATION_SKILL_SOLACE:
                  _loc8_ = Boolean(Hero.skills[SkillDesignNames.SHIP_SKILL_SOLACE]);
                  if(_loc8_)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                     this.middleMenu.getMenuManager().actionButtonsWithCooldowns.push(_loc3_.getActionButton());
                  }
                  break;
               case SuperActionButton.ACTIVATION_SKILL_DIMINISHER:
                  _loc8_ = Boolean(Hero.skills[SkillDesignNames.SHIP_SKILL_DIMINISHER]);
                  if(_loc8_)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                     this.middleMenu.getMenuManager().actionButtonsWithCooldowns.push(_loc3_.getActionButton());
                  }
                  break;
               case SuperActionButton.ACTIVATION_SKILL_SENTINEL:
                  _loc8_ = Boolean(Hero.skills[SkillDesignNames.SHIP_SKILL_SENTINEL]);
                  if(_loc8_)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                     this.middleMenu.getMenuManager().actionButtonsWithCooldowns.push(_loc3_.getActionButton());
                  }
                  break;
               case SuperActionButton.ACTIVATION_SKILL_SPECTRUM:
                  _loc8_ = Boolean(Hero.skills[SkillDesignNames.SHIP_SKILL_SPECTRUM]);
                  if(_loc8_)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                     this.middleMenu.getMenuManager().actionButtonsWithCooldowns.push(_loc3_.getActionButton());
                  }
                  break;
               case SuperActionButton.ACTIVATION_SKILL_VENOM:
                  _loc8_ = Boolean(Hero.skills[SkillDesignNames.SHIP_SKILL_VENOM]);
                  if(_loc8_)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                     this.middleMenu.getMenuManager().actionButtonsWithCooldowns.push(_loc3_.getActionButton());
                  }
                  break;
               case SuperActionButton.ACTIVATION_SKILL_LIGHNTING:
                  _loc8_ = Boolean(Hero.skills[SkillDesignNames.SHIP_SKILL_LIGHTNING]);
                  if(_loc8_)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                     this.middleMenu.getMenuManager().actionButtonsWithCooldowns.push(_loc3_.getActionButton());
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_AIM:
                  _loc9_ = Hero.cpuItems[CPUItem.TYPE_AIM];
                  if(_loc9_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_AROL:
                  _loc10_ = Hero.cpuItems[CPUItem.TYPE_AROL];
                  if(_loc10_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_RLLB:
                  _loc11_ = Hero.cpuItems[CPUItem.TYPE_RLLB];
                  if(_loc11_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_CLOAK:
                  _loc12_ = Hero.cpuItems[CPUItem.TYPE_CLOAK];
                  if(_loc12_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_JUMP:
                  _loc13_ = Hero.cpuItems[CPUItem.TYPE_JUMP];
                  if(_loc13_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.SELECT_CPU_JUMP_TARGET:
                  _loc14_ = Hero.cpuItems[CPUItem.TYPE_ADVANCED_JUMP];
                  if(_loc14_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_ROBOT:
                  _loc15_ = Hero.cpuItems[CPUItem.TYPE_ROBOT];
                  if(_loc15_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_HM7:
                  _loc16_ = Hero.cpuItems[CPUItem.TYPE_HM7];
                  if(_loc16_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR:
                  _loc17_ = Hero.cpuItems[CPUItem.TYPE_DRONE_REPAIR];
                  if(_loc17_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_CPU_AMMOBUY:
                  _loc18_ = Hero.cpuItems[CPUItem.TYPE_AMMOBUY];
                  if(_loc18_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
               case SuperActionButton.ACTIVATION_TECH:
                  break;
               case SuperActionButton.ACTIVATION_CPU_ROCKETBUY:
                  _loc19_ = Hero.cpuItems[CPUItem.TYPE_ROCKETBUY];
                  if(_loc19_ != null)
                  {
                     _loc3_ = _loc1_[_loc5_++];
                     _loc3_.addActionButton(this.middleMenu.getMenuManager().createActionButton(_loc6_.actionID));
                  }
                  break;
            }
         }
         this.middleMenu.getMenuManager().updateRegisteredFlashingButtons();
         this.middleMenu.getMenuManager().updateTechs();
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         if(!this.actionDisabled.visible)
         {
            this.toggle();
         }
      }
      
      public function toggle() : void
      {
         var _loc3_:int = 0;
         var _loc4_:MenuButton = null;
         var _loc5_:Array = null;
         var _loc6_:ButtonSlot = null;
         var _loc7_:ActionButton = null;
         var _loc1_:Map = this.middleMenu.getMenuManager().getGuiManager().getMain().screenManager.map;
         if(_loc1_ != null)
         {
            if(_loc1_.getEventManager().isControlsLocked())
            {
               return;
            }
         }
         AudioManager.playSoundEffect(24);
         var _loc2_:Array = this.middleMenu.getMenuButtons();
         if(this.actionSelected.alpha == 0)
         {
            if(this.subAction)
            {
               this.middleMenu.getSubActionSlot().visible = true;
            }
            else
            {
               this.middleMenu.getSubActionSlot().visible = false;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               _loc4_.setDeselected();
               _loc3_++;
            }
            this.setSelected();
            this.updateButtonsInPool();
            if(this.id == 3)
            {
               this.middleMenu.getMenuManager().invalidateCPUButtons();
            }
            this.middleMenu.setPoolSlotVisibility(true);
            this.middleMenu.getMenuManager().getGuiManager().checkCooldowns();
         }
         else if(this.actionSelected.alpha == 1)
         {
            if(this.subAction)
            {
               this.middleMenu.getSubActionSlot().visible = false;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               _loc4_.setDeselected();
               _loc3_++;
            }
            _loc5_ = this.middleMenu.getPoolSlots();
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               _loc6_ = _loc5_[_loc3_];
               _loc7_ = _loc6_.getActionButton();
               if(_loc7_ != null)
               {
                  this.middleMenu.getMenuManager().removeActionButton(_loc7_);
               }
               _loc6_.removeActionButton();
               _loc3_++;
            }
            this.middleMenu.setPoolSlotVisibility(false);
         }
         this.middleMenu.getMenuManager().updateTechs();
      }
      
      public function addActionID(param1:int) : void
      {
         this.actionIDs.push(param1);
      }
      
      public function getMC() : MovieClip
      {
         return this.mc;
      }
      
      public function setSelected() : void
      {
         this.preselected = true;
         TweenLite.to(this.actionSelected,0.25,{"alpha":1});
      }
      
      public function isSelected() : Boolean
      {
         if(this.actionSelected.alpha == 1)
         {
            return true;
         }
         return false;
      }
      
      public function setDeselected() : void
      {
         this.preselected = false;
         TweenLite.to(this.actionSelected,0.25,{"alpha":0});
      }
      
      public function getID() : int
      {
         return this.id;
      }
      
      public function getActionIDs() : Array
      {
         return this.actionIDs;
      }
      
      public function hasSubAction() : Boolean
      {
         return this.subAction;
      }
      
      public function isPreselected() : Boolean
      {
         return this.preselected;
      }
      
      public function hasActionID(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.actionIDs.length)
         {
            if(param1 == this.actionIDs[_loc2_])
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function get enabled() : Boolean
      {
         if(this.actionDisabled.visible)
         {
            return false;
         }
         return true;
      }
      
      public function set enabled(param1:Boolean) : void
      {
         if(param1)
         {
            this.actionDisabled.visible = false;
         }
         else
         {
            this.actionDisabled.visible = true;
         }
      }
   }
}

