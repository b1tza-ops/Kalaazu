package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import fl.controls.Slider;
   import fl.events.SliderEvent;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.system.System;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.CheckBoxComponent;
   import net.bigpoint.darkorbit.gui.elements.SettingsField;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.elements.combobox.ComboBoxComponent;
   import net.bigpoint.darkorbit.gui.elements.combobox.ComboboxItem;
   import net.bigpoint.darkorbit.gui.elements.slider.SliderComponent;
   import net.bigpoint.darkorbit.gui.elements.slider.SliderInterval;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.SettingsAssembly;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.resolution.ResolutionPattern;
   import net.bigpoint.darkorbit.settings.Presetting;
   import net.bigpoint.darkorbit.settings.PresettingItem;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class SettingsWindowDecorator
   {
      
      private static var settingsAssemblyDict:Dictionary;
      
      private var guiManager:GuiManager;
      
      private var uiResources:SWFFinisher;
      
      private var settingTabButtons:Dictionary = new Dictionary();
      
      private var settingTabPages:Dictionary = new Dictionary();
      
      private var qualityPresetting:Presetting;
      
      private var presettingSlider:SliderComponent;
      
      private var isAdvanced:Boolean = false;
      
      private var advancedBtn:ButtonElement;
      
      private var advancedTxt:TextFieldElement;
      
      public function SettingsWindowDecorator(param1:GuiManager)
      {
         super();
         this.guiManager = param1;
         this.uiResources = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         this.qualityPresetting = new Presetting();
      }
      
      public static function getCheckBoxSettingValue(param1:int) : Boolean
      {
         switch(param1)
         {
            case SettingsField.TYPE_DISPLAY_NOTIFICATIONS:
               return Settings.displayNotifications;
            case SettingsField.TYPE_SHOW_CHAT:
               return Settings.displayChat;
            case SettingsField.TYPE_PLAY_MUSIC:
               return Settings.playMusic;
            case SettingsField.TYPE_PLAY_SFX:
               return Settings.playSFX;
            case SettingsField.TYPE_SHOW_HITPOINT_BUBBLES:
               return Settings.displayHitpointBubbles;
            case SettingsField.TYPE_SHOW_PLAYERNAMES:
               return Settings.displayPlayerNames;
            case SettingsField.TYPE_AUTO_BOOST:
               return Settings.autoBoost;
            case SettingsField.TYPE_SHOW_RESOURCES:
               return Settings.displayResources;
            case SettingsField.TYPE_SHOW_BONUS_BOXES:
               return Settings.displayBonusBoxes;
            case SettingsField.TYPE_SHOW_FREE_CARGO_BOXES:
               return Settings.displayFreeCargoBoxes;
            case SettingsField.TYPE_SHOW_NOT_FREE_CARGO_BOXES:
               return Settings.displayNotFreeCargoBoxes;
            case SettingsField.TYPE_SHOW_DRONES:
               return Settings.displayDrones;
            case SettingsField.TYPE_AUTO_AMMUNITION_CHANGE:
               return Settings.autochangeAmmo;
            case SettingsField.TYPE_AUTO_REFINEMENT:
               return Settings.autoRefinement;
            case SettingsField.TYPE_QUICKSLOT_STOP_ATTACK:
               return Settings.quickSlotStopAttack;
            case SettingsField.TYPE_AUTOSTART:
               return Settings.autoStartEnabled;
            case SettingsField.TYPE_DOUBLECLICK_ATTACK:
               return Settings.doubleclickAttackEnabled;
            case SettingsField.TYPE_DISPLAY_WINDOW_BACKGROUND:
               return Settings.showWindowsBackground;
            case SettingsField.TYPE_ALWAYS_DRAGGABLE_WINDOWS:
               return Settings.dragWindowsAlways;
            case SettingsField.TYPE_PELOAD_USER_SHIPS:
               return Settings.preloadUserShips;
            default:
               return false;
         }
      }
      
      public static function getComboBoxSettingValue(param1:int) : int
      {
         switch(param1)
         {
            case SettingsField.TYPE_RESOLUTION:
               return Settings.resolutionID;
            case SettingsField.TYPE_QUALITY_BACKGROUND:
               return Settings.qualityBackground;
            case SettingsField.TYPE_QUALITY_POIZONE:
               return Settings.qualityPoizone;
            case SettingsField.TYPE_QUALITY_SHIP:
               return Settings.qualityShip;
            case SettingsField.TYPE_QUALITY_ENGINE:
               return Settings.qualityEngine;
            case SettingsField.TYPE_QUALITY_COLLECTABLE:
               return Settings.qualityCollectable;
            case SettingsField.TYPE_QUALITY_ATTACK:
               return Settings.qualityAttack;
            case SettingsField.TYPE_QUALITY_EFFECT:
               return Settings.qualityEffect;
            case SettingsField.TYPE_QUALITY_EXPLOSION:
               return Settings.qualityExplosion;
            default:
               return 0;
         }
      }
      
      public static function getSliderSettingValue(param1:int) : int
      {
         switch(param1)
         {
            case SettingsField.TYPE_QUALITY_PRESETTING:
               return Settings.qualityPresetting;
            default:
               return 0;
         }
      }
      
      public static function setSettableSettingValue(param1:int, param2:String) : void
      {
         var _loc3_:Dictionary = getSettingsAssembleDict();
         if(_loc3_[param1] != null)
         {
            SettingsAssembly.getInstance().assembleSetting([_loc3_[param1],param2]);
         }
      }
      
      private static function getSettingsAssembleDict() : Dictionary
      {
         if(settingsAssemblyDict == null)
         {
            settingsAssemblyDict = new Dictionary();
            settingsAssemblyDict[SettingsField.TYPE_SHOW_CHAT] = ServerCommands.SET_DISPLAY_CHAT;
            settingsAssemblyDict[SettingsField.TYPE_DISPLAY_NOTIFICATIONS] = ServerCommands.SET_DISPLAY_NOTIFICATIONS;
            settingsAssemblyDict[SettingsField.TYPE_PLAY_MUSIC] = ServerCommands.SET_PLAY_MUSIC;
            settingsAssemblyDict[SettingsField.TYPE_PLAY_SFX] = ServerCommands.SET_PLAY_SFX;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_HITPOINT_BUBBLES] = ServerCommands.SET_DISPLAY_HITPOINT_BUBBLES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_PLAYERNAMES] = ServerCommands.SET_DISPLAY_PLAYER_NAMES;
            settingsAssemblyDict[SettingsField.TYPE_AUTO_BOOST] = ServerCommands.SET_AUTO_BOOST;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_RESOURCES] = ServerCommands.SET_DISPLAY_ORE;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_BONUS_BOXES] = ServerCommands.SET_DISPLAY_BONUS_BOXES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_FREE_CARGO_BOXES] = ServerCommands.SET_DISPLAY_FREE_CARGO_BOXES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_NOT_FREE_CARGO_BOXES] = ServerCommands.SET_DISPLAY_NOT_FREE_CARGO_BOXES;
            settingsAssemblyDict[SettingsField.TYPE_SHOW_DRONES] = ServerCommands.SET_SHOW_DRONES;
            settingsAssemblyDict[SettingsField.TYPE_AUTO_AMMUNITION_CHANGE] = ServerCommands.SET_AUTO_AMMO_CHANGE;
            settingsAssemblyDict[SettingsField.TYPE_AUTO_REFINEMENT] = ServerCommands.SET_AUTO_REFINEMENT;
            settingsAssemblyDict[SettingsField.TYPE_QUICKSLOT_STOP_ATTACK] = ServerCommands.SET_QUICKSLOT_STOP_ATTACK;
            settingsAssemblyDict[SettingsField.TYPE_AUTOSTART] = ServerCommands.SET_AUTO_START;
            settingsAssemblyDict[SettingsField.TYPE_DOUBLECLICK_ATTACK] = ServerCommands.SET_DOUBLECLICK_ATTACK;
            settingsAssemblyDict[SettingsField.TYPE_DISPLAY_WINDOW_BACKGROUND] = ServerCommands.SET_DISPLAY_WINDOW_BACKGROUND;
            settingsAssemblyDict[SettingsField.TYPE_ALWAYS_DRAGGABLE_WINDOWS] = ServerCommands.SET_ALWAYS_DRAGGABLE_WINDOWS;
            settingsAssemblyDict[SettingsField.TYPE_PELOAD_USER_SHIPS] = ServerCommands.SET_PRELOAD_USER_SHIPS;
            settingsAssemblyDict[SettingsField.TYPE_RESOLUTION] = ServerCommands.SET_RESOLUTION;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_PRESETTING] = ServerCommands.SET_QUALITY_PRESETTING;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_CUSTOMIZED] = ServerCommands.SET_QUALITY_CUSTOMIZED;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_BACKGROUND] = ServerCommands.SET_QUALITY_BACKGROUND;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_SHIP] = ServerCommands.SET_QUALITY_SHIP;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_POIZONE] = ServerCommands.SET_QUALITY_POIZONE;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_ENGINE] = ServerCommands.SET_QUALITY_ENGINE;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_COLLECTABLE] = ServerCommands.SET_QUALITY_COLLECTABLE;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_ATTACK] = ServerCommands.SET_QUALITY_ATTACK;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_EFFECT] = ServerCommands.SET_QUALITY_EFFECT;
            settingsAssemblyDict[SettingsField.TYPE_QUALITY_EXPLOSION] = ServerCommands.SET_QUALITY_EXPLOSION;
         }
         return settingsAssemblyDict;
      }
      
      public function decorate(param1:SimpleWindow) : void
      {
         param1.addEventListener(SimpleWindow.ON_MAXIMIZE_CLICKED,this.handleSettingsWindowRequested);
         var _loc2_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_SETTING_TABS);
         this.createTabButton(ButtonElement.TYPE_SETTINGS_TAB_DISPLAY,_loc2_,"setting_btn_display_tab",true);
         this.createTabButton(ButtonElement.TYPE_SETTINGS_TAB_GAMEPLAY,_loc2_,"setting_btn_gameplay_tab");
         this.createTabButton(ButtonElement.TYPE_SETTINGS_TAB_INTERFACE,_loc2_,"setting_btn_interface_tab");
         this.createTabButton(ButtonElement.TYPE_SETTINGS_TAB_SOUND,_loc2_,"setting_btn_sound_tab");
         this.createTabLine(_loc2_);
         param1.addContainer(_loc2_);
         _loc2_.addPredefinedPosition(new Point(20,45));
         _loc2_.setPredefinedPosition();
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_DISPLAY,ButtonElement.TYPE_SETTINGS_TAB_DISPLAY,param1,Main.gameXML.settingsDisplay.settingField,true);
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_GAMEPLAY,ButtonElement.TYPE_SETTINGS_TAB_GAMEPLAY,param1,Main.gameXML.settingsGameplay.settingField,false);
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_INTERFACE,ButtonElement.TYPE_SETTINGS_TAB_INTERFACE,param1,Main.gameXML.settingsInterface.settingField,false);
         this.renderTabPage(SimpleContainer.CLASS_SETTING_TABPAGE_SOUND,ButtonElement.TYPE_SETTINGS_TAB_SOUND,param1,Main.gameXML.settingsSound.settingField,false);
         var _loc3_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_SETTING_BUTTONS);
         var _loc4_:ButtonElement = new ButtonElement(ButtonElement.TYPE_SAVE_SETTINGS,BPLocale.getText("sett_save"),this.uiResources.getEmbededMovieClip("button1"));
         _loc4_.addEventListener(MouseEvent.CLICK,this.handleSaveButtonClick);
         _loc3_.addElement(_loc4_,SimpleContainer.ALIGN_VERTICAL);
         var _loc5_:ButtonElement = new ButtonElement(ButtonElement.TYPE_CANCEL_SETTINGS,BPLocale.getText("btn_cancel"),this.uiResources.getEmbededMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleCancelButtonClick);
         _loc3_.addElement(_loc5_,SimpleContainer.ALIGN_HORIZONTAL);
         var _loc6_:ButtonElement = new ButtonElement(ButtonElement.TYPE_RESET_SETTINGS,BPLocale.getText("btn_reset"),this.uiResources.getEmbededMovieClip("button1"));
         _loc6_.addEventListener(MouseEvent.CLICK,this.handleResetButtonClick);
         _loc3_.addElement(_loc6_,SimpleContainer.ALIGN_HORIZONTAL);
         param1.addContainer(_loc3_);
         _loc3_.addPredefinedPosition(new Point(30,param1.getWindowDimension().y - 11));
         _loc3_.setPredefinedPosition();
      }
      
      private function renderTabPage(param1:int, param2:int, param3:SimpleWindow, param4:XMLList, param5:Boolean = true) : SimpleContainer
      {
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:int = 0;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:XML = null;
         var _loc17_:Array = null;
         var _loc18_:ComboBoxComponent = null;
         var _loc19_:CheckBoxComponent = null;
         var _loc20_:XML = null;
         var _loc21_:TextFormat = null;
         var _loc22_:TextField = null;
         var _loc6_:int = 0;
         var _loc7_:SimpleContainer = new SimpleContainer(this.guiManager,param1);
         param3.addContainer(_loc7_);
         _loc7_.addPredefinedPosition(new Point(10,75));
         _loc7_.setPredefinedPosition();
         this.settingTabPages[param2] = _loc7_;
         _loc7_.visible = param5;
         for each(_loc20_ in param4)
         {
            _loc8_ = parseInt(_loc20_.@id);
            _loc9_ = _loc20_.@type;
            _loc10_ = _loc20_.@key;
            _loc12_ = _loc20_.@align;
            _loc11_ = _loc20_.@tooltipKey;
            _loc15_ = Main.parseBooleanFromString(_loc20_.@isAdvanced);
            switch(_loc9_)
            {
               case "slider":
                  _loc17_ = [];
                  for each(_loc16_ in _loc20_.item)
                  {
                     _loc13_ = int(_loc16_.@value);
                     _loc14_ = _loc16_.@languageKey;
                     _loc17_[_loc13_] = new SliderInterval(_loc13_,_loc14_);
                  }
                  this.presettingSlider = new SliderComponent(_loc8_,_loc10_,_loc17_);
                  this.presettingSlider.y = _loc6_;
                  _loc7_.addElement(this.presettingSlider,SimpleContainer.NO_ALIGN);
                  _loc6_ += 60;
                  this.presettingSlider.resetSetting();
                  this.presettingSlider.slider.addEventListener(SliderEvent.CHANGE,this.handlePresettingChanged);
                  this.advancedBtn = new ButtonElement(ButtonElement.TYPE_ADVANCED_SETTINGS,BPLocale.getText("btn_advanced"),this.uiResources.getEmbededMovieClip("button1"));
                  this.advancedBtn.addEventListener(MouseEvent.CLICK,this.handleAdvancedButtonClick);
                  this.advancedBtn.y = _loc6_;
                  _loc7_.addElement(this.advancedBtn,SimpleContainer.NO_ALIGN);
                  _loc6_ += 25;
                  this.advancedTxt = new TextFieldElement(340,40,new TextFormat(),"");
                  _loc21_ = new TextFormat(Styles.plainStdFmt.font,Styles.plainStdFontHeight,16777215);
                  _loc21_.align = TextFormatAlign.LEFT;
                  _loc22_ = this.advancedTxt.textField;
                  _loc22_.defaultTextFormat = _loc21_;
                  this.advancedTxt.updateText(BPLocale.getText("info_advanced_show"));
                  this.advancedTxt.y = _loc6_;
                  _loc7_.addElement(this.advancedTxt);
                  _loc6_ += 34;
                  break;
               case "combobox":
                  _loc17_ = [];
                  for each(_loc16_ in _loc20_.item)
                  {
                     _loc13_ = int(_loc16_.@value);
                     _loc14_ = _loc16_.@languageKey;
                     _loc17_.push(new ComboboxItem(_loc13_,BPLocale.getText(_loc14_)));
                  }
                  _loc18_ = new ComboBoxComponent(_loc8_,_loc10_,_loc17_,_loc11_,_loc15_);
                  switch(_loc12_)
                  {
                     case "right":
                        _loc7_.addElement(_loc18_,SimpleContainer.ALIGN_HORIZONTAL,40);
                        break;
                     case "left":
                     default:
                        _loc18_.y = _loc6_;
                        _loc7_.addElement(_loc18_,SimpleContainer.NO_ALIGN);
                        _loc6_ += 48;
                  }
                  _loc18_.resetSetting();
                  if(_loc15_)
                  {
                     _loc18_.addEventListener(Event.CHANGE,this.handlePresettingOverwritten);
                  }
                  break;
               case "checkbox":
                  _loc19_ = new CheckBoxComponent(_loc8_,_loc10_,this.guiManager,_loc11_,_loc15_);
                  _loc19_.y = _loc6_;
                  _loc7_.addElement(_loc19_,SimpleContainer.NO_ALIGN);
                  break;
            }
            _loc6_ += 25;
            if(_loc15_)
            {
               _loc19_.addEventListener(Event.CHANGE,this.handlePresettingOverwritten);
            }
         }
         return _loc7_;
      }
      
      private function handlePresettingOverwritten(param1:Event) : void
      {
         if(!Settings.qualityCustomized)
         {
            setSettableSettingValue(SettingsField.TYPE_QUALITY_CUSTOMIZED,String(1));
         }
         this.presettingSlider.setCurrentValueText("quality_custom");
      }
      
      private function handlePresettingChanged(param1:SliderEvent) : void
      {
         var _loc6_:SimpleElement = null;
         var _loc7_:PresettingItem = null;
         var _loc2_:Slider = Slider(param1.target);
         if(Settings.qualityCustomized)
         {
            setSettableSettingValue(SettingsField.TYPE_QUALITY_CUSTOMIZED,String(0));
         }
         var _loc3_:SimpleContainer = this.settingTabPages[ButtonElement.TYPE_SETTINGS_TAB_DISPLAY];
         var _loc4_:Array = _loc3_.getAllElements();
         var _loc5_:Array = this.qualityPresetting.getQualitySet(_loc2_.value);
         for each(_loc7_ in _loc5_)
         {
            for each(_loc6_ in _loc4_)
            {
               if(_loc6_.getID() == SimpleElement.TYPE_CHECKBOX)
               {
                  if(CheckBoxComponent(_loc6_).typeID == _loc7_.typeID)
                  {
                     CheckBoxComponent(_loc6_).switchChecked(_loc7_.value);
                  }
               }
               if(_loc6_.getID() == SimpleElement.TYPE_COMBOBOX)
               {
                  if(ComboBoxComponent(_loc6_).type == _loc7_.typeID)
                  {
                     ComboBoxComponent(_loc6_).setSelected(_loc7_.value);
                  }
               }
            }
         }
      }
      
      private function createTabButton(param1:int, param2:SimpleContainer, param3:String, param4:Boolean = false) : void
      {
         var _loc5_:ButtonElement = new ButtonElement(param1,BPLocale.getText(param3),this.uiResources.getEmbededMovieClip("button1"));
         _loc5_.selected = param4;
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleSettingsTabClick);
         param2.addElement(_loc5_,SimpleContainer.ALIGN_HORIZONTAL);
         this.settingTabButtons[param1] = _loc5_;
      }
      
      private function createTabLine(param1:SimpleContainer) : void
      {
         var _loc2_:SimpleElement = new SimpleElement(SimpleElement.TYPE_DEFAULT_ELEMENT);
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.lineStyle(1,8289918);
         _loc3_.graphics.moveTo(0,0);
         _loc3_.graphics.lineTo(380,0);
         _loc2_.addChild(_loc3_);
         _loc2_.y = 20;
         param1.addElement(_loc2_,SimpleContainer.NO_ALIGN,0);
      }
      
      private function handleSettingsTabClick(param1:MouseEvent) : void
      {
         var _loc2_:int = (param1.currentTarget as ButtonElement).getType();
         (this.settingTabButtons[ButtonElement.TYPE_SETTINGS_TAB_GAMEPLAY] as ButtonElement).selected = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_GAMEPLAY;
         (this.settingTabButtons[ButtonElement.TYPE_SETTINGS_TAB_INTERFACE] as ButtonElement).selected = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_INTERFACE;
         (this.settingTabButtons[ButtonElement.TYPE_SETTINGS_TAB_DISPLAY] as ButtonElement).selected = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_DISPLAY;
         (this.settingTabButtons[ButtonElement.TYPE_SETTINGS_TAB_SOUND] as ButtonElement).selected = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_SOUND;
         (this.settingTabPages[ButtonElement.TYPE_SETTINGS_TAB_GAMEPLAY] as SimpleContainer).visible = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_GAMEPLAY;
         (this.settingTabPages[ButtonElement.TYPE_SETTINGS_TAB_INTERFACE] as SimpleContainer).visible = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_INTERFACE;
         (this.settingTabPages[ButtonElement.TYPE_SETTINGS_TAB_DISPLAY] as SimpleContainer).visible = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_DISPLAY;
         (this.settingTabPages[ButtonElement.TYPE_SETTINGS_TAB_SOUND] as SimpleContainer).visible = _loc2_ == ButtonElement.TYPE_SETTINGS_TAB_SOUND;
      }
      
      private function handleSettingsWindowRequested(param1:Event) : void
      {
         this.resetSettingFields();
      }
      
      private function handleAdvancedButtonClick(param1:MouseEvent) : void
      {
         this.showAdvancedSettings(!this.isAdvanced);
      }
      
      private function resetAdvancedSettings() : void
      {
         this.showAdvancedSettings(Settings.qualityCustomized);
      }
      
      private function showAdvancedSettings(param1:Boolean) : void
      {
         var _loc4_:SimpleElement = null;
         this.isAdvanced = param1;
         var _loc2_:SimpleContainer = this.settingTabPages[ButtonElement.TYPE_SETTINGS_TAB_DISPLAY];
         var _loc3_:Array = _loc2_.getAllElements();
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.getID() == SimpleElement.TYPE_CHECKBOX)
            {
               if(CheckBoxComponent(_loc4_).isAdvanced)
               {
                  CheckBoxComponent(_loc4_).show(param1);
               }
            }
            if(_loc4_.getID() == SimpleElement.TYPE_COMBOBOX)
            {
               if(ComboBoxComponent(_loc4_).isAdvanced)
               {
                  ComboBoxComponent(_loc4_).show(param1);
               }
            }
         }
         if(param1)
         {
            this.advancedBtn.labelText = BPLocale.getText("btn_simple");
            this.advancedTxt.updateText(BPLocale.getText("info_simple"));
         }
         else
         {
            this.advancedBtn.labelText = BPLocale.getText("btn_advanced");
            this.advancedTxt.updateText(BPLocale.getText("info_advanced"));
         }
      }
      
      private function handleResetButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:SimpleWindow = this.guiManager.createWindow(SimpleWindow.WINDOW_CLASS_RESET_PROMPT);
         _loc2_.parent.removeChild(_loc2_);
         this.guiManager.getMain().screenManager.getWindowLayer2().addChild(_loc2_);
         var _loc3_:SimpleContainer = new SimpleContainer(this.guiManager,SimpleContainer.CLASS_PROMPT);
         var _loc4_:TextFieldElement = new TextFieldElement(280,80,new TextFormat(),"");
         var _loc5_:TextFormat = new TextFormat(Styles.plainBigFmt.font,Styles.plainBigFontHeight,16777215);
         _loc5_.align = TextFormatAlign.CENTER;
         var _loc6_:TextField = _loc4_.textField;
         _loc6_.defaultTextFormat = _loc5_;
         _loc6_.embedFonts = Styles.plainBigEmbed;
         _loc6_.antiAliasType = AntiAliasType.ADVANCED;
         _loc6_.autoSize = TextFieldAutoSize.CENTER;
         _loc6_.wordWrap = true;
         _loc6_.multiline = true;
         _loc6_.width = 280;
         _loc6_.text = BPLocale.getText("resetSettings");
         _loc3_.addElement(_loc4_);
         _loc3_.x = 16;
         _loc3_.y = 32;
         var _loc7_:ButtonElement = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("dest_ok"),this.uiResources.getEmbededMovieClip("button1"));
         _loc7_.addEventListener(MouseEvent.CLICK,this.handleConfirmResetSettingsButtonClick);
         _loc3_.addElement(_loc7_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc7_.x -= _loc7_.width;
         var _loc8_:ButtonElement = new ButtonElement(ButtonElement.TYPE_CANCEL,BPLocale.getText("btn_cancel"),this.uiResources.getEmbededMovieClip("button1"));
         _loc8_.addEventListener(MouseEvent.CLICK,this.handleResetSettingsCancel);
         _loc3_.addElement(_loc8_,SimpleContainer.ALIGN_HORIZONTAL);
         _loc2_.addContainer(_loc3_);
         _loc2_.modal = true;
      }
      
      private function handleConfirmResetSettingsButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:int = int(PatternManager.resolutionPatterns.length);
         var _loc3_:Array = [];
         var _loc4_:String = ServerCommands.CLIENT_SETTING;
         var _loc5_:String = ServerCommands.REMOVE_KEY;
         var _loc6_:String = ServerCommands.SETTING_KEY_SEPERATOR;
         var _loc7_:int = 0;
         while(_loc7_ < _loc2_)
         {
            _loc3_.push(_loc4_);
            _loc3_.push(_loc5_);
            _loc3_.push(ServerCommands.SET_SLOTMENU_POSITION + _loc6_ + _loc7_);
            _loc3_.push(_loc4_);
            _loc3_.push(_loc5_);
            _loc3_.push(ServerCommands.SET_SLOTMENU_POSITION + _loc6_ + _loc7_);
            _loc3_.push(_loc4_);
            _loc3_.push(_loc5_);
            _loc3_.push(ServerCommands.SET_MAINMENU_POSITION + _loc6_ + _loc7_);
            _loc3_.push(_loc4_);
            _loc3_.push(_loc5_);
            _loc3_.push(ServerCommands.SET_MINIMAP_SCALE + _loc6_ + _loc7_);
            _loc3_.push(_loc4_);
            _loc3_.push(_loc5_);
            _loc3_.push(ServerCommands.SET_RESIZABLE_WINDOWS + _loc6_ + _loc7_);
            _loc3_.push(_loc4_);
            _loc3_.push(_loc5_);
            _loc3_.push(ServerCommands.SET_SLOTMENU_ORDER + _loc6_ + _loc7_);
            _loc7_++;
         }
         _loc3_.push(_loc4_);
         _loc3_.push(_loc5_);
         _loc3_.push(ServerCommands.SET_QUICKBAR_SLOT);
         _loc3_.push(_loc4_);
         _loc3_.push(_loc5_);
         _loc3_.push(ServerCommands.CLIENT_RESOLUTION);
         _loc3_.push(_loc4_);
         _loc3_.push(_loc5_);
         _loc3_.push(ServerCommands.SET_QUICKSLOT_STOP_ATTACK);
         _loc3_.push(_loc4_);
         _loc3_.push(_loc5_);
         _loc3_.push(ServerCommands.SET_SHOW_DRONES);
         _loc3_.push(_loc4_);
         _loc3_.push(_loc5_);
         _loc3_.push(ServerCommands.SET_AUTO_REFINEMENT);
         _loc3_.push(_loc4_);
         _loc3_.push(_loc5_);
         _loc3_.push(ServerCommands.SET_BAR_STATUS);
         _loc3_.push(_loc4_);
         _loc3_.push(_loc5_);
         _loc3_.push(ServerCommands.WINDOW_SETTINGS + _loc6_ + Settings.resolutionID);
         _loc3_.push("1");
         this.guiManager.getMain().getConnectionManager().sendCommand(_loc3_.join(ConnectionManager.ATTRIBUTE_SEPERATOR));
         if(ExternalInterface.available)
         {
            ExternalInterface.call("clientResolutionChanged","1");
         }
         else
         {
            System.exit(0);
         }
      }
      
      private function handleResetSettingsCancel(param1:MouseEvent) : void
      {
         this.closeResetSettingsWindow();
      }
      
      private function closeResetSettingsWindow() : void
      {
         var _loc5_:SimpleElement = null;
         var _loc6_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_RESET_PROMPT);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_PROMPT);
         var _loc3_:Array = _loc2_.getAllElements();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.getID() == SimpleElement.TYPE_SIMPLE_BUTTON)
            {
               _loc6_ = ButtonElement(_loc5_);
               if(_loc6_.getID() == ButtonElement.TYPE_OK)
               {
                  _loc6_.removeEventListener(MouseEvent.CLICK,this.handleConfirmResetSettingsButtonClick);
               }
               if(_loc6_.getID() == ButtonElement.TYPE_CANCEL)
               {
                  _loc6_.removeEventListener(MouseEvent.CLICK,this.handleResetSettingsCancel);
               }
            }
            _loc4_++;
         }
         this.guiManager.closeWindow(_loc1_);
      }
      
      private function handleSaveButtonClick(param1:MouseEvent) : void
      {
         var _loc3_:SimpleContainer = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:SimpleElement = null;
         var _loc2_:SimpleWindow = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_SETTINGS);
         for each(_loc3_ in this.settingTabPages)
         {
            _loc4_ = _loc3_.getAllElements();
            _loc5_ = 0;
            while(_loc5_ < _loc4_.length)
            {
               _loc6_ = _loc4_[_loc5_];
               if(_loc6_.getID() == SimpleElement.TYPE_SLIDER)
               {
                  SliderComponent(_loc6_).setSetting();
               }
               if(_loc6_.getID() == SimpleElement.TYPE_CHECKBOX)
               {
                  CheckBoxComponent(_loc6_).setSetting();
               }
               if(_loc6_.getID() == SimpleElement.TYPE_COMBOBOX)
               {
                  ComboBoxComponent(_loc6_).setSetting();
               }
               _loc5_++;
            }
         }
         this.saveFlashSettings();
         _loc2_.minimize();
      }
      
      private function handleCancelButtonClick(param1:MouseEvent) : void
      {
         this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_SETTINGS).minimize();
      }
      
      public function resetSettingFields() : void
      {
         var _loc1_:SimpleContainer = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:SimpleElement = null;
         for each(_loc1_ in this.settingTabPages)
         {
            _loc2_ = _loc1_.getAllElements();
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length)
            {
               _loc4_ = _loc2_[_loc3_];
               if(_loc4_.getID() == SimpleElement.TYPE_SLIDER)
               {
                  SliderComponent(_loc4_).resetSetting();
               }
               if(_loc4_.getID() == SimpleElement.TYPE_CHECKBOX)
               {
                  CheckBoxComponent(_loc4_).resetSetting();
               }
               if(_loc4_.getID() == SimpleElement.TYPE_COMBOBOX)
               {
                  ComboBoxComponent(_loc4_).resetSetting();
               }
               _loc3_++;
            }
         }
         this.resetAdvancedSettings();
      }
      
      private function saveFlashSettings() : void
      {
         var _loc1_:ResolutionPattern = null;
         var _loc2_:String = null;
         var _loc3_:SimpleWindow = null;
         this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.SET_ATTRIBUTE,[ServerCommands.SET_FLASH_SETTINGS,this.getAsDigit(Settings.autoBoost),"1","1","1",this.getAsDigit(Settings.displayPlayerNames),"1","1",this.getAsDigit(Settings.displayResources),this.getAsDigit(Settings.displayBonusBoxes),"1","1",this.getAsDigit(Settings.playSFX),this.getAsDigit(Settings.playMusic),"1",this.getAsDigit(Settings.displayHitpointBubbles),Settings.selectedLaser,Settings.selectedRocket,"1",this.getAsDigit(Settings.displayChat),"0","0",this.getAsDigit(Settings.displayFreeCargoBoxes),this.getAsDigit(Settings.displayNotFreeCargoBoxes),this.getAsDigit(Settings.autochangeAmmo),"1"]);
         this.saveBooleanSetting(ServerCommands.SET_AUTO_REFINEMENT,Settings.autoRefinement);
         this.saveBooleanSetting(ServerCommands.SET_QUICKSLOT_STOP_ATTACK,Settings.quickSlotStopAttack);
         this.saveBooleanSetting(ServerCommands.SET_DOUBLECLICK_ATTACK,Settings.doubleclickAttackEnabled);
         this.saveBooleanSetting(ServerCommands.SET_AUTO_START,Settings.autoStartEnabled);
         this.saveBooleanSetting(ServerCommands.SET_DISPLAY_NOTIFICATIONS,Settings.displayNotifications);
         this.saveBooleanSetting(ServerCommands.SET_SHOW_DRONES,Settings.displayDrones);
         this.saveBooleanSetting(ServerCommands.SET_DISPLAY_WINDOW_BACKGROUND,Settings.showWindowsBackground);
         this.saveBooleanSetting(ServerCommands.SET_ALWAYS_DRAGGABLE_WINDOWS,Settings.dragWindowsAlways);
         this.saveBooleanSetting(ServerCommands.SET_PRELOAD_USER_SHIPS,Settings.preloadUserShips);
         this.saveIntSetting(ServerCommands.SET_QUALITY_PRESETTING,Settings.qualityPresetting);
         this.saveBooleanSetting(ServerCommands.SET_QUALITY_CUSTOMIZED,Settings.qualityCustomized);
         this.saveIntSetting(ServerCommands.SET_QUALITY_BACKGROUND,Settings.qualityBackground);
         this.saveIntSetting(ServerCommands.SET_QUALITY_POIZONE,Settings.qualityPoizone);
         this.saveIntSetting(ServerCommands.SET_QUALITY_SHIP,Settings.qualityShip);
         this.saveIntSetting(ServerCommands.SET_QUALITY_ENGINE,Settings.qualityEngine);
         this.saveIntSetting(ServerCommands.SET_QUALITY_COLLECTABLE,Settings.qualityCollectable);
         this.saveIntSetting(ServerCommands.SET_QUALITY_ATTACK,Settings.qualityAttack);
         this.saveIntSetting(ServerCommands.SET_QUALITY_EFFECT,Settings.qualityEffect);
         this.saveIntSetting(ServerCommands.SET_QUALITY_EXPLOSION,Settings.qualityExplosion);
         if(Settings.lastResolutionID != Settings.resolutionID)
         {
            _loc1_ = PatternManager.resolutionPatterns[Settings.resolutionID];
            _loc2_ = _loc1_.getPatternID() + ServerCommands.SETTING_PROPERTY_SEPERATOR + _loc1_.width + ServerCommands.SETTING_PROPERTY_SEPERATOR + _loc1_.height;
            this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.CLIENT_RESOLUTION,_loc2_,"1"]);
            Settings.lastResolutionID = Settings.resolutionID;
            if(ExternalInterface.available)
            {
               ExternalInterface.call("clientResolutionChanged","0");
            }
            _loc3_ = this.guiManager.getWindow(SimpleWindow.WINDOW_CLASS_WARNING_PROMPT);
            if(_loc3_ != null)
            {
               this.guiManager.closeWindow(_loc3_);
            }
            this.guiManager.createPromptWindow();
         }
         this.guiManager.updateInfoFieldView();
         this.guiManager.getMenuManager().updateAmmunitionDisplay();
         this.guiManager.getMain().screenManager.map.getMinimapManager().createMinimap();
      }
      
      private function getAsDigit(param1:Boolean) : String
      {
         return param1 ? "1" : "0";
      }
      
      private function saveBooleanSetting(param1:String, param2:Boolean) : void
      {
         this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[param1,this.getAsDigit(param2)]);
      }
      
      private function saveIntSetting(param1:String, param2:int) : void
      {
         this.guiManager.getMain().getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[param1,String(param2)]);
      }
   }
}

