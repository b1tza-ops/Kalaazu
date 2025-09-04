package net.bigpoint.darkorbit.menu
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import net.bigpoint.AmmoPrice;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.catalog.SpecialAmmunition;
   import net.bigpoint.darkorbit.combat.LaserAttackJob;
   import net.bigpoint.darkorbit.combat.RocketPattern;
   import net.bigpoint.darkorbit.gui.ActionEvent;
   import net.bigpoint.darkorbit.gui.ButtonSlot;
   import net.bigpoint.darkorbit.gui.CPUItem;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.MenuButton;
   import net.bigpoint.darkorbit.gui.TechCooldown;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.models.SkillDesignsModel;
   import net.bigpoint.darkorbit.net.models.TechModel;
   import net.bigpoint.darkorbit.net.models.skills.SkillDesignItem;
   import net.bigpoint.darkorbit.net.models.skills.SkillDesignNames;
   import net.bigpoint.darkorbit.net.models.techs.TechItem;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   
   public class MenuManager extends Sprite
   {
      
      public static const logger:ILogger = Log.getLogger("MenuManager");
      
      private static var buttonBlacklist:Dictionary = new Dictionary();
      
      private static var menuButtonBlacklist:Dictionary = new Dictionary();
      
      private static var menuBlacklist:Dictionary = new Dictionary();
      
      private var guiManager:GuiManager;
      
      private var mainMenu:MainMenu;
      
      private var quickMenu:QuickMenu;
      
      private var actionSlotCount:int;
      
      private var gap:int;
      
      private var slotWidth:int;
      
      private var slotHeight:int;
      
      public var actionButtons:Array = [];
      
      public var actionButtonsWithCooldowns:Array = [];
      
      public var actionButtonPatterns:Array = [];
      
      private var flashingButtons:Array = [];
      
      public var rocketIDToButtonID:Dictionary = new Dictionary();
      
      public var buttonIDToRocketID:Dictionary = new Dictionary();
      
      private var lastClickedButtonID:int;
      
      public var buttonIDToTechID:Dictionary = new Dictionary();
      
      public var techIDToButtonID:Array = [];
      
      public var buttonIDToSkillDesignID:Dictionary = new Dictionary();
      
      public var skillDesignIDTobuttonID:Dictionary = new Dictionary();
      
      public var skillDesignButtonsArray:Array = [];
      
      public function MenuManager(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
         this.initButtonBlacklist();
         this.initMenuButtonBlacklist();
         this.getGuiManager().getMain().stage.addEventListener(MouseEvent.MOUSE_UP,this.handleMouseUp);
         this.init();
         this.quickMenu = new QuickMenu(this);
         this.quickMenu.init();
         this.addChild(this.quickMenu);
         TooltipControl.getInstance().addStickyToolTip(this.quickMenu,BPLocale.getText("httip_quickmenu"),param1.getMain().x,-80 + param1.getMain().y);
         this.mainMenu = new MainMenu(this);
         this.mainMenu.init();
         this.addChild(this.mainMenu);
         TooltipControl.getInstance().addStickyToolTip(this.mainMenu,BPLocale.getText("httip_mainmenu"),param1.getMain().x - 130,param1.getMain().y,600);
      }
      
      public function registerFlashingButton(param1:int, param2:Boolean) : void
      {
         this.flashingButtons[param1] = param2;
      }
      
      public function unregisterFlashingButton(param1:int) : void
      {
         delete this.flashingButtons[param1];
      }
      
      public function updateRegisteredFlashingButtons() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         for(_loc2_ in this.flashingButtons)
         {
            _loc1_ = int(_loc2_);
            this.guiManager.getMenuManager().flashButtonIcon(_loc1_,-1,this.flashingButtons[_loc1_]);
            this.guiManager.getTopMenu().flashButtonIcon(this.flashingButtons[_loc1_],-1,this.flashingButtons[_loc1_]);
         }
      }
      
      private function initButtonBlacklist() : void
      {
      }
      
      public function addButtonToBlacklist(param1:int) : void
      {
         buttonBlacklist[param1] = 1;
         this.updateSelectedMenu();
         this.quickMenu.refreshQuickmenu();
         this.guiManager.getTopMenu().refresh();
      }
      
      public function removeButtonFromBlacklist(param1:int) : void
      {
         buttonBlacklist[param1] = null;
         this.updateSelectedMenu();
         this.quickMenu.refreshQuickmenu();
         this.guiManager.getTopMenu().refresh();
      }
      
      public function isButtonBlacklisted(param1:int) : Boolean
      {
         if(buttonBlacklist[param1] != null)
         {
            return true;
         }
         return false;
      }
      
      private function initMenuButtonBlacklist() : void
      {
      }
      
      public function addMenuButtonToBlacklist(param1:int) : void
      {
         menuButtonBlacklist[param1] = 1;
         var _loc2_:MenuButton = this.getMainMenu().getMenuButton(param1);
         if(_loc2_ != null)
         {
            _loc2_.enabled = false;
         }
      }
      
      public function removeMenuButtonFromBlacklist(param1:int) : void
      {
         delete menuButtonBlacklist[param1];
         var _loc2_:MenuButton = this.getMainMenu().getMenuButton(param1);
         if(_loc2_ != null)
         {
            _loc2_.enabled = true;
         }
      }
      
      public function isMenuButtonBlacklisted(param1:int) : Boolean
      {
         if(menuButtonBlacklist[param1] != null)
         {
            return true;
         }
         return false;
      }
      
      public function addMenuToBlacklist(param1:String) : void
      {
         menuBlacklist[param1] = 1;
         this.updateMenuVisibility();
      }
      
      public function removeMenuFromBlacklist(param1:String) : void
      {
         delete menuBlacklist[param1];
         this.updateMenuVisibility();
      }
      
      public function isMenuBlacklisted(param1:String) : Boolean
      {
         if(menuBlacklist[param1] != null)
         {
            return true;
         }
         return false;
      }
      
      private function updateMenuVisibility() : void
      {
         if(this.isMenuBlacklisted("TOP"))
         {
            this.guiManager.getTopMenu().visible = false;
         }
         else
         {
            this.guiManager.getTopMenu().visible = true;
         }
         if(this.isMenuBlacklisted("MAIN"))
         {
            this.mainMenu.visible = false;
         }
         else
         {
            this.mainMenu.visible = true;
         }
         if(this.isMenuBlacklisted("QUICK"))
         {
            this.quickMenu.visible = false;
         }
         else
         {
            this.quickMenu.visible = true;
         }
      }
      
      public function updateSelectedMenu() : void
      {
         var _loc2_:MenuButton = null;
         var _loc1_:Array = this.mainMenu.getMenuButtons();
         for each(_loc2_ in _loc1_)
         {
            if(_loc2_.isSelected())
            {
               _loc2_.updateButtonsInPool();
            }
         }
      }
      
      public function updateAllCPUButtons() : void
      {
         var _loc1_:MenuButton = this.mainMenu.getMenuButton(3);
         if(_loc1_.isSelected())
         {
            _loc1_.updateButtonsInPool();
         }
         this.guiManager.getMenuManager().getQuickMenu().updateCPUButtonsInSlotMenu();
      }
      
      private function handleMouseUp(param1:MouseEvent) : void
      {
         this.mainMenu.onMouseUp();
         this.quickMenu.onMouseUp();
      }
      
      public function updateTechs() : void
      {
         var _loc1_:TechModel = null;
         var _loc4_:ActionButton = null;
         var _loc5_:TechItem = null;
         var _loc6_:SkillDesignItem = null;
         _loc1_ = this.guiManager.techModel;
         var _loc2_:SkillDesignsModel = this.guiManager.skillDesignsModel;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.actionButtonsWithCooldowns.length)
         {
            _loc4_ = this.actionButtonsWithCooldowns[_loc3_];
            switch(_loc4_.cooldownButtonType)
            {
               case ActionButton.COOLDOWN_TYPE_TECH:
                  _loc5_ = _loc1_.techs[this.buttonIDToTechID[_loc4_.actionID]];
                  if(_loc5_ != null)
                  {
                     this.updateButtonForTechID(_loc4_,_loc5_);
                     _loc4_.changeRemainingTechAmount(_loc5_.amount);
                     this.checkActionButtonCooldown(_loc4_,ActionButton.COOLDOWN_TYPE_TECH);
                  }
                  break;
               case ActionButton.COOLDOWN_TYPE_SKILL:
                  if(_loc2_ != null)
                  {
                     _loc6_ = _loc2_.skillDesigns[this.buttonIDToSkillDesignID[_loc4_.actionID]];
                     if(_loc6_ != null)
                     {
                        this.updateButtonForSkillDesign(_loc4_,_loc6_);
                        this.checkActionButtonCooldown(_loc4_,ActionButton.COOLDOWN_TYPE_SKILL);
                     }
                  }
                  break;
            }
            _loc3_++;
         }
      }
      
      private function updateButtonForSkillDesign(param1:ActionButton, param2:SkillDesignItem) : void
      {
         param1.updateTechTooltip(param2);
         if(!param2.equipped)
         {
            param1.lockButton();
            param1.toggleTechActiveLayer(false);
            return;
         }
         if(param2.status == SkillDesignItem.STATE_ACTIVE)
         {
            param1.setTechActiveTimer(param2.secondsLeft,param2);
            param1.toggleTechActiveLayer(true);
            param1.lockButton();
         }
         else if(param2.status == SkillDesignItem.STATE_READY)
         {
            param1.toggleTechActiveLayer(false);
            param1.unlockButton();
         }
         else if(param2.status == SkillDesignItem.STATE_COOLING)
         {
            param1.lockButton();
            param1.toggleTechActiveLayer(false);
         }
      }
      
      private function updateButtonForTechID(param1:ActionButton, param2:TechItem) : void
      {
         param1.updateTechTooltip(param2);
         switch(param2.status)
         {
            case TechItem.STATE_ACTIVE:
               param1.setTechActiveTimer(param2.secondsLeft,param2);
               param1.toggleTechActiveLayer(true);
               break;
            case TechItem.STATE_INACTIVE:
               param1.toggleTechActiveLayer(false);
               param1.lockButton();
               break;
            case TechItem.STATE_DEFAULT:
               param1.toggleTechActiveLayer(false);
               param1.lockButton();
               break;
            case TechItem.STATE_READY:
               param1.toggleTechActiveLayer(false);
               param1.unlockButton();
         }
      }
      
      private function checkActionButtonCooldown(param1:ActionButton, param2:String) : void
      {
         var _loc3_:TechModel = null;
         var _loc4_:SkillDesignsModel = null;
         var _loc5_:TechCooldown = null;
         var _loc6_:TechItem = null;
         var _loc7_:SkillDesignItem = null;
         _loc3_ = this.guiManager.techModel;
         _loc4_ = this.guiManager.skillDesignsModel;
         switch(param2)
         {
            case ActionButton.COOLDOWN_TYPE_TECH:
               _loc5_ = _loc3_.cooldowns[this.buttonIDToTechID[param1.actionID]];
               _loc6_ = _loc3_.techs[this.buttonIDToTechID[param1.actionID]];
               if(_loc5_.seconds != 0)
               {
                  this.setActionButtonCooldownGeneric(_loc6_,param1,_loc5_.seconds,_loc5_.startingTime,true);
               }
               break;
            case ActionButton.COOLDOWN_TYPE_SKILL:
               _loc5_ = _loc4_.cooldowns[this.buttonIDToSkillDesignID[param1.actionID]];
               _loc7_ = _loc4_.skillDesigns[this.buttonIDToSkillDesignID[param1.actionID]];
               if(_loc5_.seconds != 0)
               {
                  this.setActionButtonCooldownGeneric(_loc7_,param1,_loc5_.seconds,_loc5_.startingTime,true);
               }
         }
      }
      
      private function checkActionButtonCooldowns(param1:TechModel) : void
      {
         var _loc4_:TechCooldown = null;
         var _loc2_:int = param1.NUMBER_OF_TECHS;
         var _loc3_:int = 1;
         while(_loc3_ <= _loc2_)
         {
            _loc4_ = param1.cooldowns[_loc3_];
            if(_loc4_.seconds != 0)
            {
               this.setActionButtonCooldown(_loc4_.techID,_loc4_.seconds,_loc4_.startingTime,true);
            }
            _loc3_++;
         }
      }
      
      public function setActionButtonCooldownGeneric(param1:IAbilityItem, param2:ActionButton, param3:int, param4:int = 0, param5:Boolean = false) : void
      {
         if(!param2.isRunningCooldown)
         {
            if(param5 == false)
            {
               param2.setCooldown(0,param1,param3,param3,true);
            }
            else
            {
               param2.setCooldown(0,param1,param3,param4,true);
            }
         }
      }
      
      public function setActionButtonCooldown(param1:int, param2:int, param3:int = 0, param4:Boolean = false) : void
      {
         var _loc8_:ActionButton = null;
         var _loc5_:int = int(this.techIDToButtonID[param1]);
         var _loc6_:TechItem = this.guiManager.techModel.techs[param1];
         var _loc7_:int = 0;
         while(_loc7_ < this.actionButtons.length)
         {
            _loc8_ = this.actionButtons[_loc7_];
            if(_loc8_.getID() == _loc5_ && !_loc8_.isRunningCooldown)
            {
               if(param4 == false)
               {
                  _loc8_.setCooldown(0,_loc6_,param2,param2,true);
               }
               else
               {
                  _loc8_.setCooldown(0,_loc6_,param2,param3,true);
               }
            }
            _loc7_++;
         }
      }
      
      private function init() : void
      {
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:XMLList = null;
         var _loc9_:XML = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:ActionButtonPattern = null;
         var _loc14_:XML = null;
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         var _loc2_:Bitmap = _loc1_.getEmbededBitmap("slot");
         this.slotWidth = _loc2_.width;
         this.slotHeight = _loc2_.height;
         this.gap = int(Main.gameXML.menu.@gap);
         this.actionSlotCount = int(Main.gameXML.menu.@actionSlots);
         this.rocketIDToButtonID[RocketPattern.R310] = SuperActionButton.SELECTION_ROCKET_R_310;
         this.rocketIDToButtonID[RocketPattern.PLT_2026] = SuperActionButton.SELECTION_ROCKET_PLT_2026;
         this.rocketIDToButtonID[RocketPattern.PLT_2021] = SuperActionButton.SELECTION_ROCKET_PLT_2021;
         this.rocketIDToButtonID[RocketPattern.PLT_3030] = SuperActionButton.SELECTION_ROCKET_PLT_3030;
         this.rocketIDToButtonID[RocketPattern.PLD_8] = SuperActionButton.SELECTION_ROCKET_PLD_8;
         this.rocketIDToButtonID[RocketPattern.DCR_250] = SuperActionButton.SELECTION_ROCKET_DCR_250;
         this.rocketIDToButtonID[RocketPattern.WIZ] = SuperActionButton.SELECTION_ROCKET_WIZ;
         this.rocketIDToButtonID[RocketPattern.HSTRM01] = SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01;
         this.rocketIDToButtonID[RocketPattern.ECO10] = SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10;
         this.rocketIDToButtonID[RocketPattern.UBR100] = SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100;
         this.rocketIDToButtonID[RocketPattern.TYPE_ROCKET_LAUNCHER] = SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_ROCKET_R_310] = RocketPattern.R310;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_ROCKET_PLT_2026] = RocketPattern.PLT_2026;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_ROCKET_PLT_2021] = RocketPattern.PLT_2021;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_ROCKET_PLT_3030] = RocketPattern.PLT_3030;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_ROCKET_PLD_8] = RocketPattern.PLD_8;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_ROCKET_DCR_250] = RocketPattern.DCR_250;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_ROCKET_WIZ] = RocketPattern.WIZ;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01] = RocketPattern.HSTRM01;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10] = RocketPattern.ECO10;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100] = RocketPattern.UBR100;
         this.buttonIDToRocketID[SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER] = RocketPattern.TYPE_ROCKET_LAUNCHER;
         this.buttonIDToTechID[SuperActionButton.ACTIVATION_CHAIN_BOLT] = TechItem.TYPE_ENERGY_CHAIN_IMPULSE;
         this.buttonIDToTechID[SuperActionButton.ACTIVATION_ENERGY_LEECH] = TechItem.TYPE_ENERGY_LEECH_ARRAY;
         this.buttonIDToTechID[SuperActionButton.ACTIVATION_ROCKET_PRECISION] = TechItem.TYPE_ROCKET_PROBABILITY_MAXIMIZER;
         this.buttonIDToTechID[SuperActionButton.ACTIVATION_SHIELD_BACKUP] = TechItem.TYPE_SHIELD_BACKUP;
         this.buttonIDToTechID[SuperActionButton.ACTIVATION_SPEED_LEECH] = TechItem.TYPE_SPEED_LEECH;
         this.buttonIDToTechID[SuperActionButton.ACTIVATION_BATTLE_REP_BOT] = TechItem.TYPE_BATTLE_REPAIR_BOT;
         this.techIDToButtonID[TechItem.TYPE_ENERGY_CHAIN_IMPULSE] = SuperActionButton.ACTIVATION_CHAIN_BOLT;
         this.techIDToButtonID[TechItem.TYPE_ENERGY_LEECH_ARRAY] = SuperActionButton.ACTIVATION_ENERGY_LEECH;
         this.techIDToButtonID[TechItem.TYPE_ROCKET_PROBABILITY_MAXIMIZER] = SuperActionButton.ACTIVATION_ROCKET_PRECISION;
         this.techIDToButtonID[TechItem.TYPE_SHIELD_BACKUP] = SuperActionButton.ACTIVATION_SHIELD_BACKUP;
         this.techIDToButtonID[TechItem.TYPE_SPEED_LEECH] = SuperActionButton.ACTIVATION_SPEED_LEECH;
         this.techIDToButtonID[TechItem.TYPE_BATTLE_REPAIR_BOT] = SuperActionButton.ACTIVATION_BATTLE_REP_BOT;
         this.buttonIDToSkillDesignID[SuperActionButton.ACTIVATION_SKILL_SOLACE] = SkillDesignNames.SHIP_SKILL_SOLACE;
         this.buttonIDToSkillDesignID[SuperActionButton.ACTIVATION_SKILL_DIMINISHER] = SkillDesignNames.SHIP_SKILL_DIMINISHER;
         this.buttonIDToSkillDesignID[SuperActionButton.ACTIVATION_SKILL_SPECTRUM] = SkillDesignNames.SHIP_SKILL_SPECTRUM;
         this.buttonIDToSkillDesignID[SuperActionButton.ACTIVATION_SKILL_SENTINEL] = SkillDesignNames.SHIP_SKILL_SENTINEL;
         this.buttonIDToSkillDesignID[SuperActionButton.ACTIVATION_SKILL_VENOM] = SkillDesignNames.SHIP_SKILL_VENOM;
         this.buttonIDToSkillDesignID[SuperActionButton.ACTIVATION_SKILL_LIGHNTING] = SkillDesignNames.SHIP_SKILL_LIGHTNING;
         this.skillDesignIDTobuttonID[SkillDesignNames.SHIP_SKILL_SOLACE] = SuperActionButton.ACTIVATION_SKILL_SOLACE;
         this.skillDesignIDTobuttonID[SkillDesignNames.SHIP_SKILL_DIMINISHER] = SuperActionButton.ACTIVATION_SKILL_DIMINISHER;
         this.skillDesignIDTobuttonID[SkillDesignNames.SHIP_SKILL_SPECTRUM] = SuperActionButton.ACTIVATION_SKILL_SPECTRUM;
         this.skillDesignIDTobuttonID[SkillDesignNames.SHIP_SKILL_SENTINEL] = SuperActionButton.ACTIVATION_SKILL_SENTINEL;
         this.skillDesignIDTobuttonID[SkillDesignNames.SHIP_SKILL_VENOM] = SuperActionButton.ACTIVATION_SKILL_VENOM;
         this.skillDesignIDTobuttonID[SkillDesignNames.SHIP_SKILL_LIGHTNING] = SuperActionButton.ACTIVATION_SKILL_LIGHNTING;
         this.lastClickedButtonID = this.rocketIDToButtonID[Settings.selectedRocket];
         for each(_loc3_ in Main.gameXML.menu.menuButtons.menuButton)
         {
            _loc4_ = int(_loc3_.@id);
            _loc5_ = _loc3_.actionButtons.@stdIcon;
            _loc6_ = _loc3_.actionButtons.@hoverIcon;
            _loc7_ = _loc3_.actionButtons.@selectedIcon;
            if(_loc3_.actionButtons.activateButton.length() == 1)
            {
               _loc9_ = _loc3_.actionButtons.activateButton[0];
               _loc10_ = int(_loc9_.@id);
               _loc11_ = _loc9_.@resKey;
               _loc12_ = _loc9_.@languageKey;
               _loc13_ = new ActionButtonPattern(_loc10_,_loc4_,_loc11_,_loc5_,_loc6_,_loc7_,_loc12_,null,true);
               if(_loc9_.@customizable.length() > 0)
               {
                  _loc13_.isCustomizable = Main.parseBooleanFromString(_loc9_.@customizable);
               }
               this.actionButtonPatterns.push(_loc13_);
            }
            if(_loc3_.actionButtons.section.length() > 0)
            {
               for each(_loc14_ in _loc3_.actionButtons.section)
               {
                  _loc8_ = _loc14_.actionButton;
                  this.parseAndAddButtonPatterns(_loc8_,_loc4_,_loc5_,_loc6_,_loc7_,String(_loc14_.@id));
               }
            }
            else
            {
               _loc8_ = _loc3_.actionButtons.actionButton;
               this.parseAndAddButtonPatterns(_loc8_,_loc4_,_loc5_,_loc6_,_loc7_);
            }
         }
      }
      
      private function parseAndAddButtonPatterns(param1:XMLList, param2:int, param3:String, param4:String, param5:String, param6:String = null) : void
      {
         var _loc7_:XML = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:ActionButtonPattern = null;
         for each(_loc7_ in param1)
         {
            _loc8_ = int(_loc7_.@id);
            _loc9_ = _loc7_.@resKey;
            if(_loc7_.@languageKey.length() > 0)
            {
               _loc10_ = _loc7_.@languageKey;
            }
            _loc11_ = new ActionButtonPattern(_loc8_,param2,_loc9_,param3,param4,param5,_loc10_,param6);
            if(_loc7_.@ammobar.length() > 0)
            {
               _loc11_.setAmmobar(Main.parseBooleanFromString(_loc7_.@ammobar));
            }
            if(_loc7_.@alwaysExist.length() > 0)
            {
               _loc11_.setAlwaysExist(Main.parseBooleanFromString(_loc7_.@alwaysExist));
            }
            if(_loc7_.@counter.length() > 0)
            {
               _loc11_.setCounter(Main.parseBooleanFromString(_loc7_.@counter));
            }
            if(_loc7_.@active.length() > 0)
            {
               _loc11_.isActiveAtStart = Main.parseBooleanFromString(_loc7_.@active);
            }
            if(_loc7_.@cooldown.length() > 0)
            {
               _loc11_.setCooldown(Main.parseBooleanFromString(_loc7_.@cooldown));
            }
            if(_loc7_.@customizable.length() > 0)
            {
               _loc11_.isCustomizable = Main.parseBooleanFromString(_loc7_.@customizable);
            }
            this.actionButtonPatterns.push(_loc11_);
         }
      }
      
      public function addOnMouseUpListeners() : void
      {
         var _loc2_:ActionButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.actionButtons.length)
         {
            _loc2_ = this.actionButtons[_loc1_];
            _loc2_.addMouseUpListener();
            _loc1_++;
         }
      }
      
      public function removeOnMouseUpListeners() : void
      {
         var _loc2_:ActionButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.actionButtons.length)
         {
            _loc2_ = this.actionButtons[_loc1_];
            _loc2_.removeMouseUpListener();
            _loc1_++;
         }
      }
      
      public function getParentSlot(param1:ActionButton) : ButtonSlot
      {
         var _loc3_:ButtonSlot = null;
         var _loc4_:ActionButton = null;
         var _loc2_:Array = this.mainMenu.getPoolSlots();
         for each(_loc3_ in _loc2_)
         {
            _loc4_ = _loc3_.getActionButton();
            if(_loc4_ != null && _loc4_ == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function setButtonLabel(param1:int, param2:int) : void
      {
         var _loc4_:ActionButton = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.actionButtons.length)
         {
            _loc4_ = this.actionButtons[_loc3_];
            if(_loc4_.getID() == param1)
            {
               if(!_loc4_.isTechButton)
               {
                  if(_loc4_.containsNumbersContainer())
                  {
                     _loc4_.setCount(param2);
                  }
                  if(_loc4_.hasAmmobar())
                  {
                     _loc4_.updateAmmoMaxValue();
                     _loc4_.setAmmobar(param2);
                  }
               }
               _loc4_.updateTooltip();
            }
            _loc3_++;
         }
      }
      
      public function updateAmmunitionDisplay() : void
      {
         var _loc2_:ActionButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.actionButtons.length)
         {
            _loc2_ = this.actionButtons[_loc1_];
            _loc2_.updateAmmunitionDisplay();
            _loc1_++;
         }
      }
      
      public function setIconIndex(param1:int, param2:int = 0) : void
      {
         var _loc4_:ActionButton = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.actionButtons.length)
         {
            _loc4_ = this.actionButtons[_loc3_];
            if(_loc4_.getID() == param1 && param2 > 0)
            {
               _loc4_.setIcon(param2);
               _loc4_.unlockButton();
               if(_loc4_.containsNumbersContainer())
               {
                  _loc4_.setCounterVisibility(true);
               }
            }
            _loc3_++;
         }
      }
      
      public function invalidateCPUButtons() : void
      {
         var _loc12_:int = 0;
         var _loc14_:Map = null;
         var _loc15_:Ship = null;
         var _loc1_:CPUItem = Hero.cpuItems[CPUItem.TYPE_JUMP];
         var _loc2_:CPUItem = Hero.cpuItems[CPUItem.TYPE_CLOAK];
         var _loc3_:CPUItem = Hero.cpuItems[CPUItem.TYPE_AROL];
         var _loc4_:CPUItem = Hero.cpuItems[CPUItem.TYPE_RLLB];
         var _loc5_:CPUItem = Hero.cpuItems[CPUItem.TYPE_ROBOT];
         var _loc6_:CPUItem = Hero.cpuItems[CPUItem.TYPE_AIM];
         var _loc7_:CPUItem = Hero.cpuItems[CPUItem.TYPE_HM7];
         var _loc8_:CPUItem = Hero.cpuItems[CPUItem.TYPE_DRONE_REPAIR];
         var _loc9_:CPUItem = Hero.cpuItems[CPUItem.TYPE_AMMOBUY];
         var _loc10_:CPUItem = Hero.cpuItems[CPUItem.TYPE_ROCKETBUY];
         var _loc11_:CPUItem = Hero.cpuItems[CPUItem.TYPE_ADVANCED_JUMP];
         var _loc13_:int = 3;
         if(_loc1_ != null)
         {
            _loc12_ = _loc1_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_JUMP,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_JUMP,_loc1_.amount);
         }
         if(_loc11_ != null)
         {
            _loc12_ = _loc11_.level;
            this.setIconIndex(SuperActionButton.SELECT_CPU_JUMP_TARGET,_loc12_);
            this.setButtonLabel(SuperActionButton.SELECT_CPU_JUMP_TARGET,_loc11_.amount);
         }
         if(_loc2_ != null)
         {
            _loc12_ = 1;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_CLOAK,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_CLOAK,_loc2_.amount);
            _loc14_ = this.guiManager.getMain().screenManager.map;
            if(_loc14_ != null)
            {
               _loc15_ = _loc14_.getShipManager().getHero();
               if(_loc15_ != null)
               {
                  if(_loc15_.isInvisible())
                  {
                     this.setButtonAccess(SuperActionButton.ACTIVATION_CPU_CLOAK,false);
                     this.setButtonSelected(SuperActionButton.ACTIVATION_CPU_CLOAK,true);
                  }
                  else
                  {
                     this.setButtonAccess(SuperActionButton.ACTIVATION_CPU_CLOAK,true);
                     this.setButtonSelected(SuperActionButton.ACTIVATION_CPU_CLOAK,false);
                  }
               }
            }
         }
         if(_loc3_ != null)
         {
            _loc12_ = _loc3_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_AROL,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_AROL,_loc3_.amount);
            this.togglePoolButton(SuperActionButton.ACTIVATION_CPU_AROL,_loc3_.state,_loc13_);
            this.toggleQuickstartButton(SuperActionButton.ACTIVATION_CPU_AROL,_loc3_.state);
         }
         if(_loc4_ != null)
         {
            _loc12_ = _loc4_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_RLLB,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_RLLB,_loc4_.amount);
            this.togglePoolButton(SuperActionButton.ACTIVATION_CPU_RLLB,_loc4_.state,_loc13_);
            this.toggleQuickstartButton(SuperActionButton.ACTIVATION_CPU_RLLB,_loc4_.state);
         }
         if(_loc5_ != null)
         {
            _loc12_ = _loc5_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_ROBOT,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_ROBOT,_loc5_.amount);
         }
         if(_loc6_ != null)
         {
            _loc12_ = _loc6_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_AIM,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_AIM,_loc6_.amount);
            this.togglePoolButton(SuperActionButton.ACTIVATION_CPU_AIM,_loc6_.state,_loc13_);
            this.toggleQuickstartButton(SuperActionButton.ACTIVATION_CPU_AIM,_loc6_.state);
         }
         if(_loc7_ != null)
         {
            _loc12_ = _loc7_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_HM7,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_HM7,_loc7_.amount);
            this.togglePoolButton(SuperActionButton.ACTIVATION_CPU_HM7,_loc7_.state,_loc13_);
         }
         if(_loc8_ != null)
         {
            _loc12_ = _loc8_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR,_loc8_.amount);
            this.togglePoolButton(SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR,_loc8_.state,_loc13_);
         }
         if(_loc9_ != null)
         {
            _loc12_ = _loc9_.level;
            this.setIconIndex(SuperActionButton.ACTIVATION_CPU_AMMOBUY,_loc12_);
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_AMMOBUY,_loc9_.amount);
            this.togglePoolButton(SuperActionButton.ACTIVATION_CPU_AMMOBUY,_loc9_.state,_loc13_);
         }
         if(_loc10_ != null)
         {
            _loc12_ = _loc10_.level;
            this.setButtonLabel(SuperActionButton.ACTIVATION_CPU_ROCKETBUY,_loc10_.amount);
            this.togglePoolButton(SuperActionButton.ACTIVATION_CPU_ROCKETBUY,true,_loc13_);
         }
      }
      
      public function updateAllButtonAmounts() : void
      {
         this.updateLaserButtonAmounts();
         this.updateRocketButtonAmounts();
         this.updateLauncherRocketButtonAmounts();
         this.updateExplosiveButtonAmmounts();
         this.updateFireworkButtonAmounts();
      }
      
      public function updateLaserButtonAmounts() : void
      {
         this.setButtonLabel(SuperActionButton.SELECTION_LASER_1,Hero.laserBatteryAmounts[0]);
         this.setButtonLabel(SuperActionButton.SELECTION_LASER_2,Hero.laserBatteryAmounts[1]);
         this.setButtonLabel(SuperActionButton.SELECTION_LASER_3,Hero.laserBatteryAmounts[2]);
         this.setButtonLabel(SuperActionButton.SELECTION_LASER_4,Hero.laserBatteryAmounts[3]);
         this.setButtonLabel(SuperActionButton.SELECTION_LASER_5,Hero.laserBatteryAmounts[4]);
         this.setButtonLabel(SuperActionButton.SELECTION_LASER_6,Hero.laserBatteryAmounts[5]);
      }
      
      public function updateTechButtonLabels() : void
      {
         this.setButtonLabel(SuperActionButton.ACTIVATION_ENERGY_LEECH,0);
         this.setButtonLabel(SuperActionButton.ACTIVATION_CHAIN_BOLT,0);
         this.setButtonLabel(SuperActionButton.ACTIVATION_ROCKET_PRECISION,0);
         this.setButtonLabel(SuperActionButton.ACTIVATION_SHIELD_BACKUP,0);
         this.setButtonLabel(SuperActionButton.ACTIVATION_SPEED_LEECH,0);
         this.setButtonLabel(SuperActionButton.ACTIVATION_BATTLE_REP_BOT,0);
      }
      
      public function updateRocketButtonAmounts() : void
      {
         this.setButtonLabel(SuperActionButton.SELECTION_ROCKET_R_310,Hero.rocketAmounts[RocketPattern.R310]);
         this.setButtonLabel(SuperActionButton.SELECTION_ROCKET_PLT_2026,Hero.rocketAmounts[RocketPattern.PLT_2026]);
         this.setButtonLabel(SuperActionButton.SELECTION_ROCKET_PLT_2021,Hero.rocketAmounts[RocketPattern.PLT_2021]);
         this.setButtonLabel(SuperActionButton.SELECTION_ROCKET_PLT_3030,Hero.rocketAmounts[RocketPattern.PLT_3030]);
         this.setButtonLabel(SuperActionButton.SELECTION_ROCKET_PLD_8,Hero.rocketAmounts[RocketPattern.PLD_8]);
         this.setButtonLabel(SuperActionButton.SELECTION_ROCKET_DCR_250,Hero.rocketAmounts[RocketPattern.DCR_250]);
         this.setButtonLabel(SuperActionButton.SELECTION_ROCKET_WIZ,Hero.rocketAmounts[RocketPattern.WIZ]);
      }
      
      public function updateLauncherRocketButtonAmounts() : void
      {
         this.setButtonLabel(SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01,Hero.rocketAmounts[RocketPattern.HSTRM01]);
         this.setButtonLabel(SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100,Hero.rocketAmounts[RocketPattern.UBR100]);
         this.setButtonLabel(SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10,Hero.rocketAmounts[RocketPattern.ECO10]);
      }
      
      public function updateExplosiveButtonAmmounts() : void
      {
         this.setButtonLabel(SuperActionButton.SELECTION_MINE,Hero.explosiveAmounts[SpecialAmmunition.MINE]);
         this.setButtonLabel(SuperActionButton.SELECTION_MINE_EMP,Hero.explosiveAmounts[SpecialAmmunition.MINE_EMP]);
         this.setButtonLabel(SuperActionButton.SELECTION_MINE_SAB,Hero.explosiveAmounts[SpecialAmmunition.MINE_SAB]);
         this.setButtonLabel(SuperActionButton.SELECTION_MINE_DDM,Hero.explosiveAmounts[SpecialAmmunition.MINE_DDM]);
         this.setButtonLabel(SuperActionButton.SELECTION_SMARTBOMB,Hero.explosiveAmounts[SpecialAmmunition.SMARTBOMB]);
         this.setButtonLabel(SuperActionButton.SELECTION_INSTASHIELD,Hero.explosiveAmounts[SpecialAmmunition.INSTASHIELD]);
         this.setButtonLabel(SuperActionButton.SELECTION_EMP,Hero.explosiveAmounts[SpecialAmmunition.EMP]);
         this.setButtonAccess(SuperActionButton.SELECTION_INSTASHIELD,Hero.cpuItems[CPUItem.TYPE_INSTASHIELD] != null);
         this.setButtonAccess(SuperActionButton.SELECTION_SMARTBOMB,Hero.cpuItems[CPUItem.TYPE_SMARTBOMB] != null);
      }
      
      public function updateFireworkButtonAmounts() : void
      {
         var _loc2_:int = 0;
         this.setButtonLabel(SuperActionButton.SELECTION_FIREWORK_1,Hero.fireworksAmounts[0]);
         this.setButtonLabel(SuperActionButton.SELECTION_FIREWORK_2,Hero.fireworksAmounts[1]);
         this.setButtonLabel(SuperActionButton.SELECTION_FIREWORK_3,Hero.fireworksAmounts[2]);
         var _loc1_:MenuManager = this.guiManager.getMenuManager();
         if(_loc1_ != null)
         {
            _loc2_ = Settings.fireworksLoaded;
         }
      }
      
      public function createActionButton(param1:int) : ActionButton
      {
         var _loc3_:ActionButton = null;
         var _loc2_:ActionButtonPattern = this.getActionButtonPattern(param1);
         if(_loc2_ == null)
         {
            return null;
         }
         _loc3_ = new ActionButton(this,_loc2_);
         _loc3_.isRunningCooldown = false;
         _loc3_.init();
         if(_loc2_.isActiveAtStart)
         {
            _loc3_.unlockButton();
         }
         else
         {
            _loc3_.lockButton();
         }
         this.actionButtons.push(_loc3_);
         _loc3_.addEventListener(ActionEvent.ACTION,this.onAction);
         this.updateAllButtonAmounts();
         this.invalidateCPUButtons();
         this.updateAmmoPrices();
         this.updateSelectableButtons();
         _loc3_.addMouseUpListener();
         return _loc3_;
      }
      
      public function onAction(param1:ActionEvent) : void
      {
         this.proccessAction(param1.getActionID(),param1.getEnvironment());
      }
      
      public function proccessAction(param1:int, param2:int) : void
      {
         var _loc3_:SimpleWindow = null;
         var _loc4_:int = 0;
         switch(param1)
         {
            case SuperActionButton.ACTIVATION_LASER:
               this.guiManager.getMain().screenManager.map.getEventManager().toggleLaserAttack(param2);
               break;
            case SuperActionButton.ACTIVATION_ROCKET:
               this.guiManager.getMain().screenManager.map.getEventManager().activateRocket(param2);
               break;
            case SuperActionButton.ACTIVATION_EXPLOSIVE:
               this.guiManager.getMain().screenManager.map.getEventManager().activateExplosive();
               break;
            case SuperActionButton.SELECTION_LASER_1:
               this.laserSelected(1,param2);
               break;
            case SuperActionButton.SELECTION_LASER_2:
               this.laserSelected(2,param2);
               break;
            case SuperActionButton.SELECTION_LASER_3:
               this.laserSelected(3,param2);
               break;
            case SuperActionButton.SELECTION_LASER_4:
               this.laserSelected(4,param2);
               break;
            case SuperActionButton.SELECTION_LASER_5:
               this.laserSelected(5,param2);
               break;
            case SuperActionButton.SELECTION_LASER_6:
               this.laserSelected(6,param2);
               break;
            case SuperActionButton.SELECTION_ROCKET_R_310:
            case SuperActionButton.SELECTION_ROCKET_PLT_2026:
            case SuperActionButton.SELECTION_ROCKET_PLT_2021:
            case SuperActionButton.SELECTION_ROCKET_PLT_3030:
            case SuperActionButton.SELECTION_ROCKET_PLD_8:
            case SuperActionButton.SELECTION_ROCKET_DCR_250:
            case SuperActionButton.SELECTION_ROCKET_WIZ:
            case SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10:
               this.updateRocketTypeSelection(this.buttonIDToRocketID[param1],param2);
               break;
            case SuperActionButton.SELECTION_MINE:
               this.explosiveSelected(1,param2);
               break;
            case SuperActionButton.SELECTION_SMARTBOMB:
               this.explosiveSelected(2,param2);
               break;
            case SuperActionButton.SELECTION_INSTASHIELD:
               this.explosiveSelected(3,param2);
               break;
            case SuperActionButton.SELECTION_EMP:
               this.explosiveSelected(4,param2);
               break;
            case SuperActionButton.SELECTION_FIREWORK_1:
               this.explosiveSelected(5,param2);
               break;
            case SuperActionButton.SELECTION_FIREWORK_2:
               this.explosiveSelected(6,param2);
               break;
            case SuperActionButton.SELECTION_FIREWORK_3:
               this.explosiveSelected(7,param2);
               break;
            case SuperActionButton.FIREWORK_IGNITE:
               this.explosiveSelected(8,param2);
               break;
            case SuperActionButton.SELECTION_MINE_EMP:
               this.explosiveSelected(9,param2);
               break;
            case SuperActionButton.SELECTION_MINE_SAB:
               this.explosiveSelected(10,param2);
               break;
            case SuperActionButton.SELECTION_MINE_DDM:
               this.explosiveSelected(11,param2);
               break;
            case SuperActionButton.ACTIVATION_CPU_JUMP:
               this.guiManager.getMain().screenManager.map.getEventManager().activateJumpCPU();
               break;
            case SuperActionButton.SELECT_CPU_JUMP_TARGET:
               this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).maximize();
               break;
            case SuperActionButton.ACTIVATION_CPU_CLOAK:
               this.guiManager.getMain().screenManager.map.getEventManager().activateCloakCPU();
               break;
            case SuperActionButton.ACTIVATION_CPU_ROBOT:
               this.guiManager.getMain().screenManager.map.getEventManager().activateRobot();
               break;
            case SuperActionButton.ACTIVATION_CPU_AIM:
               this.guiManager.getMain().screenManager.map.getEventManager().activateAimCPU();
               break;
            case SuperActionButton.ACTIVATION_CPU_AROL:
               this.guiManager.getMain().screenManager.map.getEventManager().activateArolCPU();
               break;
            case SuperActionButton.ACTIVATION_CPU_RLLB:
               this.guiManager.getMain().screenManager.map.getEventManager().toggleRllbCpu();
               break;
            case SuperActionButton.ACTIVATION_CPU_HM7:
               _loc3_ = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_TRADE);
               _loc3_.unlockWindow();
               _loc3_.maximize();
               this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.GET_ORE_PRICES);
               break;
            case SuperActionButton.BUY_LASER_1:
               Settings.selectedQuickBuyIcon = 1;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,1);
                  this.flashButton(SuperActionButton.BUY_LASER_1,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.BUY_LASER_2:
               Settings.selectedQuickBuyIcon = 2;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,2);
                  this.flashButton(SuperActionButton.BUY_LASER_2,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.BUY_LASER_3:
               Settings.selectedQuickBuyIcon = 3;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,3);
                  this.flashButton(SuperActionButton.BUY_LASER_3,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.BUY_LASER_4:
               break;
            case SuperActionButton.BUY_LASER_5:
               Settings.selectedQuickBuyIcon = 5;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,5);
                  this.flashButton(SuperActionButton.BUY_LASER_5,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.BUY_ROCKET_R_310:
               Settings.selectedQuickBuyIcon = 6;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,1);
                  this.flashButton(SuperActionButton.BUY_ROCKET_R_310,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.BUY_ROCKET_PLT_2026:
               Settings.selectedQuickBuyIcon = 7;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,2);
                  this.flashButton(SuperActionButton.BUY_ROCKET_PLT_2026,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.BUY_ROCKET_PLT_2021:
               Settings.selectedQuickBuyIcon = 8;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,3);
                  this.flashButton(SuperActionButton.BUY_ROCKET_PLT_2021,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.BUY_ROCKET_PLT_3030:
               Settings.selectedQuickBuyIcon = 9;
               if(param2 == ActionButton.ENV_QUICKSTART)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,RocketPattern.PLT_3030);
                  this.flashButton(SuperActionButton.BUY_ROCKET_PLT_3030,true);
               }
               else
               {
                  this.updateSelectedQuickBuyButtons();
               }
               break;
            case SuperActionButton.ACTIVATION_BUY:
               _loc4_ = Settings.selectedQuickBuyIcon;
               switch(_loc4_)
               {
                  case 1:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,1);
                     break;
                  case 2:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,2);
                     break;
                  case 3:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,3);
                     break;
                  case 5:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_LASER,5);
                     break;
                  case 6:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,RocketPattern.R310);
                     break;
                  case 7:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,RocketPattern.PLT_2026);
                     break;
                  case 8:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,RocketPattern.PLT_2021);
                     break;
                  case 9:
                     this.guiManager.getMain().screenManager.map.getEventManager().quickBuy(ServerCommands.BUY_ROCKET,RocketPattern.PLT_3030);
               }
               this.flashButton(SuperActionButton.ACTIVATION_BUY);
               break;
            case SuperActionButton.ACTIVATION_CHAIN_BOLT:
            case SuperActionButton.ACTIVATION_ENERGY_LEECH:
            case SuperActionButton.ACTIVATION_SHIELD_BACKUP:
            case SuperActionButton.ACTIVATION_ROCKET_PRECISION:
            case SuperActionButton.ACTIVATION_BATTLE_REP_BOT:
            case SuperActionButton.ACTIVATION_SPEED_LEECH:
               if(this.guiManager.techModel != null)
               {
                  this.guiManager.techModel.activateTechByID(this.buttonIDToTechID[param1]);
               }
               break;
            case SuperActionButton.ACTIVATION_SKILL_SOLACE:
            case SuperActionButton.ACTIVATION_SKILL_DIMINISHER:
            case SuperActionButton.ACTIVATION_SKILL_SPECTRUM:
            case SuperActionButton.ACTIVATION_SKILL_SENTINEL:
            case SuperActionButton.ACTIVATION_SKILL_VENOM:
            case SuperActionButton.ACTIVATION_SKILL_LIGHNTING:
               if(this.guiManager.skillDesignsModel != null)
               {
                  this.guiManager.skillDesignsModel.activateCurrentSkill();
               }
         }
      }
      
      public function removeActionButton(param1:ActionButton) : void
      {
         var _loc3_:ActionButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.actionButtons.length)
         {
            _loc3_ = this.actionButtons[_loc2_];
            if(_loc3_ == param1)
            {
               param1.cleanup();
               this.actionButtons.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function getActionButtonPattern(param1:int) : ActionButtonPattern
      {
         var _loc3_:ActionButtonPattern = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.actionButtonPatterns.length)
         {
            _loc3_ = this.actionButtonPatterns[_loc2_];
            if(_loc3_.actionID == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function getActionButton(param1:int) : ActionButton
      {
         var _loc3_:ActionButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.actionButtons.length)
         {
            _loc3_ = this.actionButtons[_loc2_];
            if(_loc3_.getID() == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function setButtonAccess(param1:int, param2:Boolean) : void
      {
         var _loc3_:ActionButton = null;
         for each(_loc3_ in this.actionButtons)
         {
            if(_loc3_.getID() == param1)
            {
               if(param2)
               {
                  _loc3_.unlockButton();
               }
               else
               {
                  _loc3_.lockButton();
               }
            }
         }
      }
      
      public function setButtonSelected(param1:int, param2:Boolean) : void
      {
         var _loc3_:ActionButton = null;
         for each(_loc3_ in this.actionButtons)
         {
            if(_loc3_.getID() == param1)
            {
               if(param2)
               {
                  _loc3_.setSelected();
               }
               else
               {
                  _loc3_.setDeselected();
               }
            }
         }
      }
      
      public function getActionButtons() : Array
      {
         return this.actionButtons;
      }
      
      public function getActionButtonsByID(param1:int) : Array
      {
         var _loc3_:ActionButton = null;
         var _loc2_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < this.actionButtons.length)
         {
            _loc3_ = this.actionButtons[_loc4_] as ActionButton;
            if(_loc3_.actionID == param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function getActionButtonInPoolByID(param1:int) : ActionButton
      {
         var _loc2_:ActionButton = null;
         for each(_loc2_ in this.actionButtons)
         {
            if(_loc2_.actionID == param1 && _loc2_.getEnvironment() == ActionButton.ENV_POOL)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function updateRocketTypeSelection(param1:int, param2:int) : void
      {
         var _loc3_:MapObject = null;
         if(param1 == RocketPattern.TYPE_ROCKET_LAUNCHER)
         {
            this.guiManager.getMain().screenManager.map.getEventManager().loadRocketLauncher(param2);
         }
         else
         {
            this.guiManager.getMain().screenManager.map.getEventManager().selectRocket(param1);
            _loc3_ = this.guiManager.getMain().screenManager.map.getShipManager().getSelectedShip();
            if(param2 == ActionButton.ENV_QUICKSTART && _loc3_ != null)
            {
               this.guiManager.getMain().screenManager.map.getEventManager().activateRocket(param2);
            }
         }
         this.lastClickedButtonID = this.rocketIDToButtonID[param1];
         this.updateQuickstartRocketButtons();
         this.updateRocketCategoryButtons();
      }
      
      public function togglePoolButton(param1:int, param2:Boolean, param3:int = 0) : void
      {
         var _loc4_:String = null;
         var _loc5_:ActionButton = null;
         if(param3 == SuperActionButton.ACTIVATION_ROCKET && this.getActionButton(param1) != null)
         {
            _loc4_ = this.getActionButton(param1).section;
         }
         for each(_loc5_ in this.actionButtons)
         {
            if(_loc5_ != null)
            {
               if(_loc5_.getEnvironment() == ActionButton.ENV_POOL)
               {
                  if(_loc5_.getMenuID() == param3)
                  {
                     if(_loc5_.getID() == param1)
                     {
                        if(param2)
                        {
                           _loc5_.setSelected();
                        }
                        else
                        {
                           _loc5_.setDeselected();
                        }
                     }
                     else if(null != _loc4_ && _loc5_.section == _loc4_)
                     {
                        _loc5_.setDeselected();
                     }
                  }
               }
            }
         }
      }
      
      public function toggleQuickstartButton(param1:int, param2:Boolean) : void
      {
         var _loc3_:ActionButton = null;
         for each(_loc3_ in this.actionButtons)
         {
            if(_loc3_ != null)
            {
               if(_loc3_.getEnvironment() == ActionButton.ENV_QUICKSTART)
               {
                  if(_loc3_.getID() == param1)
                  {
                     if(param2)
                     {
                        _loc3_.setSelected();
                     }
                     else
                     {
                        _loc3_.setDeselected();
                     }
                  }
               }
            }
         }
      }
      
      public function flashButton(param1:int, param2:Boolean = false) : void
      {
         var _loc4_:ActionButton = null;
         var _loc5_:ButtonSlot = null;
         var _loc6_:Array = null;
         var _loc3_:Array = this.quickMenu.getQuickstartSlots();
         for each(_loc5_ in _loc3_)
         {
            _loc4_ = _loc5_.getActionButton();
            if(_loc4_ != null)
            {
               if(_loc4_.getID() == param1)
               {
                  _loc4_.startFlash();
               }
            }
         }
         _loc6_ = this.mainMenu.getPoolSlots();
         if(!param2)
         {
            for each(_loc5_ in _loc6_)
            {
               _loc4_ = _loc5_.getActionButton();
               if(_loc4_ != null)
               {
                  if(_loc4_.getID() == param1)
                  {
                     _loc4_.startFlash();
                  }
               }
            }
         }
      }
      
      public function getGuiManager() : GuiManager
      {
         return this.guiManager;
      }
      
      public function updateSelectableButtons() : void
      {
         this.updatePoolLaserButtons();
         this.updateRocketCategoryButtons();
         this.updatePoolExplosiveButtons();
         this.updateSelectedQuickBuyButtons();
      }
      
      private function updateRocketCategoryButtons() : void
      {
         this.togglePoolButton(this.lastClickedButtonID,true,SuperActionButton.ACTIVATION_ROCKET);
      }
      
      public function updatePoolLaserButtons() : void
      {
         this.togglePoolButton(SuperActionButton.SELECTION_LASER_1,false);
         this.togglePoolButton(SuperActionButton.SELECTION_LASER_2,false);
         this.togglePoolButton(SuperActionButton.SELECTION_LASER_3,false);
         this.togglePoolButton(SuperActionButton.SELECTION_LASER_4,false);
         this.togglePoolButton(SuperActionButton.SELECTION_LASER_5,false);
         this.togglePoolButton(SuperActionButton.SELECTION_LASER_6,false);
         switch(Settings.selectedLaser)
         {
            case 1:
               this.togglePoolButton(SuperActionButton.SELECTION_LASER_1,true);
               break;
            case 2:
               this.togglePoolButton(SuperActionButton.SELECTION_LASER_2,true);
               break;
            case 3:
               this.togglePoolButton(SuperActionButton.SELECTION_LASER_3,true);
               break;
            case 4:
               this.togglePoolButton(SuperActionButton.SELECTION_LASER_4,true);
               break;
            case 5:
               this.togglePoolButton(SuperActionButton.SELECTION_LASER_5,true);
               break;
            case 6:
               this.togglePoolButton(SuperActionButton.SELECTION_LASER_6,true);
         }
      }
      
      public function updateQuickstartLaserButtons() : void
      {
         this.switchOffQuickstartLaserButtons();
         var _loc1_:int = Settings.selectedLaser;
         switch(_loc1_)
         {
            case 1:
               this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_1,true);
               break;
            case 2:
               this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_2,true);
               break;
            case 3:
               this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_3,true);
               break;
            case 4:
               this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_4,true);
               break;
            case 5:
               this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_5,true);
               break;
            case 6:
               this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_6,true);
         }
      }
      
      private function updateQuickstartRocketButtons() : void
      {
         this.switchOffQuickstartRocketButtons();
         var _loc1_:int = Settings.selectedRocket;
         if(this.rocketIDToButtonID[_loc1_] != undefined)
         {
            this.toggleQuickstartButton(this.rocketIDToButtonID[_loc1_],true);
         }
      }
      
      public function switchOffQuickstartLaserButtons() : void
      {
         this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_1,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_2,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_3,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_4,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_5,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_LASER_6,false);
      }
      
      public function switchOffQuickstartRocketButtons() : void
      {
         this.toggleQuickstartButton(SuperActionButton.SELECTION_ROCKET_R_310,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_ROCKET_PLT_2026,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_ROCKET_PLT_2021,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_ROCKET_PLT_3030,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_ROCKET_PLD_8,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_ROCKET_DCR_250,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_ROCKET_WIZ,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER,false);
      }
      
      public function switchOffQuickstartExplosiveButtons() : void
      {
         this.toggleQuickstartButton(SuperActionButton.SELECTION_MINE,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_MINE_EMP,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_MINE_SAB,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_MINE_DDM,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_SMARTBOMB,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_INSTASHIELD,false);
         this.toggleQuickstartButton(SuperActionButton.SELECTION_EMP,false);
      }
      
      public function updatePoolExplosiveButtons() : void
      {
         var _loc1_:int = 2;
         this.togglePoolButton(SuperActionButton.SELECTION_MINE,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_MINE_EMP,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_MINE_SAB,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_MINE_DDM,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_SMARTBOMB,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_INSTASHIELD,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_EMP,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_FIREWORK_1,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_FIREWORK_2,false,_loc1_);
         this.togglePoolButton(SuperActionButton.SELECTION_FIREWORK_3,false,_loc1_);
         this.togglePoolButton(SuperActionButton.FIREWORK_IGNITE,false,_loc1_);
         var _loc2_:int = Settings.selectedExplosive;
         if(_loc2_ == 0)
         {
            _loc2_ = 1;
         }
         switch(_loc2_)
         {
            case 1:
               this.togglePoolButton(SuperActionButton.SELECTION_MINE,true,_loc1_);
               break;
            case 2:
               this.togglePoolButton(SuperActionButton.SELECTION_SMARTBOMB,true,_loc1_);
               break;
            case 3:
               this.togglePoolButton(SuperActionButton.SELECTION_INSTASHIELD,true,_loc1_);
               break;
            case 4:
               this.togglePoolButton(SuperActionButton.SELECTION_EMP,true,_loc1_);
               break;
            case 5:
               this.togglePoolButton(SuperActionButton.SELECTION_FIREWORK_1,true,_loc1_);
               break;
            case 6:
               this.togglePoolButton(SuperActionButton.SELECTION_FIREWORK_2,true,_loc1_);
               break;
            case 7:
               this.togglePoolButton(SuperActionButton.SELECTION_FIREWORK_3,true,_loc1_);
               break;
            case 8:
               this.togglePoolButton(SuperActionButton.FIREWORK_IGNITE,true,_loc1_);
               break;
            case 9:
               this.togglePoolButton(SuperActionButton.SELECTION_MINE_EMP,true,_loc1_);
               break;
            case 10:
               this.togglePoolButton(SuperActionButton.SELECTION_MINE_SAB,true,_loc1_);
               break;
            case 11:
               this.togglePoolButton(SuperActionButton.SELECTION_MINE_DDM,true,_loc1_);
         }
      }
      
      public function updateSelectedQuickBuyButtons() : void
      {
         var _loc2_:AmmoPrice = null;
         var _loc1_:int = 4;
         this.togglePoolButton(SuperActionButton.BUY_LASER_1,false,_loc1_);
         this.togglePoolButton(SuperActionButton.BUY_LASER_2,false,_loc1_);
         this.togglePoolButton(SuperActionButton.BUY_LASER_3,false,_loc1_);
         this.togglePoolButton(SuperActionButton.BUY_LASER_5,false,_loc1_);
         this.togglePoolButton(SuperActionButton.BUY_ROCKET_R_310,false,_loc1_);
         this.togglePoolButton(SuperActionButton.BUY_ROCKET_PLT_2026,false,_loc1_);
         this.togglePoolButton(SuperActionButton.BUY_ROCKET_PLT_2021,false,_loc1_);
         this.togglePoolButton(SuperActionButton.BUY_ROCKET_PLT_3030,false,_loc1_);
         switch(Settings.selectedQuickBuyIcon)
         {
            case 1:
               this.togglePoolButton(SuperActionButton.BUY_LASER_1,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,1);
               break;
            case 2:
               this.togglePoolButton(SuperActionButton.BUY_LASER_2,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,2);
               break;
            case 3:
               this.togglePoolButton(SuperActionButton.BUY_LASER_3,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,3);
               break;
            case 5:
               this.togglePoolButton(SuperActionButton.BUY_LASER_5,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,5);
               break;
            case 6:
               this.togglePoolButton(SuperActionButton.BUY_ROCKET_R_310,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.R310);
               break;
            case 7:
               this.togglePoolButton(SuperActionButton.BUY_ROCKET_PLT_2026,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.PLT_2026);
               break;
            case 8:
               this.togglePoolButton(SuperActionButton.BUY_ROCKET_PLT_2021,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.PLT_2021);
               break;
            case 9:
               this.togglePoolButton(SuperActionButton.BUY_ROCKET_PLT_3030,true,_loc1_);
               _loc2_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.PLT_3030);
         }
         var _loc3_:ActionButton = this.getActionButtonInPoolByID(SuperActionButton.ACTIVATION_BUY);
         if(_loc3_ != null)
         {
            if(_loc2_.currency == AmmoPrice.CURRENCY_URIDIUM)
            {
               _loc3_.setIcon(1);
            }
            else
            {
               _loc3_.setIcon(2);
            }
            this.setButtonLabel(SuperActionButton.ACTIVATION_BUY,_loc2_.summedPrice);
         }
      }
      
      public function getSlotWidth() : int
      {
         return this.slotWidth;
      }
      
      public function getGap() : int
      {
         return this.gap;
      }
      
      public function updateAmmoPrices() : void
      {
         var _loc1_:AmmoPrice = null;
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,1);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_LASER_1,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,2);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_LASER_2,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,3);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_LASER_3,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,4);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_LASER_4,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,5);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_LASER_5,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.R310);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_ROCKET_R_310,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.PLT_2026);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_ROCKET_PLT_2026,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.PLT_2021);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_ROCKET_PLT_2021,_loc1_.amount);
         }
         _loc1_ = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,RocketPattern.PLT_3030);
         if(_loc1_ != null)
         {
            this.setButtonLabel(SuperActionButton.BUY_ROCKET_PLT_3030,_loc1_.amount);
         }
      }
      
      public function checkLaserToggleButton(param1:MapObject) : void
      {
         if(this.guiManager.getMain().screenManager.map.getCombatManager().isShipAttackedByHero(param1.getUserId()))
         {
            this.togglePoolButton(SuperActionButton.ACTIVATION_LASER,false);
         }
      }
      
      private function isHeroAttacking() : Boolean
      {
         var _loc2_:Ship = null;
         var _loc3_:LaserAttackJob = null;
         var _loc1_:Map = this.guiManager.getMain().screenManager.map;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getShipManager().getHero();
            _loc3_ = _loc1_.getCombatManager().isShipAttacking(_loc2_.getUserId());
            if(_loc3_ != null)
            {
               return true;
            }
         }
         return false;
      }
      
      private function laserSelected(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:MapObject = null;
         if(Hero.laserBatteryAmounts[param1 - 1] > 0)
         {
            _loc3_ = Settings.lastSelectedLaser;
            this.guiManager.getMain().screenManager.map.getEventManager().selectLaser(param1);
            _loc4_ = this.guiManager.getMain().screenManager.map.getShipManager().getSelectedShip();
            if(param2 == ActionButton.ENV_QUICKSTART && _loc4_ != null)
            {
               if(_loc3_ == param1)
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().toggleLaserAttack(param2);
               }
               else if(!this.isHeroAttacking())
               {
                  this.guiManager.getMain().screenManager.map.getEventManager().toggleLaserAttack(param2);
               }
            }
         }
         this.updateQuickstartLaserButtons();
         this.updatePoolLaserButtons();
      }
      
      private function explosiveSelected(param1:int, param2:int) : void
      {
         Settings.selectedExplosive = param1;
         if(param2 == ActionButton.ENV_QUICKSTART)
         {
            this.guiManager.getMain().screenManager.map.getEventManager().activateExplosive();
         }
         this.updatePoolExplosiveButtons();
      }
      
      public function autoAmmunitionChange(param1:String, param2:int) : void
      {
         switch(param1)
         {
            case "L":
               this.guiManager.writeToLog(BPLocale.getText("chgbat").replace(/%!/,InGameCatalog.instance.battery_types[param2]));
               this.laserSelected(param2,ActionButton.ENV_POOL);
               break;
            case "R":
               this.guiManager.writeToLog(BPLocale.getText("chgrok").replace(/%!/,InGameCatalog.instance.rocketNames[param2]));
               this.updateRocketTypeSelection(param2,ActionButton.ENV_POOL);
         }
      }
      
      public function getSlotHeight() : int
      {
         return this.slotHeight;
      }
      
      public function getActionSlotCount() : int
      {
         return this.actionSlotCount;
      }
      
      public function getMainMenu() : MainMenu
      {
         return this.mainMenu;
      }
      
      public function getQuickMenu() : QuickMenu
      {
         return this.quickMenu;
      }
      
      public function flashButtonIcon(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:ActionButton = null;
         var _loc4_:int = 0;
         while(_loc4_ < this.actionButtons.length)
         {
            _loc5_ = this.actionButtons[_loc4_];
            if(_loc5_.actionID == param1)
            {
               _loc5_.flashIcon(param2);
               if(param3)
               {
                  _loc5_.startPointer();
               }
            }
            _loc4_++;
         }
      }
      
      public function stopFlashButtonIcon(param1:int) : void
      {
         var _loc3_:ActionButton = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.actionButtons.length)
         {
            _loc3_ = this.actionButtons[_loc2_];
            if(_loc3_.actionID == param1)
            {
               _loc3_.stopFlashIcon();
            }
            _loc2_++;
         }
      }
   }
}

