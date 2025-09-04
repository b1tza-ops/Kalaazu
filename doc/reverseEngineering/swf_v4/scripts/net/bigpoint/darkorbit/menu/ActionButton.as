package net.bigpoint.darkorbit.menu
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.ui.tooltip.ToolTipHook;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import mx.utils.StringUtil;
   import net.bigpoint.AmmoPrice;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.catalog.SpecialAmmunition;
   import net.bigpoint.darkorbit.combat.RocketPattern;
   import net.bigpoint.darkorbit.gui.ActionEvent;
   import net.bigpoint.darkorbit.gui.BitmapFont;
   import net.bigpoint.darkorbit.gui.ButtonSlot;
   import net.bigpoint.darkorbit.gui.CPUItem;
   import net.bigpoint.darkorbit.gui.TechCooldown;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.models.skills.SkillDesignItem;
   import net.bigpoint.darkorbit.net.models.skills.SkillDesignNames;
   import net.bigpoint.darkorbit.net.models.skills.SkillDesignShipNames;
   import net.bigpoint.darkorbit.net.models.techs.TechItem;
   import net.bigpoint.darkorbit.net.models.techs.TechNames;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ActionButton extends SuperActionButton
   {
      
      public static var ENV_UNDEFINED:int = 0;
      
      public static var ENV_POOL:int = 1;
      
      public static var ENV_QUICKSTART:int = 2;
      
      public static var ENV_KEYBOARD:int = 3;
      
      public static const COOLDOWN_TYPE_TECH:String = "tech";
      
      public static const COOLDOWN_TYPE_SKILL:String = "skill";
      
      private var menuID:int;
      
      private var menuManager:MenuManager;
      
      private var dragging:Boolean;
      
      private var resKey:String;
      
      private var toolTipHook:ToolTipHook;
      
      private var cooldown:MovieClip;
      
      private var iconContainer:MovieClip;
      
      private var pattern:ActionButtonPattern;
      
      private var languageKey:String;
      
      public var buttonDecorator:IActionButtonDecorator;
      
      public var section:String;
      
      public var canActivate:Boolean;
      
      private var isCpuButton:Boolean;
      
      private var isRLButton:Boolean;
      
      public var isRunningCooldown:Boolean;
      
      public var isTechButton:Boolean = false;
      
      public var cooldownButtonType:String = "none";
      
      public var techDecorator:TechButtonDecorator;
      
      private var techTooltipText:String;
      
      private var isTechTimerRunning:Boolean;
      
      private var techTimerSecondsLeft:int;
      
      private var techTypeForThisButton:int;
      
      private var correspondingTechItem:IAbilityItem;
      
      private var techActiveClip:MovieClip;
      
      private var techCooldown:TechCooldown;
      
      public function ActionButton(param1:MenuManager, param2:ActionButtonPattern)
      {
         super();
         this.guiManager = param1.getMainMenu().getMenuManager().getGuiManager();
         this.pattern = param2;
         this.menuManager = param1;
         actionID = param2.actionID;
         this.menuID = param2.getMenuID();
         this.resKey = param2.getResKey();
         hasCounter = param2.hasCounter();
         this.languageKey = param2.getLanguageKey();
         this.section = param2.section;
         this.canActivate = param2.canActivate;
         this.isCpuButton = this.setCpuButtonBehavior();
         this.isRLButton = this.setRocketLauncherButtonBehavior();
      }
      
      private function setRocketLauncherButtonBehavior() : Boolean
      {
         if(actionID == SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01 || actionID == SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100 || actionID == SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10 || actionID == SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER)
         {
            return true;
         }
         return false;
      }
      
      private function setCpuButtonBehavior() : Boolean
      {
         if(actionID == SuperActionButton.ACTIVATION_CPU_AIM || actionID == SuperActionButton.ACTIVATION_CPU_AMMOBUY || actionID == SuperActionButton.ACTIVATION_CPU_AROL || actionID == SuperActionButton.ACTIVATION_CPU_CLOAK || actionID == SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR || actionID == SuperActionButton.ACTIVATION_CPU_HM7 || actionID == SuperActionButton.ACTIVATION_CPU_JUMP || actionID == SuperActionButton.ACTIVATION_CPU_RLLB || actionID == SuperActionButton.ACTIVATION_CPU_ROBOT || actionID == SuperActionButton.ACTIVATION_CPU_ROCKETBUY || actionID == SuperActionButton.SELECT_CPU_JUMP_TARGET)
         {
            return true;
         }
         return false;
      }
      
      public function init() : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:TechItem = null;
         var _loc8_:MovieClip = null;
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         this.cooldown = _loc1_.getEmbededMovieClip("cooldown");
         this.cooldown.cacheAsBitmap = true;
         actionNormal = _loc1_.getEmbededBitmap(this.pattern.getStdIcon());
         actionHover = _loc1_.getEmbededBitmap(this.pattern.getHoverIcon());
         actionSelected = _loc1_.getEmbededBitmap(this.pattern.getSelectedIcon());
         actionSelected.x = -1;
         actionSelected.y = -2;
         actionDisabled = _loc1_.getEmbededBitmap("comb00_deactivated.png");
         actionHover.visible = false;
         actionSelected.visible = false;
         actionDisabled.visible = false;
         actionDisabled.alpha = 0.5;
         this.cooldown.visible = false;
         this.cooldown.alpha = 0.4;
         this.techActiveClip = _loc1_.getEmbededMovieClip("activeFlashing");
         buttonContainer = new MovieClip();
         this.iconContainer = new MovieClip();
         this.iconContainer.cacheAsBitmap = true;
         buttonContainer.addChild(actionNormal);
         buttonContainer.addChild(actionHover);
         buttonContainer.addChild(actionSelected);
         buttonContainer.addChild(this.iconContainer);
         if(guiManager.techModel != null)
         {
            if(this.menuManager.buttonIDToTechID[actionID] != null)
            {
               this.isTechButton = true;
               this.cooldownButtonType = COOLDOWN_TYPE_TECH;
               this.cooldown.alpha = 0.8;
               actionDisabled.alpha = 0.8;
            }
            else if(this.menuManager.buttonIDToSkillDesignID[actionID] != null)
            {
               this.cooldownButtonType = COOLDOWN_TYPE_SKILL;
               this.cooldown.alpha = 0.8;
            }
         }
         if(hasCounter)
         {
            bitmapFont = new BitmapFont(this);
            bitmapFont.y = 9;
            buttonContainer.addChild(bitmapFont);
            if(this.pattern.isAmmobar())
            {
               ammobar = _loc1_.getEmbededMovieClip("ammoBar");
               ammobar.mouseEnabled = false;
               ammobar.x = 3;
               ammobar.y = 9;
               buttonContainer.addChild(ammobar);
               bitmapFont.visible = false;
            }
         }
         buttonContainer.addChild(actionDisabled);
         buttonContainer.addChild(this.cooldown);
         buttonContainer.addEventListener(MouseEvent.CLICK,this.handleMouseClick);
         buttonContainer.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         buttonContainer.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         buttonContainer.buttonMode = true;
         buttonContainer.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         var _loc2_:String = BPLocale.getText(this.languageKey);
         switch(actionID)
         {
            case SuperActionButton.SELECTION_LASER_1:
            case SuperActionButton.BUY_LASER_1:
               _loc2_ += InGameCatalog.instance.battery_types[1];
               break;
            case SuperActionButton.SELECTION_LASER_2:
            case SuperActionButton.BUY_LASER_2:
               _loc2_ += InGameCatalog.instance.battery_types[2];
               break;
            case SuperActionButton.SELECTION_LASER_3:
            case SuperActionButton.BUY_LASER_3:
               _loc2_ += InGameCatalog.instance.battery_types[3];
               break;
            case SuperActionButton.SELECTION_LASER_4:
               _loc2_ += InGameCatalog.instance.battery_types[4];
               break;
            case SuperActionButton.SELECTION_LASER_5:
            case SuperActionButton.BUY_LASER_5:
               _loc2_ += InGameCatalog.instance.battery_types[5];
               break;
            case SuperActionButton.SELECTION_LASER_6:
               _loc2_ += InGameCatalog.instance.battery_types[6];
               break;
            case SuperActionButton.SELECTION_ROCKET_R_310:
            case SuperActionButton.BUY_ROCKET_R_310:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.R310];
               break;
            case SuperActionButton.SELECTION_ROCKET_PLT_2026:
            case SuperActionButton.BUY_ROCKET_PLT_2026:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.PLT_2026];
               break;
            case SuperActionButton.SELECTION_ROCKET_PLT_2021:
            case SuperActionButton.BUY_ROCKET_PLT_2021:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.PLT_2021];
               break;
            case SuperActionButton.SELECTION_ROCKET_PLT_3030:
            case SuperActionButton.BUY_ROCKET_PLT_3030:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.PLT_3030];
               break;
            case SuperActionButton.SELECTION_ROCKET_PLD_8:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.PLD_8];
               break;
            case SuperActionButton.SELECTION_ROCKET_DCR_250:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.DCR_250];
               break;
            case SuperActionButton.SELECTION_ROCKET_WIZ:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.WIZ];
               break;
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.HSTRM01];
               break;
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.UBR100];
               break;
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10:
               _loc2_ += InGameCatalog.instance.rocketNames[RocketPattern.ECO10];
               break;
            case SuperActionButton.SELECTION_MINE:
               _loc2_ += InGameCatalog.instance.explosive_types[1];
               break;
            case SuperActionButton.SELECTION_SMARTBOMB:
               _loc2_ += InGameCatalog.instance.explosive_types[2];
               break;
            case SuperActionButton.SELECTION_INSTASHIELD:
               _loc2_ += InGameCatalog.instance.explosive_types[3];
               break;
            case SuperActionButton.SELECTION_EMP:
               _loc2_ += InGameCatalog.instance.explosive_types[4];
               break;
            case SuperActionButton.SELECTION_FIREWORK_1:
               _loc2_ += InGameCatalog.instance.explosive_types[5];
               break;
            case SuperActionButton.SELECTION_FIREWORK_2:
               _loc2_ += InGameCatalog.instance.explosive_types[6];
               break;
            case SuperActionButton.SELECTION_FIREWORK_3:
               _loc2_ += InGameCatalog.instance.explosive_types[7];
               break;
            case SuperActionButton.SELECTION_MINE_EMP:
               _loc2_ += InGameCatalog.instance.explosive_types[8];
               break;
            case SuperActionButton.SELECTION_MINE_SAB:
               _loc2_ += InGameCatalog.instance.explosive_types[9];
               break;
            case SuperActionButton.SELECTION_MINE_DDM:
               _loc2_ += InGameCatalog.instance.explosive_types[10];
               break;
            case SuperActionButton.ACTIVATION_ENERGY_LEECH:
               _loc2_ += BPLocale.getText("tech_" + TechNames.getNameByType(1) + "_name");
               break;
            case SuperActionButton.ACTIVATION_CHAIN_BOLT:
               _loc2_ += BPLocale.getText("tech_" + TechNames.getNameByType(2) + "_name");
               break;
            case SuperActionButton.ACTIVATION_ROCKET_PRECISION:
               _loc2_ += BPLocale.getText("tech_" + TechNames.getNameByType(3) + "_name");
               break;
            case SuperActionButton.ACTIVATION_SHIELD_BACKUP:
               _loc2_ += BPLocale.getText("tech_" + TechNames.getNameByType(4) + "_name");
               break;
            case SuperActionButton.ACTIVATION_SPEED_LEECH:
               _loc2_ += BPLocale.getText("tech_" + TechNames.getNameByType(5) + "_name");
               break;
            case SuperActionButton.ACTIVATION_BATTLE_REP_BOT:
               _loc2_ += BPLocale.getText("tech_" + TechNames.getNameByType(6) + "_name");
               break;
            case SuperActionButton.ACTIVATION_SKILL_SOLACE:
               _loc2_ += BPLocale.getText("ttip_" + SkillDesignNames.getNameByType(SkillDesignNames.SHIP_SKILL_SOLACE) + "_skill");
               break;
            case SuperActionButton.ACTIVATION_SKILL_DIMINISHER:
               _loc2_ += BPLocale.getText("ttip_" + SkillDesignNames.getNameByType(SkillDesignNames.SHIP_SKILL_DIMINISHER) + "_skill");
               break;
            case SuperActionButton.ACTIVATION_SKILL_SPECTRUM:
               _loc2_ += BPLocale.getText("ttip_" + SkillDesignNames.getNameByType(SkillDesignNames.SHIP_SKILL_SPECTRUM) + "_skill");
               break;
            case SuperActionButton.ACTIVATION_SKILL_SENTINEL:
               _loc2_ += BPLocale.getText("ttip_" + SkillDesignNames.getNameByType(SkillDesignNames.SHIP_SKILL_SENTINEL) + "_skill");
               break;
            case SuperActionButton.ACTIVATION_SKILL_VENOM:
               _loc2_ += BPLocale.getText("ttip_" + SkillDesignNames.getNameByType(SkillDesignNames.SHIP_SKILL_VENOM) + "_skill");
               break;
            case SuperActionButton.ACTIVATION_SKILL_LIGHNTING:
               _loc2_ += BPLocale.getText("ttip_" + SkillDesignNames.getNameByType(SkillDesignNames.SHIP_SKILL_LIGHTNING) + "_skill");
         }
         _loc2_ = this.replaceMissingType(_loc2_);
         if(this.languageKey != null)
         {
            this.toolTipHook = TooltipControl.getInstance().addToolTip(buttonContainer,_loc2_);
         }
         if(this.resKey != null && this.resKey != "")
         {
            _loc4_ = this.resKey.split(",");
            for each(_loc5_ in _loc4_)
            {
               _loc3_ = _loc1_.getEmbededBitmap(StringUtil.trim(_loc5_));
               _loc3_.visible = true;
               this.iconContainer.addChild(_loc3_);
            }
            if(this.isTechButton)
            {
               _loc6_ = int(this.menuManager.buttonIDToTechID[actionID]);
               _loc7_ = this.menuManager.getGuiManager().techModel.techs[_loc6_];
               this.techDecorator = new TechButtonDecorator(this.iconContainer,_loc7_.amount);
            }
         }
         else if(actionID == SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER)
         {
            _loc8_ = _loc1_.getEmbededMovieClip("rocketlauncher");
            this.buttonDecorator = new RocketLauncherLoadDecorator(_loc8_);
            this.iconContainer.addChild(_loc8_);
            this.updateTooltip();
         }
         else if(actionID == SuperActionButton.ACTIVATION_CPU_ROCKETBUY)
         {
            _loc8_ = _loc1_.getEmbededMovieClip("rocketbuy");
            this.buttonDecorator = new RocketBuyCPUDecorator(_loc8_);
            this.iconContainer.addChild(_loc8_);
            this.updateTooltip();
         }
         else
         {
            _loc3_ = new Bitmap();
            _loc3_.visible = false;
            this.iconContainer.addChild(_loc3_);
         }
         this.setIcon(1);
         this.selectedIcon = _loc1_.getEmbededBitmap("comb02_flash.png");
         selectedIcon.visible = false;
         buttonContainer.addChild(selectedIcon);
      }
      
      public function changeRemainingTechAmount(param1:int) : void
      {
         this.techDecorator.updateDigits(param1);
      }
      
      private function replaceMissingType(param1:String) : String
      {
         return param1.replace(/%TYPE%/,BPLocale.getText("ttip_not_available"));
      }
      
      public function addMouseUpListener() : void
      {
         this.menuManager.getGuiManager().getMain().stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      public function removeMouseUpListener() : void
      {
         this.menuManager.getGuiManager().getMain().stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      public function updateAmmunitionDisplay() : void
      {
         var _loc1_:Boolean = false;
         if(hasCounter)
         {
            _loc1_ = Settings.showAmmunitionNumeric;
            if(_loc1_)
            {
               if(ammobar != null)
               {
                  ammobar.visible = false;
               }
               bitmapFont.visible = true;
            }
            else
            {
               if(ammobar != null)
               {
                  ammobar.visible = true;
               }
               bitmapFont.visible = false;
            }
         }
      }
      
      public function hasAmmobar() : Boolean
      {
         if(ammobar != null)
         {
            return true;
         }
         return false;
      }
      
      public function updateTooltip() : void
      {
         switch(actionID)
         {
            case SuperActionButton.SELECTION_LASER_1:
               this.updateLaserTooltip(1);
               break;
            case SuperActionButton.SELECTION_LASER_2:
               this.updateLaserTooltip(2);
               break;
            case SuperActionButton.SELECTION_LASER_3:
               this.updateLaserTooltip(3);
               break;
            case SuperActionButton.SELECTION_LASER_4:
               this.updateLaserTooltip(4);
               break;
            case SuperActionButton.SELECTION_LASER_5:
               this.updateLaserTooltip(5);
               break;
            case SuperActionButton.SELECTION_LASER_6:
               this.updateLaserTooltip(6);
               break;
            case SuperActionButton.SELECTION_ROCKET_R_310:
            case SuperActionButton.SELECTION_ROCKET_PLT_2026:
            case SuperActionButton.SELECTION_ROCKET_PLT_2021:
            case SuperActionButton.SELECTION_ROCKET_PLT_3030:
            case SuperActionButton.SELECTION_ROCKET_PLD_8:
            case SuperActionButton.SELECTION_ROCKET_DCR_250:
            case SuperActionButton.SELECTION_ROCKET_WIZ:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10:
               this.updateRocketTooltip(this.menuManager.buttonIDToRocketID[actionID]);
               break;
            case SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER:
               this.updateRocketLauncherTooltip();
               break;
            case SuperActionButton.SELECTION_MINE:
               this.updateExplosiveAmount(SuperActionButton.SELECTION_MINE);
               break;
            case SuperActionButton.SELECTION_MINE_EMP:
            case SuperActionButton.SELECTION_MINE_SAB:
            case SuperActionButton.SELECTION_MINE_DDM:
               this.updateExplosiveAmount(actionID);
               break;
            case SuperActionButton.SELECTION_SMARTBOMB:
               this.updateExplosiveAmount(SuperActionButton.SELECTION_SMARTBOMB);
               break;
            case SuperActionButton.SELECTION_INSTASHIELD:
               this.updateExplosiveAmount(SuperActionButton.SELECTION_INSTASHIELD);
               break;
            case SuperActionButton.SELECTION_EMP:
               this.updateExplosiveAmount(SuperActionButton.SELECTION_EMP);
               break;
            case SuperActionButton.SELECTION_FIREWORK_1:
               this.updateExplosiveAmount(SuperActionButton.SELECTION_FIREWORK_1);
               break;
            case SuperActionButton.SELECTION_FIREWORK_2:
               this.updateExplosiveAmount(SuperActionButton.SELECTION_FIREWORK_2);
               break;
            case SuperActionButton.SELECTION_FIREWORK_3:
               this.updateExplosiveAmount(SuperActionButton.SELECTION_FIREWORK_3);
               break;
            case SuperActionButton.BUY_LASER_1:
               this.updateBuyLaserTooltip(1);
               break;
            case SuperActionButton.BUY_LASER_2:
               this.updateBuyLaserTooltip(2);
               break;
            case SuperActionButton.BUY_LASER_3:
               this.updateBuyLaserTooltip(3);
               break;
            case SuperActionButton.BUY_LASER_4:
               this.updateBuyLaserTooltip(4);
               break;
            case SuperActionButton.BUY_LASER_5:
               this.updateBuyLaserTooltip(5);
               break;
            case SuperActionButton.BUY_ROCKET_R_310:
               this.updateBuyRocketTooltip(RocketPattern.R310);
               break;
            case SuperActionButton.BUY_ROCKET_PLT_2026:
               this.updateBuyRocketTooltip(2);
               this.updateBuyRocketTooltip(RocketPattern.PLT_2026);
               break;
            case SuperActionButton.BUY_ROCKET_PLT_2021:
               this.updateBuyRocketTooltip(3);
               this.updateBuyRocketTooltip(RocketPattern.PLT_2021);
               break;
            case SuperActionButton.BUY_ROCKET_PLT_3030:
               this.updateBuyRocketTooltip(RocketPattern.PLT_3030);
               break;
            case SuperActionButton.ACTIVATION_ENERGY_LEECH:
               this.techTypeForThisButton = TechItem.TYPE_ENERGY_LEECH_ARRAY;
               break;
            case SuperActionButton.ACTIVATION_CHAIN_BOLT:
               this.techTypeForThisButton = TechItem.TYPE_ENERGY_CHAIN_IMPULSE;
               break;
            case SuperActionButton.ACTIVATION_ROCKET_PRECISION:
               this.techTypeForThisButton = TechItem.TYPE_ROCKET_PROBABILITY_MAXIMIZER;
               break;
            case SuperActionButton.ACTIVATION_SHIELD_BACKUP:
               this.techTypeForThisButton = TechItem.TYPE_SHIELD_BACKUP;
               break;
            case SuperActionButton.ACTIVATION_SPEED_LEECH:
               this.techTypeForThisButton = TechItem.TYPE_SPEED_LEECH;
               break;
            case SuperActionButton.ACTIVATION_BATTLE_REP_BOT:
               this.techTypeForThisButton = TechItem.TYPE_BATTLE_REPAIR_BOT;
               break;
            case SuperActionButton.ACTIVATION_CPU_ROBOT:
            case SuperActionButton.ACTIVATION_CPU_JUMP:
            case SuperActionButton.ACTIVATION_CPU_AIM:
            case SuperActionButton.ACTIVATION_CPU_CLOAK:
            case SuperActionButton.ACTIVATION_CPU_AROL:
            case SuperActionButton.ACTIVATION_CPU_RLLB:
            case SuperActionButton.ACTIVATION_CPU_HM7:
            case SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR:
            case SuperActionButton.ACTIVATION_CPU_AMMOBUY:
            case SuperActionButton.ACTIVATION_CPU_ROCKETBUY:
            case SuperActionButton.SELECT_CPU_JUMP_TARGET:
               this.updateCPUTooltip(actionID);
         }
      }
      
      private function updateLaserTooltip(param1:int) : void
      {
         var _loc2_:String = BPLocale.getText(this.languageKey).replace(/%TYPE%/,InGameCatalog.instance.battery_types[param1]);
         var _loc3_:int = int(Hero.laserBatteryAmounts[param1 - 1]);
         _loc2_ += "\n" + BPLocale.getText("ttip_battery_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(_loc2_);
         }
      }
      
      private function updateRocketTooltip(param1:int) : void
      {
         var _loc2_:String = BPLocale.getText(this.languageKey).replace(/%TYPE%/,InGameCatalog.instance.rocketNames[param1]);
         var _loc3_:int = int(Hero.rocketAmounts[param1]);
         _loc2_ += "\n" + BPLocale.getText("ttip_rocket_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(_loc2_);
         }
      }
      
      private function updateRocketLauncherTooltip() : void
      {
         var _loc1_:String = null;
         if(Settings.rocketLauncherType != 0)
         {
            _loc1_ = BPLocale.getText(this.languageKey).replace(/%TYPE%/,InGameCatalog.instance.rocketLauncherNames[Settings.rocketLauncherType]);
            _loc1_ += "\n" + BPLocale.getText("ttip_rocketlauncher_loadcount").replace(/%COUNT%/,Settings.rocketLauncherRocketsLoaded).replace(/%TYPE%/,InGameCatalog.instance.rocketNames[Settings.selectedLauncherRocket]);
         }
         else
         {
            _loc1_ = BPLocale.getText(this.languageKey).replace(/%TYPE%/,BPLocale.getText("ttip_rocketlauncher_unloaded"));
         }
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(_loc1_);
         }
      }
      
      private function updateExplosiveAmount(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc2_:String = BPLocale.getText(this.languageKey);
         switch(param1)
         {
            case SuperActionButton.SELECTION_MINE:
               _loc3_ = int(Hero.explosiveAmounts[SpecialAmmunition.MINE]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[SpecialAmmunition.MINE]);
               _loc2_ += "\n" + BPLocale.getText("ttip_mine_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               break;
            case SuperActionButton.SELECTION_MINE_EMP:
               _loc3_ = int(Hero.explosiveAmounts[SpecialAmmunition.MINE_EMP]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[8]);
               _loc2_ += "\n" + BPLocale.getText("ttip_mine_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               break;
            case SuperActionButton.SELECTION_MINE_SAB:
               _loc3_ = int(Hero.explosiveAmounts[SpecialAmmunition.MINE_SAB]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[9]);
               _loc2_ += "\n" + BPLocale.getText("ttip_mine_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               break;
            case SuperActionButton.SELECTION_MINE_DDM:
               _loc3_ = int(Hero.explosiveAmounts[SpecialAmmunition.MINE_DDM]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[10]);
               _loc2_ += "\n" + BPLocale.getText("ttip_mine_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               break;
            case SuperActionButton.SELECTION_SMARTBOMB:
               _loc3_ = int(Hero.explosiveAmounts[SpecialAmmunition.SMARTBOMB]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[SpecialAmmunition.SMARTBOMB]);
               _loc2_ += "\n" + BPLocale.getText("ttip_smartbomb_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               if(Hero.cpuItems[CPUItem.TYPE_SMARTBOMB] == null)
               {
                  _loc2_ += " " + BPLocale.getText("ttip_cpu_not_equipped");
               }
               break;
            case SuperActionButton.SELECTION_INSTASHIELD:
               _loc3_ = int(Hero.explosiveAmounts[SpecialAmmunition.INSTASHIELD]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[SpecialAmmunition.INSTASHIELD]);
               _loc2_ += "\n" + BPLocale.getText("ttip_instashield_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               if(Hero.cpuItems[CPUItem.TYPE_INSTASHIELD] == null)
               {
                  _loc2_ += " " + BPLocale.getText("ttip_cpu_not_equipped");
               }
               break;
            case SuperActionButton.SELECTION_EMP:
               _loc3_ = int(Hero.explosiveAmounts[SpecialAmmunition.EMP]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[SpecialAmmunition.EMP]);
               _loc2_ += "\n" + BPLocale.getText("ttip_emp_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               break;
            case SuperActionButton.SELECTION_FIREWORK_1:
               _loc3_ = int(Hero.fireworksAmounts[0]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[5]);
               _loc2_ += "\n" + BPLocale.getText("ttip_firework_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               break;
            case SuperActionButton.SELECTION_FIREWORK_2:
               _loc3_ = int(Hero.fireworksAmounts[1]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[6]);
               _loc2_ += "\n" + BPLocale.getText("ttip_firework_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
               break;
            case SuperActionButton.SELECTION_FIREWORK_3:
               _loc3_ = int(Hero.fireworksAmounts[2]);
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.explosive_types[7]);
               _loc2_ += "\n" + BPLocale.getText("ttip_firework_count").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_));
         }
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(_loc2_);
         }
      }
      
      public function updateAmmoMaxValue() : void
      {
         switch(actionID)
         {
            case SuperActionButton.SELECTION_LASER_1:
            case SuperActionButton.SELECTION_LASER_2:
            case SuperActionButton.SELECTION_LASER_3:
            case SuperActionButton.SELECTION_LASER_4:
            case SuperActionButton.SELECTION_LASER_5:
            case SuperActionButton.SELECTION_LASER_6:
               maxAmmo = 1000;
               break;
            case SuperActionButton.SELECTION_ROCKET_R_310:
            case SuperActionButton.SELECTION_ROCKET_PLT_2026:
            case SuperActionButton.SELECTION_ROCKET_PLT_2021:
            case SuperActionButton.SELECTION_ROCKET_PLT_3030:
            case SuperActionButton.SELECTION_ROCKET_PLD_8:
            case SuperActionButton.SELECTION_ROCKET_DCR_250:
            case SuperActionButton.SELECTION_ROCKET_WIZ:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_HST01:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_UBR100:
            case SuperActionButton.SELECTION_LAUNCHER_ROCKET_ECO10:
               maxAmmo = 100;
               break;
            case SuperActionButton.SELECTION_MINE:
            case SuperActionButton.SELECTION_MINE_EMP:
            case SuperActionButton.SELECTION_MINE_SAB:
            case SuperActionButton.SELECTION_MINE_DDM:
            case SuperActionButton.SELECTION_SMARTBOMB:
            case SuperActionButton.SELECTION_INSTASHIELD:
            case SuperActionButton.SELECTION_EMP:
            case SuperActionButton.SELECTION_FIREWORK_1:
            case SuperActionButton.SELECTION_FIREWORK_2:
            case SuperActionButton.SELECTION_FIREWORK_3:
               maxAmmo = 100;
         }
      }
      
      private function updateCPUTooltip(param1:int) : void
      {
         var _loc3_:CPUItem = null;
         var _loc2_:* = BPLocale.getText(this.languageKey);
         switch(param1)
         {
            case SuperActionButton.ACTIVATION_CPU_JUMP:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_JUMP];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.jump_cpu_names[_loc3_.level]);
               _loc2_ += "\n" + BPLocale.getText("ttip_cpu_jump_count").replace(/%COUNT%/,_loc3_.amount);
               break;
            case SuperActionButton.SELECT_CPU_JUMP_TARGET:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_ADVANCED_JUMP];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.advancedJumpCPUNames[1]);
               _loc2_ += "\n" + BPLocale.getText("ttip_jump-vouchers_count").replace(/%COUNT%/,Hero.jumpVouchersAmount);
               if(_loc3_.level == 0)
               {
                  _loc2_ += BPLocale.getText("ttip_cpu_not_equipped");
               }
               break;
            case SuperActionButton.ACTIVATION_CPU_AIM:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_AIM];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.aim_cpu_names[_loc3_.level]);
               _loc2_ += "\n" + BPLocale.getText("ttip_cpu_aim_count").replace(/%COUNT%/,_loc3_.amount);
               break;
            case SuperActionButton.ACTIVATION_CPU_CLOAK:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_CLOAK];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.cloak_cpu_names[_loc3_.level]);
               _loc2_ += "\n" + BPLocale.getText("ttip_cpu_cloak_count").replace(/%COUNT%/,_loc3_.amount);
               break;
            case SuperActionButton.ACTIVATION_CPU_AROL:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_AROL];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.arol_cpu_names[_loc3_.level]);
               break;
            case SuperActionButton.ACTIVATION_CPU_RLLB:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_RLLB];
               if(_loc3_ != null)
               {
                  _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.rllbCpuNames[_loc3_.level]);
               }
               else
               {
                  _loc2_ = this.replaceMissingType(_loc2_);
               }
               break;
            case SuperActionButton.ACTIVATION_CPU_ROBOT:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_ROBOT];
               if(_loc3_ != null)
               {
                  _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.robot_names[_loc3_.level]);
               }
               else
               {
                  _loc2_ = this.replaceMissingType(_loc2_);
               }
               break;
            case SuperActionButton.ACTIVATION_CPU_HM7:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_HM7];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.trade_cpu_names[_loc3_.level]);
               if(_loc3_.amount > 0)
               {
                  _loc2_ += "\n" + BPLocale.getText("ttip_cpu_trade_count").replace(/%COUNT%/,_loc3_.amount);
               }
               break;
            case SuperActionButton.ACTIVATION_CPU_DRONE_REPAIR:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_DRONE_REPAIR];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.dronerepair_cpu_names[Math.abs(_loc3_.level)]);
               _loc2_ += "\n";
               if(_loc3_.level > 0)
               {
                  _loc2_ += BPLocale.getText("ttip_cpu_dronerep_count").replace(/%COUNT%/,_loc3_.amount);
               }
               else
               {
                  _loc2_ += BPLocale.getText("ttip_cpu_dronerep_not_equipped");
               }
               break;
            case SuperActionButton.ACTIVATION_CPU_AMMOBUY:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_AMMOBUY];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.battery_types[_loc3_.level]);
               break;
            case SuperActionButton.ACTIVATION_CPU_ROCKETBUY:
               _loc3_ = Hero.cpuItems[CPUItem.TYPE_ROCKETBUY];
               _loc2_ = _loc2_.replace(/%TYPE%/,InGameCatalog.instance.rocketNames[_loc3_.level]);
         }
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(_loc2_);
         }
      }
      
      private function updateBuyLaserTooltip(param1:int) : void
      {
         var _loc2_:String = BPLocale.getText(this.languageKey).replace(/%TYPE%/,InGameCatalog.instance.battery_types[param1]);
         var _loc3_:AmmoPrice = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_LASER,param1);
         _loc2_ += "\n" + BPLocale.getText("ttip_quickBuy_ammount").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_.amount));
         if(_loc3_.currency == AmmoPrice.CURRENCY_URIDIUM)
         {
            _loc2_ += "\n" + BPLocale.getText("ttip_quickBuy_price").replace(/%COUNT%/,BPLocale.getText("pricetag_uridium").replace(/%VALUE%/,BPLocale.round(_loc3_.summedPrice)));
         }
         if(_loc3_.currency == AmmoPrice.CURRENCY_CREDITS)
         {
            _loc2_ += "\n" + BPLocale.getText("ttip_quickBuy_price").replace(/%COUNT%/,BPLocale.getText("pricetag_credits").replace(/%VALUE%/,BPLocale.round(_loc3_.summedPrice)));
         }
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(_loc2_);
         }
      }
      
      private function updateBuyRocketTooltip(param1:int) : void
      {
         var _loc2_:String = BPLocale.getText(this.languageKey).replace(/%TYPE%/,InGameCatalog.instance.rocketNames[param1]);
         var _loc3_:AmmoPrice = PatternManager.getAmmoPrice(AmmoPrice.CATEGORY_ROCKET,param1);
         _loc2_ += "\n" + BPLocale.getText("ttip_quickBuy_ammount").replace(/%COUNT%/,BPLocale.roundInteger(_loc3_.amount));
         if(_loc3_.currency == AmmoPrice.CURRENCY_URIDIUM)
         {
            _loc2_ += "\n" + BPLocale.getText("ttip_quickBuy_price").replace(/%COUNT%/,BPLocale.getText("pricetag_uridium").replace(/%VALUE%/,BPLocale.round(_loc3_.summedPrice)));
         }
         if(_loc3_.currency == AmmoPrice.CURRENCY_CREDITS)
         {
            _loc2_ += "\n" + BPLocale.getText("ttip_quickBuy_price").replace(/%COUNT%/,BPLocale.getText("pricetag_credits").replace(/%VALUE%/,BPLocale.round(_loc3_.summedPrice)));
         }
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(_loc2_);
         }
      }
      
      public function updateTechTooltip(param1:IAbilityItem) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param1 == null)
         {
            return;
         }
         if(param1 is TechItem)
         {
            _loc2_ = "tech_";
            _loc3_ = "_name";
            _loc4_ = _loc2_ + param1.getName() + _loc3_;
         }
         else
         {
            _loc2_ = "ttip_";
            _loc3_ = "_skill";
            _loc4_ = _loc2_ + SkillDesignShipNames.getShipNameBySkillName(param1.getName()) + _loc3_;
         }
         this.techTooltipText = BPLocale.getText(_loc4_);
         switch(param1.getStatus())
         {
            case TechItem.STATE_DEFAULT:
               this.techTooltipText = BPLocale.getText(_loc4_);
               break;
            case TechItem.STATE_ACTIVE:
               this.techTooltipText += "\n%TIME%";
               break;
            case TechItem.STATE_INACTIVE:
               this.techTooltipText += "\n%TIME%";
               break;
            case TechItem.STATE_READY:
               this.techTooltipText = BPLocale.getText(_loc4_);
         }
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(this.techTooltipText);
         }
      }
      
      public function setTechActiveTimer(param1:int, param2:IAbilityItem) : void
      {
         this.correspondingTechItem = param2;
         if(!this.isTechTimerRunning)
         {
            this.isTechTimerRunning = true;
            this.techTimerSecondsLeft = param1;
            this.techTimerTick();
         }
      }
      
      private function techTimerTick() : void
      {
         if(this.techTooltipText == null)
         {
            return;
         }
         if(this.toolTipHook != null)
         {
            this.toolTipHook.updateText(this.techTooltipText.replace(/%TIME%/,TimeFormatter.formatTime(this.techTimerSecondsLeft)));
         }
         --this.techTimerSecondsLeft;
         if(this.correspondingTechItem is TechItem)
         {
            (this.correspondingTechItem as TechItem).secondsLeft = this.techTimerSecondsLeft;
         }
         else if(this.correspondingTechItem is SkillDesignItem)
         {
            (this.correspondingTechItem as SkillDesignItem).secondsLeft = this.techTimerSecondsLeft;
         }
         if(this.techTimerSecondsLeft > 0)
         {
            TweenMax.delayedCall(1,this.techTimerTick);
         }
         else
         {
            this.isTechTimerRunning = false;
            this.techActivePeriodComplete();
         }
      }
      
      private function techActivePeriodComplete() : void
      {
      }
      
      public function toggleTechActiveLayer(param1:Boolean) : void
      {
         if(param1)
         {
            buttonContainer.addChild(this.techActiveClip);
            buttonContainer.buttonMode = false;
         }
         else if(buttonContainer.contains(this.techActiveClip))
         {
            buttonContainer.removeChild(this.techActiveClip);
         }
      }
      
      public function setRocketCooldown(param1:int) : void
      {
         this.cooldown.gotoAndStop(param1);
         this.cooldown.visible = true;
         actionSelected.visible = false;
         lockButton();
      }
      
      public function setCooldown(param1:int, param2:IAbilityItem = null, param3:int = 0, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:TechItem = null;
         var _loc7_:SkillDesignItem = null;
         if(param5 && !this.isRunningCooldown)
         {
            this.isRunningCooldown = true;
            if(param2 is TechItem)
            {
               _loc6_ = param2 as TechItem;
               this.updateTechTooltip(_loc6_);
               this.techCooldown = guiManager.techModel.cooldowns[_loc6_.type];
            }
            else if(param2 is SkillDesignItem)
            {
               _loc7_ = param2 as SkillDesignItem;
               this.updateTechTooltip(_loc6_);
               this.techCooldown = guiManager.skillDesignsModel.cooldowns[_loc7_.type];
            }
            this.cooldown.visible = true;
            lockButton();
            this.updateButtonCooldown();
         }
         else
         {
            this.cooldown.gotoAndStop(param1);
         }
      }
      
      private function updateButtonCooldown() : void
      {
         var _loc1_:int = 0;
         if(this.techCooldown.seconds > 0)
         {
            if(this.toolTipHook != null)
            {
               this.toolTipHook.updateText(this.techTooltipText.replace(/%TIME%/,TimeFormatter.formatTime(this.techCooldown.seconds)));
            }
            _loc1_ = this.returnFrameForSecondsLeft(this.techCooldown.seconds);
            this.cooldown.gotoAndStop(_loc1_);
            TweenMax.delayedCall(1,this.updateButtonCooldown);
         }
         else
         {
            this.cooldownCompleted();
         }
      }
      
      public function cooldownCompleted(param1:int = 0) : void
      {
         this.cooldown.visible = false;
         this.isRunningCooldown = false;
         this.techTooltipText = BPLocale.getText("tech_" + TechNames.getNameByType(this.techTypeForThisButton) + "_name");
         unlockButton();
         guiManager.getMenuManager().updateTechs();
      }
      
      private function returnFrameForSecondsLeft(param1:int) : int
      {
         var _loc2_:int = Math.round(100 / this.techCooldown.startingTime * param1);
         return 100 - _loc2_;
      }
      
      public function setIcon(param1:int) : void
      {
         var _loc2_:Bitmap = null;
         if(actionID == SuperActionButton.SELECTION_LOAD_ROCKET_LAUNCHER || actionID == SuperActionButton.ACTIVATION_CPU_ROCKETBUY || this.isTechButton)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.iconContainer.numChildren)
         {
            _loc2_ = Bitmap(this.iconContainer.getChildAt(_loc3_));
            if(_loc3_ == param1 - 1)
            {
               _loc2_.visible = true;
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc3_++;
         }
      }
      
      public function isCooldownActive() : Boolean
      {
         if(this.cooldown.visible)
         {
            return true;
         }
         return false;
      }
      
      public function getIconIndex() : int
      {
         var _loc2_:Bitmap = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.iconContainer.numChildren)
         {
            _loc2_ = Bitmap(this.iconContainer.getChildAt(_loc1_));
            if(_loc2_.visible)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }
      
      private function handleMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Map = this.menuManager.getGuiManager().getMain().screenManager.map;
         if(_loc2_ != null)
         {
            if(_loc2_.getEventManager().isControlsLocked())
            {
               return;
            }
         }
         if(this.cooldown.visible || buttonContainer.buttonMode == false || !this.menuManager.getMainMenu().guiLocked)
         {
            return;
         }
         var _loc3_:ActionEvent = new ActionEvent(ActionEvent.ACTION);
         _loc3_.setActionID(actionID);
         _loc3_.setEnvironment(this.getEnvironment());
         dispatchEvent(_loc3_);
         AudioManager.playSoundEffect(25);
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         if(this.menuManager.getGuiManager().getMenuManager().getMainMenu().guiLocked)
         {
            return;
         }
         if(this.dragging)
         {
            this.buttonContainer.stopDrag();
            this.dragging = false;
            if(!this.testQuickstartSlotCollision())
            {
               TweenLite.to(this.buttonContainer,1,{
                  "ease":Back.easeIn,
                  "y":this.buttonContainer.y + 150
               });
               TweenLite.to(this.buttonContainer,1,{
                  "delay":0.25,
                  "alpha":0,
                  "onComplete":this.killActionButton
               });
            }
            this.saveQuickstartSettings();
         }
         this.menuManager.updateAllButtonAmounts();
      }
      
      private function saveQuickstartSettings() : void
      {
         var _loc4_:ButtonSlot = null;
         var _loc5_:ActionButton = null;
         var _loc1_:Array = this.menuManager.getQuickMenu().getQuickstartSlots();
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc4_ = _loc1_[_loc3_];
            _loc5_ = _loc4_.getActionButton();
            if(_loc5_ == null)
            {
               _loc2_ = _loc2_ + "-1" + ServerCommands.SETTING_PROPERTY_SEPERATOR;
            }
            else
            {
               _loc2_ += _loc5_.getActionID() + ServerCommands.SETTING_PROPERTY_SEPERATOR;
            }
            _loc3_++;
         }
         if(_loc2_.length > 0)
         {
            this.menuManager.getGuiManager().getMain().getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.SET_QUICKBAR_SLOT,Main.removeCommaAtEnd(_loc2_)]);
         }
      }
      
      public function killActionButton() : void
      {
         this.cleanup();
         if(this.getEnvironment() == ENV_UNDEFINED)
         {
            this.menuManager.removeChild(this.buttonContainer);
         }
         if(this.getEnvironment() == ENV_QUICKSTART)
         {
            this.removeSelfFromQuickstartSlot();
         }
         this.saveQuickstartSettings();
      }
      
      public function cleanup() : void
      {
         this.buttonContainer.removeEventListener(MouseEvent.CLICK,this.handleMouseClick);
         this.buttonContainer.removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.buttonContainer.removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.buttonContainer.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.removeEventListener(ActionEvent.ACTION,this.menuManager.onAction);
         this.removeMouseUpListener();
         if(TweenMax.isTweening(this.cooldown))
         {
            TweenMax.killTweensOf(this.cooldown);
         }
         if(this.toolTipHook != null)
         {
            TooltipControl.getInstance().removeToolTip(buttonContainer);
         }
         stopFlashIcon();
         TweenMax.killTweensOf(selectedIcon);
         removeAllDirectionArrows();
         stopPointer();
      }
      
      private function testQuickstartSlotCollision() : Boolean
      {
         var _loc3_:ButtonSlot = null;
         var _loc1_:Array = this.menuManager.getQuickMenu().getQuickstartSlots();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(this.isInBounds(_loc3_))
            {
               if(this.getEnvironment() == ENV_QUICKSTART)
               {
                  this.removeSelfFromQuickstartSlot();
                  this.removeExistingAction(_loc3_);
                  _loc3_.addActionButton(this);
               }
               else if(this.getEnvironment() == ENV_UNDEFINED)
               {
                  this.removeExistingAction(_loc3_);
                  _loc3_.addActionButton(this);
                  this.removeSelfFromQuickstartSlot();
                  _loc3_.addActionButton(this);
               }
               this.menuManager.updateSelectableButtons();
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      private function removeExistingAction(param1:ButtonSlot) : void
      {
         var _loc2_:ActionButton = param1.getActionButton();
         if(_loc2_ != null)
         {
            this.menuManager.removeActionButton(_loc2_);
            param1.removeActionButton();
         }
      }
      
      private function removeSelfFromQuickstartSlot() : void
      {
         var _loc3_:ButtonSlot = null;
         var _loc1_:Array = this.menuManager.getQuickMenu().getQuickstartSlots();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = _loc1_[_loc2_];
            if(_loc3_.getActionButton() != null)
            {
               if(_loc3_.getActionButton() == this)
               {
                  _loc3_.removeActionButton();
                  if(this.menuManager.getMainMenu().guiLocked)
                  {
                     _loc3_.getMC().visible = false;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      private function isInBounds(param1:ButtonSlot) : Boolean
      {
         var _loc2_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("actionMenu"));
         var _loc3_:Bitmap = _loc2_.getEmbededBitmap(param1.getResKey());
         var _loc4_:Rectangle = _loc3_.getRect(this.menuManager);
         if(this.menuManager.mouseX > int(this.menuManager.getQuickMenu().x + param1.getMC().x) && this.menuManager.mouseX < int(this.menuManager.getQuickMenu().x + param1.getMC().x + _loc4_.width) && this.menuManager.mouseY > int(this.menuManager.getQuickMenu().y + param1.getMC().y) && this.menuManager.mouseY < int(this.menuManager.getQuickMenu().y + param1.getMC().y + _loc4_.height))
         {
            return true;
         }
         return false;
      }
      
      public function getEnvironment() : int
      {
         var _loc2_:ButtonSlot = null;
         var _loc1_:Array = this.menuManager.getQuickMenu().getQuickstartSlots();
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_.length)
         {
            _loc2_ = _loc1_[_loc3_];
            if(_loc2_.getActionButton() == this)
            {
               return ENV_QUICKSTART;
            }
            _loc3_++;
         }
         var _loc4_:Array = this.menuManager.getMainMenu().getPoolSlots();
         _loc3_ = 0;
         while(_loc3_ < _loc4_.length)
         {
            _loc2_ = _loc4_[_loc3_];
            if(_loc2_.getActionButton() == this)
            {
               return ENV_POOL;
            }
            _loc3_++;
         }
         return ENV_UNDEFINED;
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
         if(!this.menuManager.getMainMenu().guiLocked)
         {
            return;
         }
         if(actionSelected.visible || buttonContainer.buttonMode == false)
         {
            return;
         }
         actionHover.alpha = 0;
         actionHover.visible = true;
         TweenLite.to(actionHover,0.5,{"alpha":1});
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
         TweenLite.to(actionHover,0.5,{
            "alpha":0,
            "onComplete":setInvisible,
            "onCompleteParams":[actionHover]
         });
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:ActionButton = null;
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Array = null;
         var _loc6_:ButtonSlot = null;
         var _loc7_:int = 0;
         if(this.menuManager.getMainMenu().guiLocked)
         {
            return;
         }
         if(!this.pattern.isCustomizable)
         {
            return;
         }
         if(this.cooldown.visible)
         {
            return;
         }
         if(this.getEnvironment() == ENV_POOL)
         {
            _loc2_ = this.menuManager.createActionButton(this.actionID);
            _loc2_.setDragging(true);
            this.menuManager.addChild(_loc2_.getMovieclip());
            _loc2_.getMovieclip().x = this.menuManager.mouseX - actionNormal.width / 2;
            _loc2_.getMovieclip().y = this.menuManager.mouseY - actionNormal.height / 2;
            _loc2_.getMovieclip().startDrag();
         }
         else if(this.getEnvironment() == ENV_QUICKSTART)
         {
            _loc3_ = this.menuManager.getQuickMenu().numChildren;
            _loc4_ = this.menuManager.getQuickMenu().getChildAt(_loc3_ - 1);
            _loc5_ = this.menuManager.getQuickMenu().getQuickstartSlots();
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc6_ = _loc5_[_loc7_];
               if(_loc6_.getActionButton() == this)
               {
                  break;
               }
               _loc7_++;
            }
            this.menuManager.getQuickMenu().swapChildren(_loc6_.getMC(),_loc4_);
            this.buttonContainer.startDrag();
            this.dragging = true;
         }
      }
      
      public function getMovieclip() : MovieClip
      {
         return buttonContainer;
      }
      
      public function setDeselected() : void
      {
         actionSelected.visible = false;
      }
      
      public function setSelected() : void
      {
         actionSelected.visible = true;
         this.updateSubActionSlotPosition();
      }
      
      private function updateSubActionSlotPosition() : void
      {
         var _loc1_:int = 0;
         var _loc3_:ActionButton = null;
         var _loc4_:ButtonSlot = null;
         var _loc2_:int = -(this.menuManager.getSlotWidth() + this.menuManager.getGap()) / 2 + this.menuManager.getMainMenu().getVisibleCountGap() - 2;
         if(this.getEnvironment() == ENV_POOL && !this.isCpuButton)
         {
            if(this.isRLButton)
            {
               _loc3_ = this.menuManager.getActionButtonInPoolByID(this.menuManager.rocketIDToButtonID[Settings.selectedRocket]);
               if(_loc3_)
               {
                  _loc1_ = this.menuManager.getParentSlot(_loc3_).getMC().x + _loc2_;
                  if(_loc1_ < -(this.menuManager.getSlotWidth() * 0.5) || _loc1_ > (this.menuManager.getSlotWidth() + this.menuManager.getGap()) * 6.5)
                  {
                     this.menuManager.getMainMenu().getSubActionSlot().visible = false;
                  }
                  else
                  {
                     this.menuManager.getMainMenu().getSubActionSlot().visible = true;
                  }
                  TweenLite.to(this.menuManager.getMainMenu().getSubActionSlot(),0.15,{"x":_loc1_});
               }
            }
            else
            {
               _loc4_ = this.menuManager.getParentSlot(this);
               if(_loc4_ != null && _loc4_.getMC() != this.menuManager.getMainMenu().getSubActionSlot())
               {
                  _loc1_ = _loc4_.getMC().x + _loc2_;
                  if(_loc1_ < -(_loc4_.getMC().width * 0.5) || _loc1_ > (this.menuManager.getSlotWidth() + this.menuManager.getGap()) * 5.5)
                  {
                     this.menuManager.getMainMenu().getSubActionSlot().visible = false;
                  }
                  else
                  {
                     this.menuManager.getMainMenu().getSubActionSlot().visible = true;
                  }
                  TweenLite.to(this.menuManager.getMainMenu().getSubActionSlot(),0.15,{"x":_loc1_});
               }
            }
         }
      }
      
      public function getID() : int
      {
         return actionID;
      }
      
      public function getResKey() : String
      {
         return this.resKey;
      }
      
      public function getMenuID() : int
      {
         return this.menuID;
      }
      
      public function setDragging(param1:Boolean) : void
      {
         this.dragging = param1;
      }
      
      public function getActionMenu() : MenuManager
      {
         return this.menuManager;
      }
   }
}

