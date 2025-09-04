package net.bigpoint.darkorbit.gui
{
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.utils.BPLocale;
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Expo;
   import fl.controls.TextArea;
   import fl.controls.TextInput;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.CommandLog;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.ResourceManager;
   import net.bigpoint.darkorbit.ScreenManager;
   import net.bigpoint.darkorbit.Styles;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.combat.ExplosionPattern;
   import net.bigpoint.darkorbit.data.vo.RankedHuntStatsVO;
   import net.bigpoint.darkorbit.gui.container.CLILog;
   import net.bigpoint.darkorbit.gui.container.InfoContainer;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ButtonElement;
   import net.bigpoint.darkorbit.gui.elements.ConnLostElement;
   import net.bigpoint.darkorbit.gui.elements.ConnectionElement;
   import net.bigpoint.darkorbit.gui.elements.InfoField;
   import net.bigpoint.darkorbit.gui.elements.InvasionScoreElement;
   import net.bigpoint.darkorbit.gui.elements.LogoutTextElement;
   import net.bigpoint.darkorbit.gui.elements.OreTradeModule;
   import net.bigpoint.darkorbit.gui.elements.ScoreElement;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.elements.SpaceballScoreElement;
   import net.bigpoint.darkorbit.gui.elements.SpacemapElement;
   import net.bigpoint.darkorbit.gui.elements.StarSystemView;
   import net.bigpoint.darkorbit.gui.elements.TextFieldElement;
   import net.bigpoint.darkorbit.gui.elements.VideoElement;
   import net.bigpoint.darkorbit.gui.elements.WebLinkModule;
   import net.bigpoint.darkorbit.gui.windows.BannerAdWindow;
   import net.bigpoint.darkorbit.gui.windows.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.VideoWindow;
   import net.bigpoint.darkorbit.lazyload.BannerAdLazyLoader;
   import net.bigpoint.darkorbit.map.Map;
   import net.bigpoint.darkorbit.map.MiniMap;
   import net.bigpoint.darkorbit.menu.MenuManager;
   import net.bigpoint.darkorbit.menu.SuperActionButton;
   import net.bigpoint.darkorbit.menu.TopMenu;
   import net.bigpoint.darkorbit.net.ClientCommands;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.models.SkillDesignsModel;
   import net.bigpoint.darkorbit.net.models.TechModel;
   import net.bigpoint.darkorbit.pattern.BannerAdPattern;
   import net.bigpoint.darkorbit.pattern.BoosterPattern;
   import net.bigpoint.darkorbit.pattern.OrePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.questfm.Quest;
   import net.bigpoint.darkorbit.questfm.QuestDotList;
   import net.bigpoint.darkorbit.questfm.QuestTree;
   import net.bigpoint.darkorbit.refinement.RefinementManager;
   import net.bigpoint.darkorbit.resolution.ResolutionPattern;
   import net.bigpoint.darkorbit.resolution.WindowPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.ship.MapObject;
   import net.bigpoint.darkorbit.ship.Ship;
   import net.bigpoint.darkorbit.ship.ShipPattern;
   import net.bigpoint.darkorbit.ship.TweenClip;
   
   public class GuiManager
   {
      
      public static var resizableWindowSizes:Array = [];
      
      private static var windowBlacklist:Dictionary = new Dictionary();
      
      private var uiResourses:SWFFinisher;
      
      private var guiInit:Boolean;
      
      private var main:Main;
      
      public var techModel:TechModel;
      
      public var skillDesignsModel:SkillDesignsModel;
      
      private var chatLoader:Loader;
      
      private var menuManager:MenuManager;
      
      private var topMenu:TopMenu;
      
      public var debugView:FPSModule;
      
      private var logoutBreakByUser:Boolean;
      
      private var minimizedWindowCount:int = 0;
      
      private var globalchat:MovieClip;
      
      private var nazBitmap:Bitmap;
      
      private var radiationBitmap:Bitmap;
      
      private var guiMinimized:Boolean;
      
      private var hudToggleAllowed:Boolean = true;
      
      private var minMaxTimerTimer:Timer;
      
      private var warningTimer:Timer;
      
      private var cross:MovieClip;
      
      private var checkWindowPositions:Boolean;
      
      private var _cliLog:CLILog;
      
      private var _groupUI:GroupUI;
      
      private var _invitationsUI:InvitationsUI;
      
      private var checkResizableWindows:Boolean;
      
      private var logTextArea:TextArea;
      
      private var useHTMLLog:Boolean = false;
      
      private var windows:Array = [];
      
      private var leftDynamicSlotIDs:Array = [];
      
      private var leftDynamicSlot:Array = [];
      
      private var messageBuffer:Array = [];
      
      private var cooldowns:Array = [];
      
      private var barStatus:Array = [];
      
      private var rightDynamicSlotIDs:Array = [];
      
      private var barList:Array = [];
      
      private var windowSettings:Array = [];
      
      private var _refinementManager:RefinementManager;
      
      private var promptCountdown:int = 10;
      
      private var promptTimer:Timer;
      
      private var _instantLogView:InstantLogView;
      
      private var radiationHelp:MovieClip;
      
      private var directionArrow:MovieClip;
      
      private var directionArrowTarget:Point;
      
      private var directionArrowTimer:Timer;
      
      private var _globalNotificationView:GlobalNotificationView;
      
      private var _stopoverView:StopoverView;
      
      private var updateWindowTimer:Timer;
      
      public var isChatConnected:Boolean;
      
      public function GuiManager(param1:Main)
      {
         super();
         this.main = param1;
         this.initWindowBlacklist();
         this.updateWindowTimer = new Timer(40,0);
         this.updateWindowTimer.addEventListener(TimerEvent.TIMER,this.handleUpdateWindow);
         this.updateWindowTimer.start();
      }
      
      private function handleUpdateWindow(param1:TimerEvent) : void
      {
         var _loc2_:SimpleWindow = null;
         for each(_loc2_ in this.windows)
         {
            _loc2_.refreshWindow();
         }
      }
      
      public function createEndSequence() : void
      {
         var _loc2_:Ship = null;
         var _loc3_:ShipPattern = null;
         var _loc4_:ExplosionPattern = null;
         this.main.setScheduledDisconnect(true);
         this.stopWarningTimer();
         this.showRadiationWarning(false);
         var _loc1_:Map = this.main.screenManager.map;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getShipManager().getHero();
            if(_loc2_ == null)
            {
               return;
            }
            _loc2_.cleanup();
            _loc3_ = _loc2_.shipPattern;
            if(ScreenManager.cameraLock == ScreenManager.CAMERA_LOCKED_TO_HERO)
            {
               this.main.screenManager.getHeroLayer().removeChild(_loc2_.getClipContainer());
            }
            else
            {
               this.main.screenManager.getShipLayer().removeChild(_loc2_.getClipContainer());
            }
            _loc4_ = PatternManager.getPyroPattern(ExplosionPattern.TYPE_SHIP_EXPLOSION,_loc3_.getExplodeTypeID());
            _loc1_.getCombatManager().showPyroEffect(_loc2_.x,_loc2_.y,_loc4_,37,false);
            AudioManager.playSoundEffect(18);
            this.main.screenManager.flashScreen(16777215,0.75,0.25,2);
            _loc1_.getCombatManager().showShockwave(0,_loc2_.x,_loc2_.y,true);
            this.main.screenManager.shakeScreen();
            this.main.screenManager.zoomOut();
            _loc1_.getEventManager().lockControls();
            delete _loc1_.getShipManager().getShips()[Hero.userID];
         }
         TweenMax.delayedCall(3,this.showLegacyHeroDestroyedWindow);
         this.main.screenManager.hero = null;
      }
      
      public function showLegacyHeroDestroyedWindow() : void
      {
         AudioManager.playSoundEffect(41);
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_HERO_DESTROYED);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_HERO_DESTROYED);
         }
         _loc1_.alpha = 0;
         _loc1_.modal = true;
         var _loc2_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_HERO_DESTROYED);
         var _loc3_:TextFieldElement = new TextFieldElement(_loc1_.getWindowDimension().x - 10,_loc1_.getWindowDimension().y - 60,new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215),BPLocale.getText("dest_text"));
         _loc3_.x = 10;
         _loc3_.y = 34;
         _loc2_.addElement(_loc3_);
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc5_:ButtonElement = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("dest_ok"),_loc4_.getEmbededMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleCloseClientButtonClicked);
         _loc2_.addElement(_loc5_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc1_.addContainer(_loc2_);
         if(ExternalInterface.available)
         {
            ExternalInterface.call("showHangar");
         }
         TweenLite.to(_loc1_,0.5,{"alpha":1});
      }
      
      private function handleCloseClientButtonClicked(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("bpCloseWindow","");
         }
         else
         {
            System.exit(0);
         }
      }
      
      private function initWindowBlacklist() : void
      {
      }
      
      public function addWindowToBlacklist(param1:int) : void
      {
         windowBlacklist[param1] = 1;
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            _loc2_.visible = false;
         }
         this.resortLeftSlots();
      }
      
      public function minimizeWindow(param1:int) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null && _loc2_.isMaximized() && !_loc2_.tweeening)
         {
            _loc2_.minimize();
         }
         this.resortLeftSlots();
      }
      
      public function maximizeWindow(param1:int) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null && !_loc2_.isMaximized() && !_loc2_.tweeening)
         {
            _loc2_.maximize();
         }
         this.resortLeftSlots();
      }
      
      public function removeWindowFromBlacklist(param1:int) : void
      {
         windowBlacklist[param1] = null;
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            _loc2_.visible = true;
         }
         this.resortLeftSlots();
      }
      
      public function isWindowBlacklisted(param1:int) : Boolean
      {
         if(windowBlacklist[param1] != null)
         {
            return true;
         }
         return false;
      }
      
      public function createStopoverView(param1:String, param2:int, param3:String) : void
      {
         if(this._stopoverView == null)
         {
            this._stopoverView = new StopoverView(this,ScreenManager.getScreenWidth(),ScreenManager.getScreenHeight());
         }
         this._stopoverView.updateKillMessage(param1,param2,param3);
         if(!this.main.screenManager.getWindowLayer2().contains(this._stopoverView))
         {
            this.main.screenManager.getWindowLayer2().addChild(this._stopoverView);
            this._stopoverView.x = 0;
            this._stopoverView.y = 0;
         }
      }
      
      public function removeStopoverView() : void
      {
         if(this._stopoverView != null)
         {
            this._stopoverView.dispose();
            this._stopoverView = null;
         }
      }
      
      public function flashWindowIcon(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:SimpleWindow = this.getWindow(param1);
         if(_loc4_ != null)
         {
            _loc4_.flashWindowIcon(param2);
            if(param3)
            {
               _loc4_.startPointer();
            }
         }
      }
      
      public function stopFlashWindowIcon(param1:int) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            _loc2_.stopFlashWindowIcon();
         }
      }
      
      public function showArrow(param1:int, param2:int) : void
      {
         var _loc4_:Ship = null;
         var _loc5_:Sprite = null;
         if(this.directionArrow != null)
         {
            TweenLite.to(this.directionArrowTarget,1,{
               "x":param1,
               "y":param2
            });
            return;
         }
         this.directionArrowTarget = new Point(param1,param2);
         this.directionArrow = ResourceManager.getMovieClip("ui","tutorial_arrow");
         this.directionArrow.mouseEnabled = Main.mouseEventsEnabled;
         this.directionArrow.mouseChildren = Main.mouseEventsEnabled;
         this.directionArrow.x = ScreenManager.getHalfScreenWidth();
         this.directionArrow.y = ScreenManager.getHalfScreenHeight();
         var _loc3_:Map = this.main.screenManager.map;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.getShipManager().getHero();
            if(_loc4_ != null)
            {
               this.directionArrow.alpha = 0;
               _loc5_ = this.main.screenManager.getHeroLayer();
               _loc5_.addChild(this.directionArrow);
               _loc5_.swapChildren(this.directionArrow,_loc4_.getClipContainer());
               TweenLite.to(this.directionArrow,0.5,{"alpha":1});
            }
         }
         this.stopDirectionArrowTimer();
         this.directionArrowTimer = new Timer(25,0);
         this.directionArrowTimer.addEventListener(TimerEvent.TIMER,this.updateDirectionArrow);
         this.directionArrowTimer.start();
      }
      
      public function setArrowVisibility(param1:Boolean) : void
      {
         var _loc2_:Sprite = this.main.screenManager.getHeroLayer();
         if(this.directionArrow != null && _loc2_.contains(this.directionArrow))
         {
            if(param1)
            {
               TweenLite.to(this.directionArrow,0.25,{"alpha":1});
            }
            else
            {
               TweenLite.to(this.directionArrow,0.25,{"alpha":0});
            }
         }
      }
      
      public function hideArrow() : void
      {
         this.stopDirectionArrowTimer();
         if(this.directionArrow != null)
         {
            TweenLite.to(this.directionArrow,0.5,{
               "alpha":0,
               "onComplete":this.handleDirectionArrowFadeOut
            });
         }
      }
      
      private function handleDirectionArrowFadeOut() : void
      {
         var _loc1_:Sprite = null;
         if(this.directionArrow != null)
         {
            _loc1_ = this.main.screenManager.getHeroLayer();
            if(_loc1_.contains(this.directionArrow))
            {
               _loc1_.removeChild(this.directionArrow);
               this.directionArrow = null;
               this.directionArrowTarget = null;
            }
         }
      }
      
      private function stopDirectionArrowTimer() : void
      {
         if(this.directionArrowTimer != null)
         {
            this.directionArrowTimer.stop();
            this.directionArrowTimer.removeEventListener(TimerEvent.TIMER,this.updateDirectionArrow);
            this.directionArrowTimer = null;
         }
      }
      
      private function updateDirectionArrow(param1:TimerEvent) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:Number = NaN;
         var _loc2_:Map = this.main.screenManager.map;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getShipManager().getHero();
            if(this.directionArrowTarget != null)
            {
               _loc4_ = Math.atan2(this.directionArrowTarget.y - _loc3_.y,this.directionArrowTarget.x - _loc3_.x) * 180 / Math.PI;
               this.directionArrow.rotation = _loc4_;
            }
         }
      }
      
      public function saveReferenceUiResources(param1:SWFFinisher) : void
      {
         this.uiResourses = param1;
      }
      
      public function updateRefinementWindow() : void
      {
         this._refinementManager.updateOreCounts();
      }
      
      public function setThreadIndicator(param1:int) : void
      {
         var _loc3_:MiniMap = null;
         Settings.enemyCount = param1;
         var _loc2_:Map = this.main.screenManager.map;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getMinimapManager().getMiniMap();
            if(_loc3_ != null)
            {
               _loc3_.updateThreatIndicator(param1);
            }
         }
      }
      
      public function createInstantLogView() : void
      {
         var _loc1_:InstantLogViewConfig = Settings.instantLogViewConfig;
         if(this._instantLogView == null)
         {
            this._instantLogView = new InstantLogView(_loc1_.width,_loc1_.maxEntries,_loc1_.displayTime);
            this._instantLogView.mouseChildren = false;
            this._instantLogView.mouseEnabled = false;
         }
         if(!this.main.screenManager.mainmenuLayer.contains(this._instantLogView))
         {
            this.main.screenManager.mainmenuLayer.addChild(this._instantLogView);
            this._instantLogView.x = ScreenManager.getHalfScreenWidth() - this._instantLogView.itemWidth / 2;
            this._instantLogView.y = _loc1_.y;
         }
      }
      
      public function createGlobalNotificationView() : void
      {
         if(this._globalNotificationView == null)
         {
            this._globalNotificationView = new GlobalNotificationView();
            this._globalNotificationView.mouseChildren = false;
            this._globalNotificationView.mouseEnabled = false;
         }
         if(!this.main.screenManager.mainmenuLayer.contains(this._globalNotificationView))
         {
            this.main.screenManager.mainmenuLayer.addChild(this._globalNotificationView);
            this._globalNotificationView.x = ScreenManager.getHalfScreenWidth() - this._globalNotificationView.itemWidth / 2;
            this._globalNotificationView.y = 0;
         }
      }
      
      public function createSpaceballScoreboard(param1:Array) : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:SimpleContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:SpaceballScoreElement = null;
         if(this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEBALL) == null)
         {
            _loc2_ = this.createWindow(SimpleWindow.WINDOW_CLASS_SPACEBALL);
            _loc3_ = new SimpleContainer(this,SimpleContainer.CLASS_SPACEBALL);
            _loc4_ = 0;
            _loc3_.x = 12;
            _loc3_.y = 35;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc6_ = new SpaceballScoreElement(this,_loc5_ + 1);
               _loc6_.updateScore(param1[_loc5_]);
               _loc3_.addElement(_loc6_,SimpleContainer.NO_ALIGN);
               _loc6_.x = _loc4_;
               _loc4_ += _loc6_.getBackground().width;
               _loc5_++;
            }
            _loc2_.addContainer(_loc3_);
         }
         else
         {
            this.updateScoreboard(SimpleWindow.WINDOW_CLASS_SPACEBALL,SimpleContainer.CLASS_SPACEBALL,1,0);
            this.updateScoreboard(SimpleWindow.WINDOW_CLASS_SPACEBALL,SimpleContainer.CLASS_SPACEBALL,2,0);
            this.updateScoreboard(SimpleWindow.WINDOW_CLASS_SPACEBALL,SimpleContainer.CLASS_SPACEBALL,3,0);
         }
      }
      
      public function destroyWindow(param1:int) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            this.closeWindow(_loc2_);
         }
      }
      
      public function createAutoStartWarning() : void
      {
         var _loc1_:SimpleWindow = this.createWindow(SimpleWindow.WINDOW_CLASS_AUTOSTART_WARNING);
         _loc1_.parent.removeChild(_loc1_);
         this.main.screenManager.getWindowLayer2().addChild(_loc1_);
         _loc1_.modal = true;
         var _loc2_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_AUTOSTART_WARNING);
         var _loc3_:TextFieldElement = new TextFieldElement(_loc1_.getWindowDimension().x - 32,int(Styles.simpleFmt.size),new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215),BPLocale.getText("msg_autostart_warning"));
         _loc3_.textField.autoSize = TextFieldAutoSize.CENTER;
         _loc3_.textField.wordWrap = true;
         _loc3_.textField.multiline = true;
         _loc2_.addElement(_loc3_);
         var _loc4_:ButtonElement = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("dest_ok"),this.uiResourses.getEmbededMovieClip("button1"));
         _loc4_.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClick);
         _loc2_.addElement(_loc4_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc2_.addPredefinedPosition(new Point(15,30));
         _loc2_.setPredefinedPosition();
         _loc1_.addContainer(_loc2_);
         _loc1_.autoSize();
      }
      
      public function destroyAutoStartWarning() : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_AUTOSTART_WARNING);
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getContainer(SimpleContainer.CLASS_AUTOSTART_WARNING);
            _loc3_ = _loc2_.getElement(SimpleElement.TYPE_SIMPLE_BUTTON) as ButtonElement;
            _loc3_.removeEventListener(MouseEvent.CLICK,this.handleCloseButtonClick);
            this.closeWindow(_loc1_);
         }
      }
      
      private function handleCloseButtonClick(param1:Event) : void
      {
         this.destroyAutoStartWarning();
      }
      
      public function createInvasionScoreboard(param1:Array) : void
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:SimpleContainer = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TextFieldElement = null;
         var _loc7_:InvasionScoreElement = null;
         if(this.getWindow(SimpleWindow.WINDOW_CLASS_INVASION) == null)
         {
            _loc2_ = this.createWindow(SimpleWindow.WINDOW_CLASS_INVASION);
            _loc3_ = new SimpleContainer(this,SimpleContainer.CLASS_INVASION);
            _loc4_ = 0;
            _loc3_.x = 12;
            _loc3_.y = 35;
            _loc5_ = 0;
            while(_loc5_ < param1.length)
            {
               _loc7_ = new InvasionScoreElement(this,_loc5_ + 1);
               _loc7_.updateScore(param1[_loc5_]);
               _loc3_.addElement(_loc7_,SimpleContainer.NO_ALIGN);
               _loc7_.x = _loc4_;
               _loc4_ += _loc7_.getBackground().width;
               _loc5_++;
            }
            _loc6_ = new TextFieldElement(_loc2_.getWindowDimension().x,20,new TextFormat(Styles.logFmt.font,Styles.logFmt.size,16777215),null,TextFormatAlign.LEFT);
            _loc6_.y = 40;
            _loc3_.addElement(_loc6_,SimpleContainer.NO_ALIGN);
            _loc2_.addContainer(_loc3_);
         }
      }
      
      public function setInvasionWave(param1:Number) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_INVASION);
         var _loc3_:TextFieldElement = TextFieldElement(_loc2_.getContainer(SimpleContainer.CLASS_INVASION).getElement(SimpleElement.TYPE_TEXT));
         _loc3_.updateText(BPLocale.getText("attack_wave_x").replace("%COUNT%",BPLocale.roundInteger(param1)));
      }
      
      public function updateScoreboard(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:ScoreElement = this.getScoreElement(param1,param2,param3);
         if(_loc5_ != null)
         {
            _loc5_.updateScore(param4);
         }
      }
      
      public function getScoreElement(param1:int, param2:int, param3:int) : ScoreElement
      {
         var _loc5_:Array = null;
         var _loc6_:ScoreElement = null;
         var _loc4_:SimpleWindow = this.getWindow(param1);
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_.getContainer(param2).getAllElements();
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.getCompanyID() == param3)
               {
                  return _loc6_;
               }
            }
         }
         return null;
      }
      
      public function setSpaceballSpeed(param1:int, param2:int) : void
      {
         SpaceballScoreElement(this.getScoreElement(SimpleWindow.WINDOW_CLASS_SPACEBALL,SimpleContainer.CLASS_SPACEBALL,1)).setSpeed(0);
         SpaceballScoreElement(this.getScoreElement(SimpleWindow.WINDOW_CLASS_SPACEBALL,SimpleContainer.CLASS_SPACEBALL,2)).setSpeed(0);
         SpaceballScoreElement(this.getScoreElement(SimpleWindow.WINDOW_CLASS_SPACEBALL,SimpleContainer.CLASS_SPACEBALL,3)).setSpeed(0);
         if(param1 != 0)
         {
            SpaceballScoreElement(this.getScoreElement(SimpleWindow.WINDOW_CLASS_SPACEBALL,SimpleContainer.CLASS_SPACEBALL,param1)).setSpeed(param2);
         }
      }
      
      public function saveBarView() : void
      {
         var _loc3_:InfoField = null;
         var _loc1_:String = "";
         var _loc2_:String = ",";
         for each(_loc3_ in this.barList)
         {
            _loc1_ = _loc1_ + _loc3_.getID() + _loc2_ + _loc3_.getViewMode() + _loc2_;
         }
         _loc1_ = Main.removeCommaAtEnd(_loc1_);
         this.main.getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.SET_BAR_STATUS,_loc1_]);
      }
      
      public function setBarListInfoField(param1:InfoField) : void
      {
         this.barList[param1.getID()] = param1;
      }
      
      public function updateQuestDotList() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         var _loc2_:QuestDotList = this.getQuestDotList();
         _loc2_.update();
         _loc2_.x = _loc1_.getWindow().width - _loc2_.width - 16;
      }
      
      public function addQuestDot(param1:uint) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         var _loc3_:QuestDotList = this.getQuestDotList();
         _loc3_.addQuest(param1);
         _loc3_.x = _loc2_.getWindow().width - _loc3_.width - 16;
      }
      
      public function removeQuestDot(param1:uint) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         var _loc3_:QuestDotList = this.getQuestDotList();
         _loc3_.removeQuest(param1);
         _loc3_.x = _loc2_.getWindow().width - _loc3_.width - 16;
      }
      
      private function getQuestTree() : QuestTree
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         return QuestTree(_loc1_.getContainer(SimpleContainer.CLASS_QUEST_TREE));
      }
      
      private function getQuestDotList() : QuestDotList
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         return QuestDotList(_loc1_.getContainer(SimpleContainer.CLASS_QUEST_PAGE_DOTS));
      }
      
      public function updateQuestTitle() : void
      {
         this.getQuestTree().updateQuestTitle();
      }
      
      public function clearQuestWindow() : void
      {
         this.getQuestTree().clearContent();
      }
      
      public function updateQuestConditionInWindow(param1:int) : void
      {
         this.getQuestTree().updateCondition(param1);
      }
      
      private function onTimerComplete(param1:TimerEvent) : void
      {
         this.hudToggleAllowed = true;
      }
      
      public function toggleHUD() : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleWindow = null;
         if(!this.hudToggleAllowed)
         {
            return;
         }
         if(this.getMinimizedWindowCount() == this.leftDynamicSlotIDs.length)
         {
            this.guiMinimized = true;
         }
         if(this.getMinimizedWindowCount() == 0)
         {
            this.guiMinimized = false;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.leftDynamicSlotIDs.length)
         {
            _loc2_ = int(this.leftDynamicSlotIDs[_loc1_]);
            _loc3_ = this.getWindow(_loc2_);
            if(this.guiMinimized)
            {
               if(!_loc3_.isMaximized())
               {
                  _loc3_.maximize();
                  _loc3_.saveWindowSetting(true);
               }
            }
            else if(_loc3_.isMaximized())
            {
               _loc3_.minimize();
               _loc3_.saveWindowSetting();
            }
            _loc1_++;
         }
         if(this.guiMinimized)
         {
            this.guiMinimized = false;
         }
         else
         {
            this.guiMinimized = true;
         }
         this.startHudCooldown();
      }
      
      public function startHudCooldown() : void
      {
         this.hudToggleAllowed = false;
         if(this.minMaxTimerTimer == null)
         {
            this.minMaxTimerTimer = new Timer(1200,1);
            this.minMaxTimerTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTimerComplete);
         }
         if(this.minMaxTimerTimer.running)
         {
            this.minMaxTimerTimer.stop();
         }
         this.minMaxTimerTimer.reset();
         this.minMaxTimerTimer.start();
      }
      
      public function noAmmunition(param1:String, param2:int) : void
      {
         var _loc4_:MapObject = null;
         var _loc3_:Map = this.main.screenManager.map;
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_.getShipManager().getSelectedShip();
            if(_loc4_ != null)
            {
               if(param2 == 0)
               {
                  if(param1 == "R")
                  {
                     this.writeToLog(BPLocale.getText("emptyrok"));
                     if(ExternalInterface.available)
                     {
                        ExternalInterface.call("clientEvent","rocketsEmpty");
                     }
                  }
                  else if(param1 == "L")
                  {
                     if(_loc4_ != null)
                     {
                        this.writeToLog(BPLocale.getText("attstop").replace(ConnectionManager.PARAM_1,_loc4_.getUsername()));
                     }
                     if(ExternalInterface.available)
                     {
                        ExternalInterface.call("clientEvent","laserAmmoEmpty");
                     }
                     this.writeToLog(BPLocale.getText("emptybat"));
                     this.getMenuManager().togglePoolButton(SuperActionButton.ACTIVATION_LASER,false);
                     this.main.screenManager.map.getCombatManager().removeLaserAttack(Hero.userID);
                  }
               }
               else if(param1 == "R")
               {
                  this.writeToLog(BPLocale.getText("chgrokmanual"));
               }
               else if(param1 == "L")
               {
                  if(_loc4_ != null)
                  {
                     this.writeToLog(BPLocale.getText("attstop").replace(ConnectionManager.PARAM_1,_loc4_.getUsername()));
                  }
                  this.writeToLog(BPLocale.getText("chgbatmanual"));
               }
            }
         }
      }
      
      public function showHitpointDelta(param1:MapObject, param2:int, param3:int = 0, param4:Boolean = false) : void
      {
         var _loc11_:String = null;
         var _loc12_:Point = null;
         if(ScreenManager.cameraLock == ScreenManager.CAMERA_TWEENING_TO_COORDINATE || ScreenManager.cameraLock == ScreenManager.CAMERA_TWEENING_TO_SHIP || ScreenManager.cameraLock == ScreenManager.CAMERA_TWEENING_TO_HERO)
         {
            return;
         }
         if(param3 == 0 && param1.getUserId() == Hero.userID)
         {
            param3 = 1;
         }
         var _loc5_:int = int(PatternManager.hitpointColorPatterns[param3]);
         var _loc6_:TextField = new TextField();
         var _loc7_:TextFormat = new TextFormat("Tahoma",null,_loc5_,true);
         if(param2 > 0)
         {
            _loc11_ = "";
            if(param4)
            {
               _loc11_ = "+";
            }
            _loc6_.text = _loc11_ + BPLocale.roundInteger(param2);
         }
         else if(param2 == 0)
         {
            _loc6_.text = BPLocale.getText("shot_miss");
         }
         else
         {
            _loc6_.text = BPLocale.getText("shot_hit");
         }
         _loc6_.setTextFormat(_loc7_);
         _loc6_.filters = [MapObject.filter];
         _loc6_.autoSize = TextFieldAutoSize.LEFT;
         var _loc8_:BitmapData = new BitmapData(_loc6_.width,_loc6_.height,true,0);
         _loc8_.draw(_loc6_);
         var _loc9_:Bitmap = new Bitmap(_loc8_);
         var _loc10_:Sprite = param1.getClipContainer();
         if(_loc10_ != null && _loc10_.parent != null)
         {
            _loc12_ = _loc10_.parent.localToGlobal(new Point(_loc10_.x,_loc10_.y));
            _loc9_.x = _loc12_.x - this.main.x;
            _loc9_.y = _loc12_.y - this.main.y;
            this.main.screenManager.getGUILayer0().addChild(_loc9_);
            TweenLite.to(_loc9_,1,{"y":_loc9_.y - 100});
            TweenLite.to(_loc9_,1,{
               "scaleX":3,
               "scaleY":3
            });
            TweenLite.to(_loc9_,1,{
               "delay":0.5,
               "alpha":0,
               "onComplete":this.onFinishShowHit,
               "onCompleteParams":[_loc9_]
            });
         }
      }
      
      private function onFinishShowHit(param1:Bitmap) : void
      {
         param1.parent.removeChild(param1);
      }
      
      public function addNotification(param1:String) : void
      {
         this._globalNotificationView.addMessage(param1);
      }
      
      public function writeToLog(param1:String, param2:String = "ST") : void
      {
         if(this._instantLogView != null)
         {
            this._instantLogView.addMessage(param1,LogMessageProfileFactory.getLogMessageProfile(param2));
         }
         var _loc3_:LogMessage = new LogMessage(param1);
         this.messageBuffer.push(_loc3_);
         if(this.messageBuffer.length > 25)
         {
            this.messageBuffer.shift();
            this.refreshTextField();
         }
         else
         {
            this.addToTextField(param1,true);
         }
      }
      
      private function refreshTextField() : void
      {
         var _loc3_:LogMessage = null;
         var _loc1_:* = "";
         var _loc2_:int = 0;
         while(_loc2_ < this.messageBuffer.length)
         {
            _loc3_ = this.messageBuffer[_loc2_];
            if(this.useHTMLLog)
            {
               _loc1_ += _loc3_.getMessage();
            }
            else
            {
               _loc1_ = _loc1_ + _loc3_.getMessage() + "\n";
            }
            _loc2_++;
         }
         this.addToTextField(_loc1_);
      }
      
      private function addToTextField(param1:String, param2:Boolean = false) : void
      {
         if(this.useHTMLLog)
         {
            if(param2)
            {
               this.logTextArea.htmlText += param1;
            }
            else
            {
               this.logTextArea.htmlText = param1;
            }
         }
         else if(param2)
         {
            this.logTextArea.text = this.logTextArea.text + "\n" + param1;
         }
         else
         {
            this.logTextArea.text = param1;
         }
         this.logTextArea.verticalScrollPosition = this.logTextArea.maxVerticalScrollPosition;
      }
      
      public function addCoolDown(param1:int, param2:Number) : void
      {
         if(param2 == 0 || this.cooldownExist(param1))
         {
            return;
         }
         if(this.menuManager == null)
         {
            return;
         }
         var _loc3_:CoolDown = new CoolDown(this,param1,param2);
         this.cooldowns.push(_loc3_);
      }
      
      public function cooldownExist(param1:int) : Boolean
      {
         var _loc3_:CoolDown = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.cooldowns.length)
         {
            _loc3_ = this.cooldowns[_loc2_];
            if(_loc3_.getButtonID() == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function removeCooldown(param1:CoolDown) : void
      {
         var _loc3_:CoolDown = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.cooldowns.length)
         {
            _loc3_ = this.cooldowns[_loc2_];
            if(_loc3_ == param1)
            {
               this.cooldowns.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function checkCooldowns() : void
      {
         var _loc2_:CoolDown = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.cooldowns.length)
         {
            _loc2_ = this.cooldowns[_loc1_];
            _loc2_.check();
            _loc1_++;
         }
      }
      
      public function removeAllCooldowns() : void
      {
         var _loc2_:CoolDown = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.cooldowns.length)
         {
            _loc2_ = this.cooldowns[_loc1_];
            _loc2_.cleanup();
            _loc1_++;
         }
         this.cooldowns = [];
      }
      
      public function initUpdateBoosters(param1:Array) : void
      {
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = int(param1[_loc3_]);
            _loc2_ += _loc5_;
            _loc3_++;
         }
         var _loc4_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_BOOSTER);
         if(_loc2_ > 0)
         {
            if(_loc4_ == null)
            {
               this.createBoosterWindow();
            }
            this.updateBoosterWindow(param1);
         }
         else if(_loc4_ != null)
         {
            this.closeWindow(_loc4_);
         }
      }
      
      private function createBoosterWindow() : void
      {
         var _loc1_:SimpleWindow = this.createWindow(SimpleWindow.WINDOW_CLASS_BOOSTER);
         var _loc2_:SimpleContainer = new SimpleContainer(this,SimpleWindow.WINDOW_CLASS_BOOSTER);
         _loc2_.x = 15;
         _loc2_.y = 38;
         _loc1_.addContainer(_loc2_);
      }
      
      private function updateBoosterWindow(param1:Array) : void
      {
         var _loc8_:InfoField = null;
         var _loc9_:int = 0;
         var _loc10_:BoosterPattern = null;
         var _loc11_:String = null;
         var _loc12_:BitmapData = null;
         var _loc13_:int = 0;
         var _loc14_:BarStatus = null;
         var _loc15_:InfoField = null;
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_BOOSTER);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleWindow.WINDOW_CLASS_BOOSTER);
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc5_:Array = _loc3_.getAllElements();
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc8_ = _loc5_[_loc6_];
            _loc8_.cleanup();
            _loc3_.removeChild(_loc8_);
            _loc6_++;
         }
         _loc3_.removeAllElements();
         _loc6_ = 0;
         while(_loc6_ < param1.length)
         {
            _loc9_ = int(param1[_loc6_]);
            if(_loc9_ > 0)
            {
               _loc10_ = PatternManager.boosterPatterns[_loc6_ + 1];
               _loc11_ = _loc10_.getResKey();
               _loc12_ = _loc4_.getEmbededBitmapData(_loc11_);
               _loc13_ = InfoField.MODE_BAR;
               _loc14_ = this.getBarStatus(_loc10_.getInfoFieldID());
               if(_loc14_ != null)
               {
                  _loc13_ = _loc14_.status;
               }
               _loc15_ = new InfoField(this,_loc10_.getInfoFieldID(),new Bitmap(_loc12_),-1,[_loc10_.getBarKey()],null,_loc13_);
               _loc15_.createTooltip(InGameCatalog.instance.boosterNames[_loc6_ + 1]);
               _loc3_.addElement(_loc15_,SimpleContainer.ALIGN_VERTICAL);
               _loc15_.setCounterbar(_loc9_,100,false);
               _loc15_.setLabel(_loc9_ + " %");
            }
            _loc6_++;
         }
         var _loc7_:int = _loc3_.height + 32;
         _loc2_.setDimension(110,_loc7_);
      }
      
      public function initUpdateRankedHuntStats(param1:int) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_RANKED_HUNT_EVENT);
         var _loc3_:RankedHuntStatsVO = Hero.rankedHuntingEventData.eventVOs[param1] as RankedHuntStatsVO;
         if(_loc3_ == null)
         {
            if(_loc2_ != null)
            {
               this.destroyWindow(SimpleWindow.WINDOW_CLASS_RANKED_HUNT_EVENT);
            }
         }
         if(_loc2_ == null)
         {
            this.createWindow(SimpleWindow.WINDOW_CLASS_RANKED_HUNT_EVENT);
         }
         this.updateRankedHuntStats();
      }
      
      private function updateRankedHuntStats() : void
      {
         this.updateInfoField(SimpleWindow.WINDOW_CLASS_RANKED_HUNT_EVENT,SimpleContainer.CLASS_RANKED_HUNT_EVENT,SimpleElement.TYPE_RANKED_HUNT_POINTS);
         this.updateInfoField(SimpleWindow.WINDOW_CLASS_RANKED_HUNT_EVENT,SimpleContainer.CLASS_RANKED_HUNT_EVENT_COL_2,SimpleElement.TYPE_CLAN_RANKED_CLAN_POINTS);
      }
      
      public function updateQuestWindow() : void
      {
         var _loc1_:SimpleWindow = this.createQuestWindow();
         var _loc2_:Quest = this.main.getQuestManager().privilegedQuest;
         var _loc3_:QuestTree = this.getQuestTree();
         _loc3_.quest = _loc2_;
         _loc3_.update();
         _loc3_.updateBranches();
         _loc1_.setDimension(_loc3_.width,_loc3_.visibleHeight + 24);
         var _loc4_:QuestDotList = this.getQuestDotList();
         _loc4_.x = _loc1_.getWindow().width - _loc4_.width - 16;
      }
      
      public function addGUI() : void
      {
         if(this.guiInit)
         {
            return;
         }
         this.guiInit = true;
         this.menuManager = new MenuManager(this);
         this.main.screenManager.mainmenuLayer.addChild(this.menuManager);
         this.createLogoutWindow();
         this.createHelpWindow();
         this.createTradeWindow();
         this._refinementManager = new RefinementManager(this);
         this.createSpacemapWindow();
         this.createNAZDisplay();
         if(!Settings.playMusic)
         {
            AudioManager.playSoundEffect(14);
         }
         AudioManager.playSoundEffect(20);
      }
      
      public function createTopMenu() : void
      {
         if(this.topMenu == null)
         {
            this.topMenu = new TopMenu(this);
            this.topMenu.mouseEnabled = false;
            this.main.screenManager.topmenuLayer.addChild(this.topMenu);
         }
      }
      
      private function handleChatLoadingComplete(param1:Event) : void
      {
         var _loc7_:Rectangle = null;
         this.chatLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.handleChatLoadingComplete);
         this.globalchat = MovieClip(this.chatLoader.content);
         var _loc2_:String = Settings.language;
         if(_loc2_ == "dev")
         {
            _loc2_ = "de";
         }
         if(_loc2_ == "br")
         {
            _loc2_ = "pt";
         }
         if(_loc2_ == "us")
         {
            _loc2_ = "en";
         }
         var _loc3_:SimpleWindow = this.createWindow(SimpleWindow.WINDOW_CLASS_CHAT);
         _loc3_.addEventListener(SimpleWindow.ON_RESIZED,this.handleWindowResized);
         _loc3_.addEventListener(SimpleWindow.ON_RESIZE,this.onResizeChatWindow);
         _loc3_.addEventListener(SimpleWindow.ON_MINIMIZE,this.onMinimizeChat);
         _loc3_.addEventListener(SimpleWindow.ON_MAXIMIZED,this.onMaximizeChat);
         var _loc4_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_CHAT);
         var _loc5_:SimpleElement = new SimpleElement(SimpleElement.TYPE_CHAT);
         var _loc6_:Boolean = false;
         if(Hero.level <= 4)
         {
            _loc6_ = true;
         }
         this.globalchat.initChatSecure(Hero.username,Hero.userID,Hero.sessionID,Settings.projectID,_loc2_,Hero.clan,Hero.factionID,new Point(14,30),new Rectangle(0,0,ScreenManager.getScreenWidth(),ScreenManager.getScreenHeight()),false,"http://" + Settings.chatHost + "/gamechat/as3",0,false,0,0,false,_loc6_);
         this.globalchat.addEventListener("ChatEvent.ALL_LOADED",this.handleChatLoaded);
         this.globalchat.addEventListener("ChatEvent.CONNECTED",this.handleChatConnected);
         if(!_loc3_.isMaximized())
         {
            this.globalchat.visible = false;
         }
         _loc5_.addChild(this.globalchat);
         _loc4_.addElement(_loc5_,SimpleContainer.NO_ALIGN);
         _loc3_.addContainer(_loc4_);
      }
      
      private function handleChatLoaded(param1:Event) : void
      {
         this.onResizeChatWindow(null);
      }
      
      private function handleChatConnected(param1:Event) : void
      {
         this.isChatConnected = true;
         if(this.main.getGroupManager().isInGroup())
         {
            this.main.getGroupManager().joinGroupChat();
         }
      }
      
      private function onResizeChatWindow(param1:Event) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_CHAT);
         if(this.globalchat != null && _loc2_ != null)
         {
            this.globalchat.setSize(_loc2_.getWindowDimension().x - 10,_loc2_.getWindowDimension().y - 20);
         }
      }
      
      private function onMinimizeChat(param1:Event) : void
      {
         if(this.globalchat != null)
         {
            this.globalchat.visible = false;
         }
      }
      
      private function onMaximizeChat(param1:Event) : void
      {
         if(this.globalchat != null)
         {
            this.globalchat.visible = true;
         }
      }
      
      public function getMain() : Main
      {
         return this.main;
      }
      
      public function getMenuManager() : MenuManager
      {
         return this.menuManager;
      }
      
      public function getQuestMenu() : SimpleWindow
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         if(_loc1_ == null)
         {
            this.createQuestWindow();
         }
         return _loc1_;
      }
      
      public function createMinimapWindow() : void
      {
         if(!Settings.createMinimap)
         {
            return;
         }
         var _loc1_:SimpleWindow = this.createWindow(SimpleWindow.WINDOW_CLASS_MINIMAP);
         _loc1_.addEventListener(SimpleWindow.ZOOM_IN,this.onZoomIn);
         _loc1_.addEventListener(SimpleWindow.ZOOM_OUT,this.onZoomOut);
         _loc1_.addEventListener(SimpleWindow.ON_MAXIMIZED,this.onMinimapMaximized);
         _loc1_.addEventListener(SimpleWindow.ON_MINIMIZED,this.onMinimapMinimized);
      }
      
      private function onMinimapMaximized(param1:Event) : void
      {
         var _loc3_:MiniMap = null;
         var _loc2_:Map = this.main.screenManager.map;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getMinimapManager().getMiniMap();
            _loc3_.startTimer();
         }
      }
      
      private function onMinimapMinimized(param1:Event) : void
      {
         var _loc3_:MiniMap = null;
         var _loc2_:Map = this.main.screenManager.map;
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_.getMinimapManager().getMiniMap();
            _loc3_.stopTimer();
         }
      }
      
      public function getWindow(param1:int) : SimpleWindow
      {
         return this.windows[int(param1)];
      }
      
      public function updateInfoField(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SimpleWindow = null;
         var _loc5_:SimpleWindow = null;
         var _loc6_:SimpleWindow = null;
         var _loc7_:InfoContainer = null;
         var _loc8_:InfoContainer = null;
         switch(param1)
         {
            case SimpleWindow.WINDOW_CLASS_USER:
               _loc4_ = this.getWindow(SimpleWindow.WINDOW_CLASS_USER);
               if(_loc4_ != null)
               {
                  InfoContainer(_loc4_.getContainer(param2)).updateInfoField(param3);
               }
               break;
            case SimpleWindow.WINDOW_CLASS_SHIP:
               _loc5_ = this.getWindow(SimpleWindow.WINDOW_CLASS_SHIP);
               if(_loc5_ != null)
               {
                  _loc7_ = InfoContainer(_loc5_.getContainer(param2));
                  if(_loc7_ != null)
                  {
                     _loc7_.updateInfoField(param3);
                  }
               }
               break;
            case SimpleWindow.WINDOW_CLASS_RANKED_HUNT_EVENT:
               _loc6_ = this.getWindow(SimpleWindow.WINDOW_CLASS_RANKED_HUNT_EVENT);
               if(_loc6_ != null)
               {
                  _loc8_ = InfoContainer(_loc6_.getContainer(param2));
                  if(_loc8_ != null)
                  {
                     _loc8_.updateInfoField(param3);
                  }
               }
         }
      }
      
      public function updateInfoFieldView() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_SHIP);
         var _loc2_:InfoContainer = InfoContainer(_loc1_.getContainer(SimpleContainer.CONTAINER_CLASS_HERO_INFO_0));
         if(_loc2_ != null)
         {
            _loc2_.updateInfoFieldView();
            _loc2_.setPredefinedPosition();
         }
         _loc2_ = InfoContainer(_loc1_.getContainer(SimpleContainer.CONTAINER_CLASS_HERO_INFO_1));
         if(_loc2_ != null)
         {
            _loc2_.updateInfoFieldView();
            _loc2_.setPredefinedPosition();
         }
         _loc1_.setPredefinedDimension();
      }
      
      public function closeWindow(param1:SimpleWindow) : void
      {
         this.removeFromLeftDynamicSlot(param1.getID());
         param1.cleanup();
         delete this.windows[int(param1.getID())];
      }
      
      public function deleteWindow(param1:int) : void
      {
         delete this.windows[param1];
      }
      
      public function handleDeleteWindow(param1:Event) : void
      {
         var _loc2_:SimpleWindow = param1.currentTarget as SimpleWindow;
         delete this.windows[int(_loc2_.getID())];
      }
      
      public function createBannerWindow(param1:String, param2:String = "n") : void
      {
         var _loc3_:BannerAdPattern = PatternManager.bannerAdPatterns[param1] as BannerAdPattern;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:int = _loc3_.windowID;
         var _loc5_:SimpleWindow = this.windows[int(_loc4_)];
         if(_loc5_ != null)
         {
            return;
         }
         var _loc6_:BannerAdWindow = new BannerAdWindow(this,_loc4_,param1,param2);
         _loc6_.attemptToShow();
         var _loc7_:String = BPLocale.getText("title_bannerad");
         _loc6_.label.text = _loc7_;
         this.windows[int(_loc4_)] = _loc6_;
      }
      
      public function prepareSpecialOffers() : void
      {
         BannerAdLazyLoader.loadBannerAdPatternAddon();
         Settings.specialOffersPrepared = true;
         this.main.getConnectionManager().sendRawCommand(ClientCommands.SET_SPECIAL_OFFERS_AVAILABLE);
      }
      
      public function createVideoWindow(param1:Array, param2:int, param3:int, param4:int, param5:Boolean = true, param6:String = "n", param7:int = 400, param8:int = 183) : void
      {
         var _loc12_:String = null;
         if(param2 < 1000)
         {
            return;
         }
         var _loc9_:VideoWindow = this.windows[int(param2)];
         if(_loc9_ != null)
         {
            _loc9_.languageKeys = param1;
            _loc9_.startTextWriter();
            return;
         }
         var _loc10_:VideoWindow = new VideoWindow(this,param2,param3,param4,param6,param5);
         _loc10_.addWindowDimension(new Point(param7,param8));
         _loc10_.setPredefinedDimension();
         _loc10_.languageKeys = param1;
         _loc10_.attemptToShow();
         var _loc11_:String = "";
         if(param4 == VideoElement.CLASS_COMMANDER)
         {
            _loc11_ = BPLocale.getText("video_window_header");
            _loc12_ = BPLocale.getText("video_name_" + param3);
            if(_loc12_.length > 0)
            {
               _loc11_ += " [" + _loc12_ + "]";
            }
         }
         else if(param4 == VideoElement.CLASS_HELPMOVIE)
         {
            _loc11_ = BPLocale.getText("title_helpvideo");
         }
         _loc10_.label.text = _loc11_;
         this.windows[int(param2)] = _loc10_;
      }
      
      public function removeBannerWindow(param1:String) : void
      {
         var _loc2_:BannerAdPattern = PatternManager.bannerAdPatterns[param1] as BannerAdPattern;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = _loc2_.windowID;
         var _loc4_:BannerAdWindow = this.windows[int(_loc3_)];
         if(_loc4_ != null)
         {
            _loc4_.hide();
            delete this.windows[int(_loc3_)];
         }
      }
      
      public function removeVideoWindow(param1:int) : void
      {
         var _loc2_:VideoWindow = this.windows[int(param1)];
         if(_loc2_ != null)
         {
            _loc2_.hide();
         }
      }
      
      public function showNextPageOfVideoWindow(param1:int) : void
      {
         var _loc2_:VideoWindow = this.windows[int(param1)];
         _loc2_.nextPage();
      }
      
      public function createWindow(param1:int) : SimpleWindow
      {
         var _loc2_:SimpleWindow = null;
         var _loc3_:XML = null;
         var _loc4_:int = 0;
         var _loc5_:SWFFinisher = null;
         var _loc6_:String = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = false;
         var _loc12_:Boolean = false;
         var _loc13_:int = 0;
         var _loc14_:Boolean = false;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:int = 0;
         var _loc18_:Boolean = false;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:String = null;
         var _loc22_:Boolean = false;
         var _loc23_:WindowSetting = null;
         var _loc24_:String = null;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:ResolutionPattern = null;
         var _loc28_:WindowPattern = null;
         var _loc29_:Point = null;
         var _loc30_:Bitmap = null;
         var _loc31_:int = 0;
         var _loc32_:XML = null;
         var _loc33_:XML = null;
         var _loc34_:InfoContainer = null;
         var _loc35_:int = 0;
         var _loc36_:int = 0;
         var _loc37_:int = 0;
         var _loc38_:XML = null;
         var _loc39_:Bitmap = null;
         var _loc40_:String = null;
         var _loc41_:Array = null;
         var _loc42_:int = 0;
         var _loc43_:BarStatus = null;
         var _loc44_:InfoField = null;
         var _loc45_:String = null;
         var _loc46_:String = null;
         var _loc47_:SimpleContainer = null;
         if(this.windows[int(param1)] != null)
         {
            return null;
         }
         for each(_loc3_ in Main.gameXML.windows.window)
         {
            _loc4_ = int(_loc3_.@id);
            if(_loc4_ == param1)
            {
               _loc5_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("window1"));
               _loc6_ = null;
               _loc7_ = false;
               _loc8_ = false;
               _loc9_ = false;
               _loc10_ = false;
               _loc11_ = true;
               _loc12_ = true;
               _loc13_ = SimpleWindow.SLOT_TYPE_NO_SLOT;
               _loc14_ = false;
               _loc15_ = "comb02_std.png";
               _loc16_ = "comb02_hover.png";
               _loc17_ = SimpleWindow.WINDOW_TYPE_NORMAL;
               _loc18_ = false;
               _loc19_ = false;
               _loc20_ = false;
               _loc21_ = null;
               _loc22_ = false;
               if(_loc3_.@closeable.length() > 0)
               {
                  _loc7_ = Main.parseBooleanFromString(_loc3_.@closeable);
               }
               if(_loc3_.@resizable.length() > 0)
               {
                  _loc8_ = Main.parseBooleanFromString(_loc3_.@resizable);
               }
               if(_loc3_.@zoomable.length() > 0)
               {
                  _loc9_ = Main.parseBooleanFromString(_loc3_.@zoomable);
               }
               if(_loc3_.@maximizeOnCreate.length() > 0)
               {
                  _loc20_ = Main.parseBooleanFromString(_loc3_.@maximizeOnCreate);
               }
               if(_loc3_.@helpKey.length() > 0)
               {
                  _loc21_ = _loc3_.@helpKey;
               }
               if(_loc3_.@shortcut.length() > 0)
               {
                  _loc6_ = _loc3_.@shortcut;
               }
               _loc23_ = this.getWindowSetting(param1);
               if(!_loc20_)
               {
                  if(_loc23_ != null)
                  {
                     if(_loc23_.isMaximized())
                     {
                        _loc10_ = false;
                     }
                     else
                     {
                        _loc10_ = true;
                     }
                  }
                  else if(_loc3_.@startMinimized.length() > 0)
                  {
                     _loc10_ = Main.parseBooleanFromString(_loc3_.@startMinimized);
                  }
               }
               if(_loc3_.@maximizeOnClick.length() > 0)
               {
                  _loc11_ = Main.parseBooleanFromString(_loc3_.@maximizeOnClick);
               }
               if(_loc3_.@minimizeOnClick.length() > 0)
               {
                  _loc12_ = Main.parseBooleanFromString(_loc3_.@minimizeOnClick);
               }
               _loc24_ = _loc3_.@slotType;
               if(_loc24_ == "static")
               {
                  _loc13_ = SimpleWindow.SLOT_TYPE_STATIC;
               }
               else if(_loc24_ == "left")
               {
                  _loc13_ = SimpleWindow.SLOT_TYPE_DYNAMIC_LEFT;
               }
               else if(_loc24_ == "right")
               {
                  _loc13_ = SimpleWindow.SLOT_TYPE_DYNAMIC_RIGHT;
               }
               if(_loc3_.@hudToggle.length() > 0)
               {
                  _loc18_ = Main.parseBooleanFromString(_loc3_.@hudToggle);
               }
               if(_loc3_.@alwaysInFront.length() > 0)
               {
                  _loc14_ = Main.parseBooleanFromString(_loc3_.@alwaysInFront);
               }
               if(_loc3_.@bgNormalIcon.length() > 0)
               {
                  _loc15_ = _loc3_.@bgNormalIcon;
               }
               if(_loc3_.@bgHoverIcon.length() > 0)
               {
                  _loc16_ = _loc3_.@bgHoverIcon;
               }
               if(_loc3_.@windowType.length() > 0)
               {
                  _loc17_ = int(_loc3_.@windowType);
               }
               if(_loc3_.@saveSettings.length() > 0)
               {
                  _loc19_ = Boolean(_loc3_.@saveSettings);
               }
               if(_loc3_.@transparency.length() > 0)
               {
                  _loc22_ = Boolean(_loc3_.@transparency);
               }
               _loc2_ = new SimpleWindow(this,param1,_loc5_,_loc8_,true,_loc9_,_loc7_,_loc11_,_loc12_,_loc13_,_loc14_,_loc15_,_loc16_,_loc17_,_loc19_,_loc6_,_loc22_);
               if(_loc21_ != null)
               {
                  TooltipControl.getInstance().addStickyToolTip(_loc2_,BPLocale.getText(_loc21_),this.getMain().x,this.getMain().y);
               }
               if(_loc13_ == SimpleWindow.SLOT_TYPE_DYNAMIC_LEFT)
               {
                  if(_loc18_)
                  {
                     this.leftDynamicSlotIDs.push(param1);
                  }
               }
               if(_loc13_ == SimpleWindow.SLOT_TYPE_DYNAMIC_RIGHT)
               {
                  this.rightDynamicSlotIDs.push(param1);
               }
               this.windows[int(param1)] = _loc2_;
               _loc25_ = 0;
               _loc26_ = 0;
               _loc27_ = PatternManager.resolutionPatterns[Settings.resolutionID];
               _loc28_ = _loc27_.getWindowPattern(param1);
               _loc29_ = resizableWindowSizes[param1];
               if(_loc23_ != null)
               {
                  _loc25_ = _loc23_.getX();
               }
               else if(_loc28_.isCenterHorizontal())
               {
                  _loc25_ = ScreenManager.getHalfScreenWidth() - _loc3_.@width_0 / 2;
               }
               else
               {
                  _loc25_ = _loc28_.getXPos();
               }
               if(_loc23_ != null)
               {
                  _loc26_ = _loc23_.getY();
               }
               else if(_loc28_.isCenterVertical())
               {
                  _loc26_ = ScreenManager.getHalfScreenHeight() - _loc3_.@height_0 / 2;
               }
               else
               {
                  _loc26_ = _loc28_.getYPos();
               }
               _loc30_ = null;
               if(_loc3_.@icon.length() > 0)
               {
                  _loc30_ = _loc5_.getEmbededBitmap(_loc3_.@icon);
               }
               else
               {
                  _loc30_ = _loc5_.getEmbededBitmap("info_icon.png");
               }
               _loc2_.setIcon(_loc30_);
               _loc2_.setLabelText(_loc3_.@titleKey);
               _loc2_.x = _loc25_;
               _loc2_.y = _loc26_;
               _loc2_.setLastPosition();
               for each(_loc32_ in _loc3_.infoFieldContainer)
               {
                  _loc31_ = int(_loc32_.@id);
                  _loc34_ = new InfoContainer(this,_loc31_);
                  _loc35_ = 100;
                  _loc36_ = SimpleContainer.ALIGN_VERTICAL;
                  if(_loc32_.@align.length() > 0)
                  {
                     if(_loc32_.@align == "horizontal")
                     {
                        _loc36_ = SimpleContainer.ALIGN_HORIZONTAL;
                     }
                     else if(_loc32_.@align == "noAlign")
                     {
                        _loc36_ = SimpleContainer.NO_ALIGN;
                     }
                  }
                  if(_loc32_.@x_0.length() > 0 && _loc32_.@y_0.length() > 0)
                  {
                     _loc34_.addPredefinedPosition(new Point(_loc32_.@x_0,_loc32_.@y_0));
                  }
                  if(_loc32_.@x_1.length() > 0 && _loc32_.@y_1.length() > 0)
                  {
                     _loc34_.addPredefinedPosition(new Point(_loc32_.@x_1,_loc32_.@y_1));
                  }
                  if(_loc32_.@textFieldWidth.length() > 0)
                  {
                     _loc35_ = int(_loc32_.@textFieldWidth);
                  }
                  for each(_loc38_ in _loc32_.infoField)
                  {
                     _loc4_ = int(_loc38_.@id);
                     if(_loc38_.@linkage.length() > 0)
                     {
                        _loc45_ = _loc38_.@linkage;
                        _loc5_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
                        _loc39_ = _loc5_.getEmbededBitmap(_loc45_);
                     }
                     else
                     {
                        _loc39_ = new Bitmap(new BitmapData(24,24,true,0));
                     }
                     _loc40_ = null;
                     if(_loc38_.@languageKey.length() > 0)
                     {
                        _loc40_ = _loc38_.@languageKey;
                     }
                     _loc41_ = null;
                     if(_loc38_.@bar.length() > 0)
                     {
                        _loc46_ = _loc38_.@bar;
                        _loc41_ = _loc46_.split(",");
                     }
                     _loc42_ = InfoField.MODE_BAR;
                     _loc43_ = this.getBarStatus(_loc4_);
                     if(_loc43_ != null)
                     {
                        _loc42_ = _loc43_.status;
                     }
                     if(_loc38_.@width.length() > 0)
                     {
                        _loc37_ = int(_loc38_.@width);
                     }
                     else
                     {
                        _loc37_ = -1;
                     }
                     _loc44_ = new InfoField(this,_loc4_,_loc39_,_loc37_,_loc41_,_loc40_,_loc42_);
                     switch(_loc4_)
                     {
                        case SimpleElement.TYPE_JUMP_VOUCHERS:
                        case SimpleElement.TYPE_LEVEL:
                        case SimpleElement.TYPE_CONFIGURATION:
                           _loc44_.amountSearchPattern = /%COUNT%/;
                           break;
                        case SimpleElement.TYPE_BOOTY_KEYS:
                           _loc44_.amountSearchPattern = /%AMOUNT%/;
                     }
                     if(_loc38_.@textColor.length() > 0)
                     {
                        _loc44_.setColor(parseInt("0x" + String(_loc38_.@textColor)));
                     }
                     _loc34_.addElement(_loc44_,_loc36_,1);
                  }
                  _loc2_.addContainer(_loc34_);
                  _loc34_.setPredefinedPosition();
               }
               for each(_loc33_ in _loc3_.containers.simpleContainer)
               {
                  _loc31_ = int(_loc33_.@id);
                  _loc47_ = new SimpleContainer(this,_loc31_);
                  if(_loc33_.@x.length() > 0)
                  {
                     _loc47_.x = int(_loc33_.@x);
                  }
                  if(_loc33_.@y.length() > 0)
                  {
                     _loc47_.y = int(_loc33_.@y);
                  }
                  _loc2_.addContainer(_loc47_);
               }
               ScreenManager.getWindowLayer().addChild(_loc2_);
               if(_loc10_)
               {
                  _loc2_.minimize(false);
               }
               if(_loc8_ && _loc29_ != null && param1 != SimpleWindow.WINDOW_CLASS_PET)
               {
                  _loc2_.addWindowDimension(new Point(_loc29_.x,_loc29_.y));
               }
               else
               {
                  if(_loc3_.@width_0.length() > 0 && _loc3_.@height_0.length() > 0)
                  {
                     _loc2_.addWindowDimension(new Point(_loc3_.@width_0,_loc3_.@height_0));
                  }
                  if(_loc3_.@width_1.length() > 0 && _loc3_.@height_1.length() > 0)
                  {
                     _loc2_.addWindowDimension(new Point(_loc3_.@width_1,_loc3_.@height_1));
                  }
               }
               _loc2_.setPredefinedDimension();
            }
         }
         return _loc2_;
      }
      
      public function createSettingsWindow() : void
      {
         var _loc2_:SettingsWindowDecorator = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_SETTINGS);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_SETTINGS);
            _loc2_ = new SettingsWindowDecorator(this);
            _loc2_.decorate(_loc1_);
         }
      }
      
      public function createNetworkMonitorWindow() : void
      {
         var _loc2_:NetworkMonitorWindowDecorator = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_NETWORK_MONITOR);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_NETWORK_MONITOR);
            _loc2_ = new NetworkMonitorWindowDecorator(this);
            _loc2_.decorate(_loc1_);
            this.windows[SimpleWindow.WINDOW_CLASS_NETWORK_MONITOR] = _loc1_;
         }
      }
      
      public function setNetworkConnectionStatus(param1:Boolean) : void
      {
         var _loc2_:SimpleElement = this.windows[SimpleWindow.WINDOW_CLASS_NETWORK_MONITOR].getContainer(SimpleContainer.CLASS_LOG).getElement(SimpleElement.CONNECTION_STATUS);
         var _loc3_:TextField = TextField(_loc2_.getChildAt(0));
         _loc3_.text = BPLocale.getText("label_conn_status").replace(/%CONN_STATUS%/,param1.toString());
      }
      
      public function setNetworkConnectionIP(param1:String) : void
      {
         var _loc2_:SimpleElement = this.windows[SimpleWindow.WINDOW_CLASS_NETWORK_MONITOR].getContainer(SimpleContainer.CLASS_LOG).getElement(SimpleElement.CURRENT_IP);
         var _loc3_:TextField = TextField(_loc2_.getChildAt(0));
         _loc3_.text = BPLocale.getText("label_cur_ip").replace(/%CUR_IP%/,param1);
      }
      
      public function createJackpotBattleStatusWindow() : void
      {
         var _loc2_:JackpotBattleWindowDecorator = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_JACKPOTBATTLE);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_JACKPOTBATTLE);
            _loc2_ = new JackpotBattleWindowDecorator(this);
            _loc2_.decorate(_loc1_);
            this.windows[SimpleWindow.WINDOW_CLASS_JACKPOTBATTLE] = _loc1_;
         }
      }
      
      public function setJackpotBattleRemainingPlayers(param1:int) : void
      {
         var _loc2_:SimpleElement = this.windows[SimpleWindow.WINDOW_CLASS_JACKPOTBATTLE].getContainer(SimpleContainer.CLASS_LOG).getElement(SimpleElement.TYPE_LOG_TEXTAREA);
         var _loc3_:TextField = TextField(_loc2_.getChildAt(0));
         _loc3_.text = BPLocale.getText("label_players_left").replace(/%PLAYERS_REMAINING%/,param1.toString());
      }
      
      public function createLogWindow() : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:MovieClip = null;
         var _loc4_:SimpleElement = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_LOG);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_LOG);
            _loc1_.addEventListener(SimpleWindow.ON_RESIZE,this.onResizeLogWindow);
            _loc1_.addEventListener(SimpleWindow.ON_RESIZED,this.handleWindowResized);
            _loc2_ = new SimpleContainer(this,SimpleContainer.CLASS_LOG);
            _loc3_ = new MovieClip();
            _loc3_.mouseEnabled = Main.mouseEventsEnabled;
            this.logTextArea = new TextArea();
            this.logTextArea.editable = false;
            this.logTextArea.textField.antiAliasType = AntiAliasType.ADVANCED;
            this.logTextArea.setStyle("textFormat",Styles.logFmt);
            this.logTextArea.setStyle("embedFonts",Styles.logEmbed);
            _loc3_.addChild(this.logTextArea);
            _loc4_ = new SimpleElement(SimpleElement.TYPE_LOG_TEXTAREA);
            _loc4_.addChild(_loc3_);
            _loc2_.addElement(_loc4_);
            _loc1_.addContainer(_loc2_);
            _loc2_.addPredefinedPosition(new Point(15,30));
            _loc2_.setPredefinedPosition();
            this.writeToLog(BPLocale.getText("log_boot_message"));
         }
      }
      
      public function createQuestWindow() : SimpleWindow
      {
         var _loc2_:QuestTree = null;
         var _loc3_:QuestDotList = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
            _loc1_.addEventListener(SimpleWindow.ON_RESIZE,this.onResizeQuestMenu);
            _loc2_ = new QuestTree(this.main);
            _loc2_.x = 8;
            _loc2_.y = 24;
            _loc2_.isDefaultVisible = true;
            _loc2_.setSize(_loc1_.getWindow().width - 20,_loc1_.getWindow().height - 30);
            _loc1_.addContainer(_loc2_);
            _loc3_ = new QuestDotList(this.main);
            _loc3_.y = 8;
            _loc1_.addContainer(_loc3_);
         }
         return _loc1_;
      }
      
      public function createCommandLineInterface() : void
      {
         var _loc2_:TextArea = null;
         var _loc3_:TextInput = null;
         var _loc4_:Point = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_COMMAND_LINE);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_COMMAND_LINE);
            _loc1_.addEventListener(SimpleWindow.ON_RESIZE,this.handleResizeCommandLineInterface);
            _loc1_.addEventListener(SimpleWindow.ON_RESIZED,this.handleWindowResized);
            _loc2_ = new TextArea();
            _loc3_ = new TextInput();
            this._cliLog = new CLILog(this.main);
            this._cliLog.setOutputField(_loc2_);
            this._cliLog.setInputField(_loc3_);
            _loc1_.addContainer(this._cliLog);
            this._cliLog.addPredefinedPosition(new Point(15,30));
            this._cliLog.setPredefinedPosition();
            _loc4_ = _loc1_.getWindowDimension();
            this._cliLog.setSize(_loc4_.x - 16,_loc4_.y - 24);
            this._cliLog.writeOutput("CLI initialized");
            this._cliLog.initSessionCookie();
            CommandLog.instance.addTarget(this._cliLog);
         }
      }
      
      public function createGroupWindow() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_GROUP_SYSTEM);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_GROUP_SYSTEM);
            this._groupUI = new GroupUI(this.main);
            _loc1_.addContainer(this._groupUI);
            this._groupUI.addPredefinedPosition(new Point(15,30));
            this._groupUI.setPredefinedPosition();
            this._groupUI.parentWindow = _loc1_;
         }
      }
      
      public function createTradeWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:SimpleContainer = null;
         var _loc10_:String = null;
         var _loc11_:MovieClip = null;
         var _loc12_:SWFFinisher = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:Boolean = false;
         var _loc16_:XML = null;
         var _loc17_:SWFFinisher = null;
         var _loc18_:ButtonElement = null;
         var _loc19_:ButtonElement = null;
         var _loc20_:int = 0;
         var _loc21_:OreTradeModule = null;
         var _loc6_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_TRADE);
         if(_loc6_ == null)
         {
            _loc6_ = this.createWindow(SimpleWindow.WINDOW_CLASS_TRADE);
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = new SimpleContainer(this,SimpleContainer.CLASS_TRADE_ORE);
            _loc15_ = false;
            for each(_loc16_ in Main.gameXML.tradeWindow.ores.ore)
            {
               _loc1_ = int(_loc16_.@type);
               _loc2_ = _loc16_.@languageKey;
               _loc3_ = _loc16_.@pricetagTooltipKey;
               _loc4_ = _loc16_.@gaintagTooltipKey;
               _loc5_ = _loc16_.@notavailableTooltipKey;
               _loc13_ = _loc16_.@pricetag;
               _loc14_ = _loc16_.@gaintag;
               if(_loc16_.@isRatio.length() > 0)
               {
                  _loc15_ = Main.parseBooleanFromString(_loc16_.@isRatio);
               }
               _loc21_ = new OreTradeModule(this,_loc1_,_loc2_,_loc13_,_loc14_,_loc3_,_loc4_,_loc5_,_loc15_);
               _loc21_.x = 80 * _loc7_;
               _loc7_++;
               _loc9_.addElement(_loc21_,SimpleContainer.NO_ALIGN,1);
               _loc15_ = false;
            }
            _loc6_.addContainer(_loc9_);
            _loc9_.addPredefinedPosition(new Point(10,35));
            _loc9_.setPredefinedPosition();
            _loc17_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc18_ = new ButtonElement(ButtonElement.TYPE_TRADE_SHOP,BPLocale.getText("label_trade_window_shop_button"),_loc17_.getEmbededMovieClip("generalButton"),Styles.plainBigFmt,true);
            _loc19_ = new ButtonElement(ButtonElement.TYPE_TRADE_URIDIUM,BPLocale.getText("label_trade_window_uridium_button"),_loc17_.getEmbededMovieClip("generalButton"),Styles.plainBigFmt,true);
            _loc20_ = 15;
            _loc18_.width = 270;
            _loc19_.width = 270;
            _loc18_.x = 5;
            _loc19_.x = _loc18_.width + _loc20_;
            _loc19_.y = _loc9_.height + 5;
            _loc18_.y = _loc9_.height + 5;
            _loc18_.addEventListener(MouseEvent.CLICK,this.handleShopButtonClicked);
            _loc19_.addEventListener(MouseEvent.CLICK,this.handleUridiumButtonClicked);
            _loc9_.addElement(_loc18_,SimpleContainer.NO_ALIGN);
            _loc9_.addElement(_loc19_,SimpleContainer.NO_ALIGN);
            _loc6_.addEventListener(SimpleWindow.ON_MAXIMIZE_CLICKED,this.onTradeWindowMaximizeClicked);
         }
      }
      
      private function onTradeWindowMaximizeClicked(param1:Event) : void
      {
         this.getMain().getConnectionManager().sendCommand(ServerCommands.GET_ORE_PRICES);
      }
      
      private function onTradeWindowMinimizeClicked(param1:SimpleWindow) : void
      {
      }
      
      private function handleUridiumButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = "indexInternal.es?action=internalPayment";
         if(ExternalInterface.available)
         {
            ExternalInterface.call("referToURL",Settings.dynamicHost + _loc2_);
         }
      }
      
      private function handleShopButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:String = "indexInternal.es?action=internalDock&tpl=internalDockShips";
         if(ExternalInterface.available)
         {
            ExternalInterface.call("referToURL",Settings.dynamicHost + _loc2_);
         }
      }
      
      public function showTradeWindow() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_TRADE);
         if(_loc1_ != null && !_loc1_.isMaximized())
         {
            _loc1_.maximize();
         }
      }
      
      public function updateTradeWindow() : void
      {
         var _loc6_:OreTradeModule = null;
         var _loc7_:OrePattern = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_TRADE);
         if(_loc1_ == null || !_loc1_.isMaximizeClicked() && !_loc1_.isMaximized())
         {
            return;
         }
         var _loc2_:Array = Hero.getOres([OrePattern.ORE_PROMETIUM,OrePattern.ORE_ENDURIUM,OrePattern.ORE_TERBIUM,OrePattern.ORE_PROMETID,OrePattern.ORE_DURANIUM,OrePattern.ORE_PROMERIUM,OrePattern.ORE_PALLADIUM]);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_TRADE_ORE);
         var _loc4_:Array = _loc3_.getAllElements();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            if(_loc4_[_loc5_] is OreTradeModule)
            {
               _loc6_ = _loc4_[_loc5_] as OreTradeModule;
               _loc7_ = _loc2_[_loc5_];
               if(_loc7_ != null)
               {
                  _loc6_.setOrePrice(_loc7_.price);
                  _loc6_.setOreCount(_loc7_.count);
               }
            }
            _loc5_++;
         }
      }
      
      public function cleanupTradeInfoWindow(param1:Event) : void
      {
         var _loc6_:SimpleElement = null;
         var _loc2_:SimpleWindow = param1.currentTarget as SimpleWindow;
         _loc2_.removeEventListener(SimpleWindow.ON_CLOSE,this.cleanupTradeInfoWindow);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_TRADE_ORE);
         var _loc4_:Array = _loc3_.getAllElements();
         var _loc5_:int = 0;
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_ is OreTradeModule)
            {
               OreTradeModule(_loc6_).cleanup();
            }
            else if(_loc6_ is ButtonElement)
            {
               ButtonElement(_loc6_).cleanup();
            }
            _loc5_++;
         }
         _loc3_ = _loc2_.getContainer(SimpleContainer.CLASS_TRADE_WEBLINKS1);
         _loc4_ = _loc3_.getAllElements();
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_ is WebLinkModule)
            {
               WebLinkModule(_loc6_).cleanup();
            }
            _loc5_++;
         }
         _loc3_ = _loc2_.getContainer(SimpleContainer.CLASS_TRADE_WEBLINKS2);
         _loc4_ = _loc3_.getAllElements();
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_ is WebLinkModule)
            {
               WebLinkModule(_loc6_).cleanup();
            }
            _loc5_++;
         }
      }
      
      private function onResizeLogWindow(param1:Event) : void
      {
         var _loc2_:SimpleWindow = param1.currentTarget as SimpleWindow;
         this.logTextArea.width = _loc2_.getWindow().width - 30;
         this.logTextArea.height = _loc2_.getWindow().height - 50;
      }
      
      private function handleResizeCommandLineInterface(param1:Event) : void
      {
         var _loc2_:Point = this.getWindow(SimpleWindow.WINDOW_CLASS_COMMAND_LINE).getWindowDimension();
         this._cliLog.setSize(_loc2_.x - 16,_loc2_.y - 24);
      }
      
      private function onResizeQuestMenu(param1:Event) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_QUEST_SYSTEM);
         var _loc3_:QuestTree = this.getQuestTree();
         _loc2_.setDimension(_loc3_.width,_loc3_.visibleHeight + 24);
      }
      
      public function handleWindowResized(param1:Event) : void
      {
         var _loc4_:SimpleWindow = null;
         var _loc5_:Point = null;
         var _loc2_:String = "";
         var _loc3_:String = ServerCommands.SETTING_PROPERTY_SEPERATOR;
         for each(_loc4_ in this.windows)
         {
            if(_loc4_.isResizable())
            {
               _loc5_ = _loc4_.getWindowDimension();
               _loc2_ += _loc4_.getID() + _loc3_ + _loc5_.x + _loc3_ + _loc5_.y + _loc3_;
            }
         }
         this.main.getConnectionManager().sendCommand(ServerCommands.CLIENT_SETTING,[ServerCommands.SET_RESIZABLE_WINDOWS + ServerCommands.SETTING_KEY_SEPERATOR + Settings.resolutionID,Main.removeCommaAtEnd(_loc2_)]);
      }
      
      private function onZoomIn(param1:Event) : void
      {
         if(this.main.screenManager.map != null)
         {
            this.main.screenManager.map.getMinimapManager().zoomIn();
         }
      }
      
      private function onZoomOut(param1:Event) : void
      {
         if(this.main.screenManager.map != null)
         {
            this.main.screenManager.map.getMinimapManager().zoomOut();
         }
      }
      
      public function loadChat() : void
      {
         var _loc1_:SimpleWindow = null;
         var _loc2_:SimpleContainer = null;
         var _loc3_:SimpleElement = null;
         var _loc4_:* = null;
         if(!Settings.createChat)
         {
            return;
         }
         if(!Settings.displayChat)
         {
            if(this.globalchat != null)
            {
               this.globalchat.cleanup();
               _loc1_ = this.getWindow(SimpleWindow.WINDOW_CLASS_CHAT);
               if(_loc1_ != null)
               {
                  _loc1_.removeEventListener(SimpleWindow.ON_RESIZED,this.handleWindowResized);
                  _loc1_.removeEventListener(SimpleWindow.ON_RESIZE,this.onResizeChatWindow);
                  _loc1_.removeEventListener(SimpleWindow.ON_MINIMIZE,this.onMinimizeChat);
                  _loc1_.removeEventListener(SimpleWindow.ON_MAXIMIZED,this.onMaximizeChat);
                  this.globalchat.removeEventListener("ChatEvent.ALL_LOADED",this.handleChatLoaded);
                  this.globalchat.removeEventListener("ChatEvent.CONNECTED",this.handleChatConnected);
                  _loc2_ = _loc1_.getContainer(SimpleContainer.CLASS_CHAT);
                  _loc3_ = _loc2_.getElement(SimpleElement.TYPE_CHAT);
                  if(_loc3_.contains(this.globalchat))
                  {
                     _loc3_.removeChild(this.globalchat);
                  }
                  this.closeWindow(_loc1_);
               }
               this.globalchat = null;
            }
         }
         else if(this.globalchat == null)
         {
            this.chatLoader = new Loader();
            this.chatLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.handleChatLoadingComplete);
            this.chatLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.handleChatLoadingError);
            this.chatLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleChatLoadingError);
            _loc4_ = "http://" + Settings.chatHost + "/gamechat/as3/chat.swf";
            this.chatLoader.load(new URLRequest(_loc4_),new LoaderContext(true));
         }
      }
      
      private function handleChatLoadingError(param1:*) : void
      {
      }
      
      public function createHelpWindow() : void
      {
         this.createWindow(SimpleWindow.WINDOW_CLASS_HELP);
      }
      
      public function createPromptWindow() : SimpleWindow
      {
         this.createWindow(SimpleWindow.WINDOW_CLASS_WARNING_PROMPT);
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_WARNING_PROMPT);
         var _loc2_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_PROMPT);
         var _loc3_:TextFieldElement = new TextFieldElement(_loc1_.getWindowDimension().x - 32,_loc1_.getWindowDimension().y - 100,new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215),BPLocale.getText("resolutionChange"));
         _loc3_.x = 8;
         _loc3_.y = 32;
         _loc2_.addElement(_loc3_);
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc5_:ButtonElement = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("dest_ok"),_loc4_.getEmbededMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.onClosePromptLostButtonClick);
         _loc2_.addElement(_loc5_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc1_.addContainer(_loc2_);
         _loc1_.modal = true;
         _loc1_.setDimension(-1,-1);
         if(this.promptTimer != null)
         {
            this.removePromptTimer();
         }
         this.promptTimer = new Timer(1000,0);
         this.promptTimer.addEventListener(TimerEvent.TIMER,this.handlePromptTimer);
         this.promptTimer.start();
         this.handlePromptTimer(null);
         return _loc1_;
      }
      
      private function handlePromptTimer(param1:TimerEvent) : void
      {
         var _loc6_:Array = null;
         var _loc7_:SimpleElement = null;
         var _loc8_:ButtonElement = null;
         var _loc2_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_WARNING_PROMPT);
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_PROMPT);
         var _loc4_:TextFieldElement = TextFieldElement(_loc3_.getElement(SimpleElement.TYPE_TEXT));
         var _loc5_:String = BPLocale.getText("resolutionChange");
         _loc5_ = _loc5_.replace("%SECONDS%",this.promptCountdown--);
         _loc4_.updateText(_loc5_);
         if(this.promptCountdown == -1)
         {
            this.removePromptTimer();
            _loc6_ = _loc3_.getAllElements();
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_.getID() == SimpleElement.TYPE_SIMPLE_BUTTON)
               {
                  _loc8_ = ButtonElement(_loc7_);
                  if(_loc8_.getType() == ButtonElement.TYPE_OK)
                  {
                     _loc8_.addEventListener(MouseEvent.CLICK,this.onClosePromptLostButtonClick);
                  }
               }
            }
            this.closeWindow(this.windows[SimpleWindow.WINDOW_CLASS_WARNING_PROMPT]);
         }
      }
      
      private function removePromptTimer() : void
      {
         if(this.promptTimer != null)
         {
            this.promptTimer.stop();
            this.promptTimer.removeEventListener(TimerEvent.TIMER,this.handlePromptTimer);
            this.promptCountdown = 10;
         }
      }
      
      private function onClosePromptLostButtonClick(param1:MouseEvent) : void
      {
         this.removePromptTimer();
         this.closeWindow(this.windows[SimpleWindow.WINDOW_CLASS_WARNING_PROMPT]);
      }
      
      public function showHeroDestroyedWindow() : void
      {
         AudioManager.playSoundEffect(41);
         var _loc1_:SimpleWindow = this.createWindow(SimpleWindow.WINDOW_CLASS_HERO_DESTROYED);
         _loc1_.alpha = 0;
         var _loc2_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_HERO_DESTROYED);
         var _loc3_:TextFieldElement = new TextFieldElement(_loc1_.getWindowDimension().x - 10,_loc1_.getWindowDimension().y - 60,new TextFormat(Styles.simpleFmt.font,Styles.simpleFmt.size,16777215),BPLocale.getText("dest_text"));
         _loc3_.x = 10;
         _loc3_.y = 34;
         _loc2_.addElement(_loc3_);
         var _loc4_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc5_:ButtonElement = new ButtonElement(ButtonElement.TYPE_OK,BPLocale.getText("dest_ok"),_loc4_.getEmbededMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.handleCloseClientButtonClicked);
         _loc2_.addElement(_loc5_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc1_.addContainer(_loc2_);
         if(ExternalInterface.available)
         {
            ExternalInterface.call("showHangar");
         }
         TweenLite.to(_loc1_,0.5,{"alpha":1});
      }
      
      public function createSpacemapWindow() : void
      {
         var _loc1_:SimpleWindow = this.createWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP);
         var _loc2_:SpacemapWindowDecorator = new SpacemapWindowDecorator(this);
         _loc1_.addEventListener(SimpleWindow.ON_MAXIMIZE_CLICKED,this.handleSpacemapWindowMaximize);
         _loc2_.decorate(_loc1_);
      }
      
      private function handleSpacemapWindowMaximize(param1:Event) : void
      {
         this.updateSpacemapWindow();
      }
      
      public function requestSpacemapWindowServerUpdate() : void
      {
         this.main.getConnectionManager().sendCommand(ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.GET]);
      }
      
      public function updateSpacemapWindow() : void
      {
         var _loc6_:SpacemapElement = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP);
         var _loc2_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_SPACEMAP);
         var _loc3_:SimpleContainer = _loc1_.getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc4_:SimpleElement = _loc3_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_SWITCHER);
         var _loc5_:CPUItem = Hero.cpuItems[CPUItem.TYPE_ADVANCED_JUMP] as CPUItem;
         if(_loc5_.level == 1)
         {
            _loc3_.visible = true;
            _loc2_.visible = false;
            _loc1_.setWidth(720);
            _loc1_.setHeight(560);
            _loc1_.refreshMask();
            if(!_loc4_.hasEventListener(MouseEvent.CLICK))
            {
               _loc4_.addEventListener(MouseEvent.CLICK,this.handleSwitchSystemClick);
            }
            this.setSpacemapPage(this.main.screenManager.map.getCurrentStarSystemIndex());
         }
         else
         {
            _loc1_.setWidth(_loc2_.width + 10);
            _loc1_.setHeight(_loc2_.height + 30);
            _loc3_.visible = false;
            _loc2_.visible = true;
            _loc6_ = _loc2_.getChildAt(0) as SpacemapElement;
            _loc6_.update();
         }
      }
      
      public function setAllSpacemapMapsBlocked() : void
      {
         var _loc1_:SimpleContainer = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc2_:StarSystemView = _loc1_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1).getChildAt(0) as StarSystemView;
         var _loc3_:StarSystemView = _loc1_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2).getChildAt(0) as StarSystemView;
         _loc2_.setAllMapsBlocked();
         _loc3_.setAllMapsBlocked();
      }
      
      public function setSpacemapPage(param1:int) : void
      {
         var _loc2_:SimpleContainer = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc3_:TextField = Sprite(_loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_SWITCHER).getChildAt(0)).getChildAt(0) as TextField;
         if(param1 == 0)
         {
            _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1).visible = true;
            _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2).visible = false;
            _loc3_.text = BPLocale.getText("label_switch_map_to_upper_section");
         }
         else
         {
            _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1).visible = false;
            _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2).visible = true;
            _loc3_.text = BPLocale.getText("label_switch_map_to_lower_section");
         }
      }
      
      public function updateAdvancedSpacemapWindow(param1:Array, param2:Array, param3:Array) : void
      {
         var _loc4_:SimpleContainer = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc5_:StarSystemView = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1).getChildAt(0) as StarSystemView;
         var _loc6_:StarSystemView = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2).getChildAt(0) as StarSystemView;
         var _loc7_:TextField = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_INFO_DISPLAY).getChildAt(1) as TextField;
         var _loc8_:int = this.main.screenManager.map.getMapID();
         _loc7_.text = InGameCatalog.getInstance().mapNames[_loc8_];
         _loc5_.update(_loc8_,param1,param2,param3);
         _loc6_.update(_loc8_,param1,param2,param3);
      }
      
      public function setAvailableJump(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SimpleContainer = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc5_:TextField = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_INFO_DISPLAY).getChildAt(2) as TextField;
         var _loc6_:StarSystemView = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1).getChildAt(0) as StarSystemView;
         var _loc7_:StarSystemView = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2).getChildAt(0) as StarSystemView;
         var _loc8_:String = InGameCatalog.getInstance().mapNames[param1];
         _loc5_.text = _loc8_;
         this.updateJumpPriceLabel(param2);
         this.updateJumpVoucherLabel();
         if(param3 == 1)
         {
            if(!_loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_BUTTON).hasEventListener(MouseEvent.CLICK))
            {
               _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_BUTTON).addEventListener(MouseEvent.CLICK,this.requestMapJump);
            }
            _loc6_.setSelectedMapForJump(param1);
            _loc7_.setSelectedMapForJump(param1);
            this.writeToLog(BPLocale.getText("ttip_selected_target").replace("%MAP%",_loc8_));
         }
         else
         {
            if(!_loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_BUTTON).hasEventListener(MouseEvent.CLICK))
            {
               _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_BUTTON).removeEventListener(MouseEvent.CLICK,this.requestMapJump);
            }
            _loc6_.setUnavailableMap(param1);
            _loc7_.setUnavailableMap(param1);
            this.writeToLog(BPLocale.getText("ttip_block_general"));
         }
      }
      
      public function updateJumpPriceLabel(param1:int = 0) : void
      {
         var _loc2_:SimpleContainer = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:TextField = _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_INFO_DISPLAY).getChildAt(2) as TextField;
         var _loc4_:TextField = _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_PRICE_DISPLAY).getChildAt(1) as TextField;
         if(_loc3_.text.length > 0)
         {
            if(Hero.jumpVouchersAmount > 0)
            {
               _loc4_.text = BPLocale.getText("attribute_free_cpu_jump");
               _loc4_.textColor = 16763904;
            }
            else
            {
               _loc4_.text = BPLocale.getText("pricetag_uridium_compact").replace("%VALUE%",BPLocale.roundInteger(param1));
               _loc4_.textColor = 65535;
            }
         }
      }
      
      public function updateJumpVoucherLabel() : void
      {
         var _loc1_:SimpleContainer = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc2_:TextField = _loc1_.getElement(SimpleElement.ADVANCED_SPACEMAP_JUMP_VOUCHER_LABEL).getChildByName("text") as TextField;
         _loc2_.text = BPLocale.getText("label_jump-vouchers").replace("%COUNT%",BPLocale.roundInteger(Hero.jumpVouchersAmount));
         if(Hero.jumpVouchersAmount > 0)
         {
            _loc2_.textColor = 16763904;
         }
         else
         {
            _loc2_.textColor = 65535;
         }
      }
      
      public function startCastingCostTick(param1:int, param2:int) : void
      {
         var _loc3_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP);
         var _loc4_:SimpleContainer = _loc3_.getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc5_:StarSystemView = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1).getChildAt(0) as StarSystemView;
         var _loc6_:StarSystemView = _loc4_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2).getChildAt(0) as StarSystemView;
         var _loc7_:TweenClip = new TweenClip();
         _loc7_.setClip(ResourceManager.getMovieClip("spawn0","mc"));
         this.main.screenManager.map.getShipManager().getHero().getShipContainer().addChild(_loc7_);
         if(param1 > -1)
         {
            this.main.screenManager.map.getEventManager().idleState = true;
         }
         else
         {
            this.main.screenManager.map.getEventManager().idleState = false;
            _loc3_.minimize();
         }
         _loc5_.startCastingCostTick(param1,param2);
         _loc6_.startCastingCostTick(param1,param2);
         _loc7_.playAnimation(false,1,true,true);
         this.writeToLog(BPLocale.getText("\'msg_cpu_jump_sequenz_started\'").replace("%COUNT%",param1));
      }
      
      private function requestMapJump(param1:MouseEvent) : void
      {
         this.main.getConnectionManager().sendCommand(ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.JUMP_CPU]);
      }
      
      public function handleSwitchSystemClick(param1:MouseEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc2_:SimpleContainer = this.getWindow(SimpleWindow.WINDOW_CLASS_SPACEMAP).getContainer(SimpleContainer.CLASS_SPACEMAP_ADVANCED);
         var _loc3_:SimpleElement = _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_1);
         var _loc4_:SimpleElement = _loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_2);
         var _loc5_:TextField = Sprite(_loc2_.getElement(SimpleElement.ADVANCED_SPACEMAP_SYSTEM_SWITCHER).getChildAt(0)).getChildAt(0) as TextField;
         if(_loc3_.visible)
         {
            _loc3_.visible = false;
            _loc4_.visible = true;
            if(StarSystemView(_loc4_.getChildAt(0)).lastSelectedMapForJump != null)
            {
               _loc6_ = StarSystemView(_loc4_.getChildAt(0)).lastSelectedMapForJump.id;
            }
            _loc7_ = BPLocale.getText("label_switch_map_to_lower_section");
         }
         else
         {
            _loc3_.visible = true;
            _loc4_.visible = false;
            if(StarSystemView(_loc3_.getChildAt(0)).lastSelectedMapForJump != null)
            {
               _loc6_ = StarSystemView(_loc3_.getChildAt(0)).lastSelectedMapForJump.id;
            }
            _loc7_ = BPLocale.getText("label_switch_map_to_upper_section");
         }
         _loc5_.text = _loc7_;
         this.main.getConnectionManager().sendCommand(ServerCommands.ADVANCED_JUMP_CPU,[ServerCommands.SET_STATUS,_loc6_]);
      }
      
      public function createLogoutWindow() : void
      {
         var _loc1_:SWFFinisher = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
         var _loc2_:SimpleWindow = this.createWindow(SimpleWindow.WINDOW_CLASS_LOGOUT);
         var _loc3_:SimpleContainer = new SimpleContainer(this,SimpleContainer.CLASS_LOGOUT_WINDOW);
         _loc3_.addPredefinedPosition(new Point(10,40));
         _loc3_.setPredefinedPosition();
         _loc2_.addContainer(_loc3_);
         var _loc4_:LogoutTextElement = new LogoutTextElement(this);
         _loc3_.addElement(_loc4_);
         var _loc5_:ButtonElement = new ButtonElement(ButtonElement.TYPE_CANCEL_LOGOUT,BPLocale.getText("logout_subbot"),_loc1_.getEmbededMovieClip("button1"));
         _loc5_.addEventListener(MouseEvent.CLICK,this.onLogoutWindowMinimizeClicked);
         _loc3_.addElement(_loc5_,SimpleContainer.ALIGN_VERTICAL_CENTER);
         _loc2_.setDimension(-1,_loc5_.y + _loc5_.height + _loc3_.y);
         _loc2_.addEventListener(SimpleWindow.ON_MAXIMIZED,this.onLogoutWindowMaximized);
         _loc2_.addEventListener(SimpleWindow.ON_MINIMIZE_CLICKED,this.onLogoutWindowMinimizeClicked);
         _loc2_.addEventListener(SimpleWindow.ON_MAXIMIZE_CLICKED,this.onLogoutWindowMaximizeClicked);
      }
      
      public function onLogoutWindowMaximizeClicked(param1:Event) : void
      {
         this.main.setScheduledDisconnect(false);
      }
      
      public function onLogoutWindowMaximized(param1:Event) : void
      {
         var _loc2_:Map = this.main.screenManager.map;
         if(_loc2_ != null)
         {
            _loc2_.getEventManager().moveShip(ScreenManager.centerX,ScreenManager.centerY);
            _loc2_.getEventManager().lockControls();
         }
         var _loc3_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_LOGOUT);
         var _loc4_:LogoutTextElement = LogoutTextElement(_loc3_.getContainer(SimpleContainer.CLASS_LOGOUT_WINDOW).getElement(SimpleElement.TYPE_LOGOUT_TEXT));
         _loc4_.startCountdown();
         this.main.getConnectionManager().sendCommand(ServerCommands.LOGOUT);
         AudioManager.playSoundEffect(22);
      }
      
      public function lockWindow(param1:int) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            _loc2_.lockWindow();
         }
      }
      
      public function unlockWindow(param1:int) : void
      {
         var _loc2_:SimpleWindow = this.getWindow(param1);
         if(_loc2_ != null)
         {
            _loc2_.unlockWindow();
         }
      }
      
      private function onLogoutWindowMinimizeClicked(param1:Event) : void
      {
         this.main.setScheduledDisconnect(false);
         this.logoutBreakByUser = true;
         if(param1 != null)
         {
            this.writeToLog(BPLocale.getText("logoutbreak_user"));
         }
         this.main.getConnectionManager().sendCommand(ServerCommands.LOGOUT_CANCEL_FROM_CLIENT);
      }
      
      public function logoutCancelFromServer() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_LOGOUT);
         var _loc2_:LogoutTextElement = LogoutTextElement(_loc1_.getContainer(SimpleContainer.CLASS_LOGOUT_WINDOW).getElement(SimpleElement.TYPE_LOGOUT_TEXT));
         _loc2_.stopCountdown();
         _loc1_.minimize();
         var _loc3_:Map = this.main.screenManager.map;
         if(_loc3_ != null)
         {
            _loc3_.getEventManager().unlockControls();
         }
         if(!this.logoutBreakByUser)
         {
            this.writeToLog(BPLocale.getText("logoutbreak"));
         }
         this.logoutBreakByUser = false;
      }
      
      public function getGlobalchat() : MovieClip
      {
         return this.globalchat;
      }
      
      public function showRadiationWarning(param1:Boolean) : void
      {
         var _loc2_:SWFFinisher = null;
         var _loc3_:TextField = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Map = null;
         var _loc6_:Ship = null;
         var _loc7_:Sprite = null;
         if(param1)
         {
            _loc2_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            if(this.radiationBitmap == null)
            {
               _loc3_ = new TextField();
               _loc3_.defaultTextFormat = Styles.systemSplashFmt;
               _loc3_.embedFonts = Styles.systemSplashEmbed;
               _loc3_.autoSize = TextFieldAutoSize.LEFT;
               _loc3_.height = Styles.systemSplashFontHeight + 6;
               _loc3_.textColor = 16777215;
               _loc3_.antiAliasType = "advanced";
               _loc3_.selectable = false;
               _loc3_.text = BPLocale.getText("radwarn_mid") + "\n" + BPLocale.getText("radwarn_bot");
               _loc3_.filters = [new GlowFilter(255,1,1,1,1)];
               _loc4_ = new BitmapData(_loc3_.width,_loc3_.height,true,0);
               _loc4_.draw(_loc3_);
               this.radiationBitmap = new Bitmap(_loc4_);
               this.radiationBitmap.x = ScreenManager.getHalfScreenWidth() - this.radiationBitmap.width / 2;
               this.radiationBitmap.y = ScreenManager.getHalfScreenHeight() - 150;
            }
            if(this.radiationHelp == null)
            {
               this.radiationHelp = MovieClip(_loc2_.getEmbededMovieClip("radiationHelp"));
               this.radiationHelp.mouseEnabled = Main.mouseEventsEnabled;
               this.radiationHelp.mouseChildren = Main.mouseEventsEnabled;
               this.radiationHelp.x = ScreenManager.getHalfScreenWidth();
               this.radiationHelp.y = ScreenManager.getHalfScreenHeight();
            }
            if(!this.main.screenManager.getGUILayer0().contains(this.radiationBitmap))
            {
               this.radiationBitmap.alpha = 0;
               this.main.screenManager.getGUILayer0().addChild(this.radiationBitmap);
               TweenLite.to(this.radiationBitmap,1,{"alpha":1});
               _loc5_ = this.main.screenManager.map;
               if(_loc5_ != null)
               {
                  _loc6_ = _loc5_.getShipManager().getHero();
                  if(_loc6_ != null)
                  {
                     this.updateRadiationHelp();
                     this.radiationHelp.alpha = 0;
                     _loc7_ = this.main.screenManager.getHeroLayer();
                     _loc7_.addChild(this.radiationHelp);
                     _loc7_.swapChildren(this.radiationHelp,_loc6_.getClipContainer());
                     TweenLite.to(this.radiationHelp,1,{"alpha":1});
                  }
               }
            }
            if(this.warningTimer == null)
            {
               this.warningTimer = new Timer(2000,0);
               this.warningTimer.addEventListener(TimerEvent.TIMER,this.onWarning);
               this.warningTimer.start();
            }
            else
            {
               this.warningTimer.start();
            }
         }
         else
         {
            if(this.radiationBitmap != null && this.main.screenManager.getGUILayer0().contains(this.radiationBitmap))
            {
               TweenLite.to(this.radiationBitmap,1,{
                  "alpha":0,
                  "onComplete":this.onMCFadeOut,
                  "onCompleteParams":[this.radiationBitmap]
               });
               TweenLite.to(this.radiationHelp,1,{
                  "alpha":0,
                  "onComplete":this.onMCFadeOut,
                  "onCompleteParams":[this.radiationHelp]
               });
            }
            this.stopWarningTimer();
         }
      }
      
      private function updateRadiationHelp() : void
      {
         var _loc2_:Ship = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc1_:Map = this.main.screenManager.map;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getShipManager().getHero();
            _loc3_ = _loc1_.serious_width * 0.1;
            _loc4_ = _loc1_.serious_height * 0.1;
            _loc5_ = Math.atan2(_loc4_ / 2 - _loc2_.y / 10,_loc3_ / 2 - _loc2_.x / 10) * 180 / Math.PI;
            this.radiationHelp.rotation = _loc5_;
         }
      }
      
      public function stopWarningTimer() : void
      {
         if(this.warningTimer != null)
         {
            this.warningTimer.stop();
            this.warningTimer.reset();
         }
      }
      
      private function onWarning(param1:TimerEvent) : void
      {
         AudioManager.playSoundEffect(23);
         this.main.screenManager.flashScreen(267386880);
         this.updateRadiationHelp();
      }
      
      private function onMCFadeOut(param1:DisplayObject) : void
      {
         param1.parent.removeChild(param1);
      }
      
      public function showConnectionLostWindow() : void
      {
         var _loc2_:SWFFinisher = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:SimpleContainer = null;
         var _loc6_:ConnLostElement = null;
         var _loc7_:ButtonElement = null;
         var _loc8_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_CONNECTION_LOST);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_CONNECTION_LOST);
            _loc1_.parent.removeChild(_loc1_);
            this.main.screenManager.getWindowLayer2().addChild(_loc1_);
            _loc1_.modal = true;
            _loc2_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc3_ = MovieClip(_loc2_.getEmbededMovieClip("connectionLostWindow"));
            _loc3_.mouseEnabled = Main.mouseEventsEnabled;
            _loc3_.mouseChildren = Main.mouseEventsEnabled;
            _loc4_ = TextField(_loc3_.getChildByName("bodyP"));
            _loc4_.x = 125;
            _loc4_.width = 164;
            _loc4_.defaultTextFormat = Styles.simpleFmt;
            _loc4_.embedFonts = Styles.simpleEmbed;
            _loc4_.autoSize = TextFieldAutoSize.LEFT;
            _loc4_.wordWrap = true;
            _loc4_.text = BPLocale.getText("log_verbindunghead") + "\n\n" + BPLocale.getText("log_verbindungtext");
            _loc5_ = new SimpleContainer(this,SimpleContainer.CLASS_CONNECTION_LOST);
            _loc6_ = new ConnLostElement();
            _loc6_.addChild(_loc3_);
            _loc5_.addElement(_loc6_,SimpleContainer.ALIGN_VERTICAL);
            _loc7_ = new ButtonElement(ButtonElement.TYPE_RECONNECT,BPLocale.getText("log_neueverbindung"),_loc2_.getEmbededMovieClip("button1"));
            _loc7_.addEventListener(MouseEvent.CLICK,this.handleConnectionLostButtonClick);
            _loc5_.addElement(_loc7_,SimpleContainer.ALIGN_VERTICAL);
            _loc8_ = new ButtonElement(ButtonElement.TYPE_CLOSE_APP,BPLocale.getText("log_Logout"),_loc2_.getEmbededMovieClip("button1"));
            _loc8_.addEventListener(MouseEvent.CLICK,this.handleConnectionLostButtonClick);
            _loc5_.addElement(_loc8_,SimpleContainer.ALIGN_HORIZONTAL);
            _loc5_.addPredefinedPosition(new Point(15,30));
            _loc5_.setPredefinedPosition();
            _loc1_.addContainer(_loc5_);
            _loc1_.autoSize();
         }
         else
         {
            if(_loc1_.parent != this.main.screenManager.getWindowLayer2())
            {
               this.main.screenManager.getWindowLayer2().addChild(_loc1_);
            }
            _loc1_.alpha = 1;
         }
      }
      
      private function handleConnectionLostButtonClick(param1:MouseEvent) : void
      {
         var _loc3_:SimpleWindow = null;
         var _loc2_:int = ButtonElement(param1.currentTarget).getType();
         switch(_loc2_)
         {
            case ButtonElement.TYPE_CLOSE_APP:
               if(ExternalInterface.available)
               {
                  ExternalInterface.call("bpCloseWindow","");
               }
               else
               {
                  System.exit(0);
               }
               break;
            case ButtonElement.TYPE_RECONNECT:
               _loc3_ = this.getWindow(SimpleWindow.WINDOW_CLASS_CONNECTION_LOST);
               if(_loc3_ != null)
               {
                  TweenLite.to(_loc3_,0.3,{
                     "alpha":0,
                     "onComplete":this.closeWindow,
                     "onCompleteParams":[_loc3_]
                  });
               }
               this.main.getConnectionManager().connectToMap(Settings.mapID);
         }
      }
      
      public function showConnectionWindow() : void
      {
         var _loc2_:SimpleContainer = null;
         var _loc3_:ConnectionElement = null;
         var _loc4_:SWFFinisher = null;
         var _loc5_:ButtonElement = null;
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_CONNECTION);
         if(_loc1_ == null)
         {
            _loc1_ = this.createWindow(SimpleWindow.WINDOW_CLASS_CONNECTION);
            _loc1_.parent.removeChild(_loc1_);
            this.main.screenManager.getWindowLayer2().addChild(_loc1_);
            _loc1_.modal = true;
            _loc2_ = new SimpleContainer(this,SimpleContainer.CLASS_CONNECTION);
            _loc3_ = new ConnectionElement();
            _loc3_.x = 24;
            _loc3_.y = 20;
            _loc2_.addElement(_loc3_);
            _loc4_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            _loc5_ = new ButtonElement(ButtonElement.TYPE_SELL_ORE,BPLocale.getText("log_abbruch"),_loc4_.getEmbededMovieClip("button1"));
            _loc5_.addEventListener(MouseEvent.CLICK,this.handleCancelConnectionClick);
            _loc2_.addElement(_loc5_,SimpleContainer.NO_ALIGN);
            _loc5_.x = _loc1_.getWindowDimension().x / 2 - _loc5_.width / 2 + 5;
            _loc5_.y = _loc3_.y + _loc3_.height + 10;
            _loc1_.addContainer(_loc2_);
         }
         else
         {
            if(_loc1_.parent != this.main.screenManager.getWindowLayer2())
            {
               this.main.screenManager.getWindowLayer2().addChild(_loc1_);
            }
            TweenLite.to(_loc1_,0.3,{"alpha":1});
         }
      }
      
      private function handleCancelConnectionClick(param1:MouseEvent) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("bpCloseWindow","");
         }
      }
      
      public function removeConnectionWindow() : void
      {
         var _loc1_:SimpleWindow = this.getWindow(SimpleWindow.WINDOW_CLASS_CONNECTION);
         if(_loc1_ != null)
         {
            TweenLite.to(_loc1_,1,{
               "alpha":0,
               "onComplete":this.closeWindow,
               "onCompleteParams":[_loc1_]
            });
         }
      }
      
      public function getTopMenu() : TopMenu
      {
         return this.topMenu;
      }
      
      public function increaseMinimizedWindowCount() : void
      {
         ++this.minimizedWindowCount;
      }
      
      public function decreaseMinimizedWindowCount() : void
      {
         --this.minimizedWindowCount;
      }
      
      public function getMinimizedWindowCount() : int
      {
         return this.minimizedWindowCount;
      }
      
      public function isHUDToggleAllowed() : Boolean
      {
         return this.hudToggleAllowed;
      }
      
      public function initDebugView(param1:Boolean = false) : void
      {
         if(this.debugView == null)
         {
            this.debugView = new FPSModule(this.main);
            this.main.addChild(this.debugView.view);
            this.debugView.view.visible = param1;
         }
      }
      
      public function toggleDebugView() : void
      {
         if(this.debugView == null)
         {
            this.initDebugView(true);
         }
         else if(this.debugView.view.visible)
         {
            this.debugView.view.visible = false;
         }
         else
         {
            this.debugView.view.visible = true;
         }
      }
      
      public function createNAZDisplay() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:BitmapData = null;
         if(this.nazBitmap == null)
         {
            _loc1_ = new TextField();
            _loc1_.defaultTextFormat = Styles.systemSplashFmt;
            _loc1_.embedFonts = Styles.systemSplashEmbed;
            _loc1_.autoSize = TextFieldAutoSize.LEFT;
            _loc1_.height = Styles.systemSplashFontHeight + 6;
            _loc1_.textColor = 16777215;
            _loc1_.antiAliasType = "advanced";
            _loc1_.selectable = false;
            _loc1_.text = BPLocale.getText("peacearea");
            _loc1_.filters = [new GlowFilter(255,1,1,1,1)];
            _loc2_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
            _loc2_.draw(_loc1_);
            this.nazBitmap = new Bitmap(_loc2_);
            this.nazBitmap.x = ScreenManager.getHalfScreenWidth() - this.nazBitmap.width / 2;
            this.nazBitmap.y = 200;
         }
      }
      
      public function createRadiationDisplay() : void
      {
         var _loc1_:TextField = null;
         var _loc2_:BitmapData = null;
         if(this.radiationBitmap == null)
         {
            _loc1_ = new TextField();
            _loc1_.defaultTextFormat = Styles.systemSplashFmt;
            _loc1_.embedFonts = Styles.systemSplashEmbed;
            _loc1_.autoSize = TextFieldAutoSize.LEFT;
            _loc1_.height = Styles.systemSplashFontHeight + 6;
            _loc1_.textColor = 16777215;
            _loc1_.antiAliasType = "advanced";
            _loc1_.selectable = false;
            _loc1_.text = BPLocale.getText("radwarn_mid") + "\n" + BPLocale.getText("radwarn_bot");
            _loc1_.filters = [new GlowFilter(255,1,1,1,1)];
            _loc2_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
            _loc2_.draw(_loc1_);
            this.radiationBitmap = new Bitmap(_loc2_);
            this.radiationBitmap.x = ScreenManager.getHalfScreenWidth() - this.radiationBitmap.width / 2;
            this.radiationBitmap.y = 200;
         }
      }
      
      public function displayNAZ(param1:Boolean) : void
      {
         if(this.nazBitmap == null)
         {
            return;
         }
         var _loc2_:Sprite = this.main.screenManager.getGUILayer1();
         if(param1)
         {
            if(!_loc2_.contains(this.nazBitmap))
            {
               this.nazBitmap.alpha = 0;
               _loc2_.addChild(this.nazBitmap);
               TweenLite.to(this.nazBitmap,1,{"alpha":1});
            }
         }
         else if(_loc2_.contains(this.nazBitmap))
         {
            TweenLite.to(this.nazBitmap,1,{
               "alpha":0,
               "onComplete":this.onHideNAZ
            });
         }
      }
      
      private function onHideNAZ() : void
      {
         if(TweenMax.isTweening(this.nazBitmap))
         {
            return;
         }
         var _loc1_:Sprite = this.main.screenManager.getGUILayer1();
         if(_loc1_.contains(this.nazBitmap))
         {
            _loc1_.removeChild(this.nazBitmap);
         }
      }
      
      public function addToLeftDynamicSlot(param1:int) : void
      {
         this.leftDynamicSlot.push(param1);
      }
      
      public function removeFromLeftDynamicSlot(param1:int) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.leftDynamicSlot.length)
         {
            if(param1 == this.leftDynamicSlot[_loc2_])
            {
               this.leftDynamicSlot.splice(_loc2_,1);
            }
            _loc2_++;
         }
         this.resortLeftSlots();
      }
      
      public function resortLeftSlots() : void
      {
         var _loc5_:Point = null;
         var _loc6_:SimpleWindow = null;
         var _loc1_:int = Settings.resolutionID;
         var _loc2_:ResolutionPattern = PatternManager.resolutionPatterns[int(_loc1_)];
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(_loc4_ < this.leftDynamicSlot.length)
         {
            _loc5_ = _loc2_.getMinimizedIconsPosition(_loc3_);
            if(_loc5_ != null)
            {
               _loc6_ = this.getWindow(this.leftDynamicSlot[_loc4_]);
               if(_loc6_.visible)
               {
                  TweenLite.to(_loc6_,0.5,{
                     "ease":Expo.easeOut,
                     "x":_loc5_.x,
                     "y":_loc5_.y
                  });
                  _loc3_++;
               }
            }
            _loc4_++;
         }
      }
      
      public function showCrosshair() : void
      {
         var _loc1_:SWFFinisher = null;
         if(this.cross == null)
         {
            _loc1_ = SWFFinisher(ResourceManager.fileCollection.getFinisher("ui"));
            this.cross = _loc1_.getEmbededMovieClip("cross");
            this.main.screenManager.getShipLayer().addChild(this.cross);
         }
      }
      
      public function hideCrosshair() : void
      {
         if(this.cross != null && !this.main.screenManager.getShipLayer().contains(this.cross))
         {
            TweenMax.killTweensOf(this.cross);
            this.main.screenManager.getShipLayer().removeChild(this.cross);
         }
      }
      
      public function moveCrosshairs(param1:int, param2:int) : void
      {
         if(this.cross == null)
         {
            return;
         }
         TweenLite.to(this.cross,0.25,{
            "ease":Expo.easeOut,
            "x":param1,
            "y":param2
         });
      }
      
      public function logLevelUpdate(param1:int, param2:int) : void
      {
         this.writeToLog(BPLocale.getText("lvlup_msg").replace(/%!/,param1));
         if(param2 > 0)
         {
            this.writeToLog(BPLocale.getText("lvlup_msg_p2").replace(/%!/,param2));
         }
      }
      
      public function checkWindows() : void
      {
         var _loc1_:SimpleWindow = null;
         if(this.checkWindowPositions)
         {
            for each(_loc1_ in this.windows)
            {
               if(_loc1_.isMaximized())
               {
                  _loc1_.checkPosition();
                  _loc1_.checkSize();
               }
            }
         }
      }
      
      public function checkAllResizableWindows() : void
      {
         var _loc1_:SimpleWindow = null;
         if(this.checkResizableWindows)
         {
            for each(_loc1_ in this.windows)
            {
               if(_loc1_.isResizable())
               {
                  _loc1_.checkSize();
               }
            }
            this.setCheckResizableWindows(false);
         }
      }
      
      public function setCheckWindowPositions(param1:Boolean) : void
      {
         this.checkWindowPositions = param1;
      }
      
      public function getGroupUI() : GroupUI
      {
         return this._groupUI;
      }
      
      public function getInvitationsUI() : InvitationsUI
      {
         return this._invitationsUI;
      }
      
      public function getCheckResizableWindows() : Boolean
      {
         return this.checkResizableWindows;
      }
      
      public function setCheckResizableWindows(param1:Boolean) : void
      {
         this.checkResizableWindows = param1;
      }
      
      public function get refinementManager() : RefinementManager
      {
         return this._refinementManager;
      }
      
      public function addBarStatus(param1:BarStatus) : void
      {
         this.barStatus.push(param1);
      }
      
      public function getBarStatus(param1:int) : BarStatus
      {
         var _loc2_:BarStatus = null;
         for each(_loc2_ in this.barStatus)
         {
            if(param1 == _loc2_.getID())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function addWindowSetting(param1:WindowSetting) : void
      {
         this.windowSettings.push(param1);
      }
      
      public function getWindowSetting(param1:int) : WindowSetting
      {
         var _loc2_:WindowSetting = null;
         for each(_loc2_ in this.windowSettings)
         {
            if(param1 == _loc2_.getWindowID())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function getAsDigit(param1:Boolean) : String
      {
         if(param1)
         {
            return "1";
         }
         return "0";
      }
      
      public function getWindows() : Array
      {
         return this.windows;
      }
      
      public function setDebugViewParam(param1:String, param2:String) : void
      {
         var _loc3_:Boolean = false;
         if(this.debugView == null)
         {
            this.toggleDebugView();
            _loc3_ = true;
         }
         this.debugView.setParam(param1,param2);
         if(_loc3_)
         {
            this.toggleDebugView();
         }
      }
      
      public function createPetWindow() : void
      {
         var _loc3_:PetWindowDecorator = null;
         var _loc1_:int = SimpleWindow.WINDOW_CLASS_PET;
         var _loc2_:SimpleWindow = this.getWindow(_loc1_);
         if(_loc2_ == null)
         {
            _loc2_ = this.createWindow(_loc1_);
            _loc3_ = new PetWindowDecorator(this);
            _loc3_.decorate(_loc2_);
         }
      }
   }
}

